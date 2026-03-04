#!/bin/bash

# 定義虛擬成員工作後的休息時間 (單位: 秒)
SLEEP_TIME=300

# 定義 AI 卡住的判定門檻 (連續幾次沒有變更就視為卡住並跳出)
STUCK_LIMIT=3 
CONSECUTIVE_NO_CHANGES=0

echo "🚀 開始啟動虛擬團隊 (PM & Coder) 自動開發迴圈..."

# 確保必要目錄存在
mkdir -p docs
mkdir -p .prompts

# 確保當前目錄已經是 Git 儲存庫，若無則初始化
if [ ! -d ".git" ]; then
    echo "📦 尚未偵測到 Git 儲存庫，正在初始化..."
    git init
    git add .
    git commit -m "chore: initial commit for idle-game-2026-2"
fi

# 定義清理環境的函式
prepare_clean_env() {
    echo "🧹 正在清理工作區，確保從 Clean 狀態開始..."
    git reset --hard HEAD > /dev/null
    git clean -fd > /dev/null
}

# 定義讀取 message 並 commit 的函式
commit_changes() {
    local role=$1
    local default_msg=$2
    local commit_msg="$default_msg"
    
    # 修正：先讀取並移除 .commit_msg，避免被 git add . 加進去
    if [ -f ".commit_msg" ]; then
        commit_msg=$(cat .commit_msg)
        rm .commit_msg
    fi

    git add .
    
    # 檢查是否有實際的檔案變動
    if ! git diff --cached --quiet; then
        git commit -m "$commit_msg"
        return 0 # 回傳 0 表示有實質變更
    else
        echo "ℹ️ [$role] 沒有偵測到任何檔案變更，跳過 Commit。"
        return 1 # 回傳 1 表示毫無變更
    fi
}

while true; do
    echo "=================================================="
    
    # 檢查是否所有目標都已完成 (docs/GOALS.md 中沒有 [TODO] 且沒有 [IN PROGRESS])
    if ! grep -q "\[TODO\]\|\[IN PROGRESS\]" docs/GOALS.md; then
        echo "🎉 [$(date '+%Y-%m-%d %H:%M:%S')] 偵測到 docs/GOALS.md 中的任務已全數完成！結束自動開發迴圈。"
        break
    fi

    prepare_clean_env
    
    echo "👔 [PM] 正在讀取進度、維護計畫並指派下一個任務..."
    echo "⏱️ [PM 開始時間]: $(date '+%Y-%m-%d %H:%M:%S')"
    
    # 處理 PM 執行結果
    if ! claude -p "$(cat .prompts/pm.txt)" --allowedTools "Bash,Read,Edit,Write"; then
        echo "⚠️ [$(date '+%Y-%m-%d %H:%M:%S')] PM 執行發生錯誤 (可能為 API 限制或網路中斷)。紀錄錯誤並進入下一輪..."
        sleep 60  # 稍微等待一下再 continue，避免瘋狂重試
        continue
    fi
    
    echo "⏱️ [PM 結束時間]: $(date '+%Y-%m-%d %H:%M:%S')"
    
    # 執行 PM 的 Commit 並檢查是否有實質變更
    commit_changes "PM" "chore(pm): 更新計畫狀態與 CURRENT_TASK.md"
    if [ $? -eq 1 ]; then
        CONSECUTIVE_NO_CHANGES=$((CONSECUTIVE_NO_CHANGES + 1))
    else
        CONSECUTIVE_NO_CHANGES=0 # 有變動就歸零
    fi

    # 判斷是否卡住
    if [ "$CONSECUTIVE_NO_CHANGES" -ge "$STUCK_LIMIT" ]; then
        echo "❌ [$(date '+%Y-%m-%d %H:%M:%S')] 偵測到連續 $STUCK_LIMIT 次沒有產生任何檔案變更，判定 AI 邏輯卡住，強制中斷迴圈！"
        break
    fi
    
    echo "⏳ PM 工作完成，休息 ${SLEEP_TIME} 秒避免 API Rate Limit..."
    sleep $SLEEP_TIME
    
    echo "=================================================="
    prepare_clean_env
    
    echo "💻 [Coder] 正在讀取 CURRENT_TASK.md 並執行開發工作..."
    echo "⏱️ [Coder 開始時間]: $(date '+%Y-%m-%d %H:%M:%S')"
    
    # 處理 Coder 執行結果
    if ! claude -p "$(cat .prompts/coder.txt)" --allowedTools "Bash,Read,Edit,Write"; then
        echo "⚠️ [$(date '+%Y-%m-%d %H:%M:%S')] Coder 執行發生錯誤 (可能為 API 限制或網路中斷)。紀錄錯誤並進入下一輪..."
        sleep 60
        continue
    fi
    
    echo "⏱️ [Coder 結束時間]: $(date '+%Y-%m-%d %H:%M:%S')"
    
    # 執行 Coder 的 Commit 並檢查是否有實質變更
    commit_changes "Coder" "feat(coder): 實作指定任務與進度回報"
    if [ $? -eq 1 ]; then
        CONSECUTIVE_NO_CHANGES=$((CONSECUTIVE_NO_CHANGES + 1))
    else
        CONSECUTIVE_NO_CHANGES=0 # 有變動就歸零
    fi

    # 判斷是否卡住
    if [ "$CONSECUTIVE_NO_CHANGES" -ge "$STUCK_LIMIT" ]; then
        echo "❌ [$(date '+%Y-%m-%d %H:%M:%S')] 偵測到連續 $STUCK_LIMIT 次沒有產生任何檔案變更，判定 AI 邏輯卡住，強制中斷迴圈！"
        break
    fi
    
    echo "⏳ Coder 實作完成，休息 ${SLEEP_TIME} 秒避免 API Rate Limit..."
    sleep $SLEEP_TIME
done
