#!/bin/bash

# 定義虛擬成員工作後的休息時間 (單位: 秒)
SLEEP_TIME=20

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

# 定義清理環境的函式 (由於 loop.sh 已經在專案外，直接 reset 即可)
prepare_clean_env() {
    echo "🧹 正在清理工作區，確保從 Clean 狀態開始..."
    git reset --hard HEAD > /dev/null
    git clean -fd > /dev/null
}

# 定義讀取 message 並 commit 的函式
commit_changes() {
    local role=$1
    local default_msg=$2
    
    git add .
    
    # 檢查是否有實際的檔案變動 (避免產生空的 commit)
    if ! git diff --cached --quiet; then
        if [ -f ".commit_msg" ]; then
            # 讀取 AI 寫好的 commit message
            local msg=$(cat .commit_msg)
            # 刪除暫存檔，確保環境乾淨
            rm .commit_msg
            git commit -m "$msg"
        else
            # 萬一 AI 忘記產生檔案，使用預設訊息備底
            git commit -m "$default_msg"
        fi
    else
        echo "ℹ️ [$role] 沒有偵測到任何檔案變更，跳過 Commit。"
    fi
}

while true; do
    echo "=================================================="
    prepare_clean_env
    
    echo "👔 [PM] 正在讀取進度、維護計畫並指派下一個任務..."
    claude -p "$(cat .prompts/pm.txt)" --allowedTools "Bash,Read,Edit,Write"
    
    # 執行 PM 的 Commit
    commit_changes "PM" "chore(pm): 更新計畫狀態與 CURRENT_TASK.md"
    
    echo "⏳ PM 工作完成，休息 ${SLEEP_TIME} 秒避免 API Rate Limit..."
    sleep $SLEEP_TIME
    
    echo "=================================================="
    prepare_clean_env
    
    echo "💻 [Coder] 正在讀取 CURRENT_TASK.md 並執行開發工作..."
    claude -p "$(cat .prompts/coder.txt)" --allowedTools "Bash,Read,Edit,Write"
    
    # 執行 Coder 的 Commit
    commit_changes "Coder" "feat(coder): 實作指定任務與進度回報"
    
    echo "⏳ Coder 實作完成，休息 ${SLEEP_TIME} 秒避免 API Rate Limit..."
    sleep $SLEEP_TIME
done