#!/bin/bash

# 定義虛擬成員工作後的休息時間 (單位: 秒)
SLEEP_TIME=600

# 定義遭遇 API 錯誤或網路中斷時的重試等待時間 (單位: 秒)
ERROR_SLEEP_TIME=300

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

    # 先讀取並移除 .commit_msg，避免被 git add . 加進去
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

# 檢查是否有 HUMAN_NEEDED.md，若有則暫停並通知人類
check_human_needed() {
    if [ -f "docs/HUMAN_NEEDED.md" ]; then
        echo ""
        echo "🆘 ============================================================"
        echo "🆘 [$(date '+%Y-%m-%d %H:%M:%S')] AI 團隊請求人類協助！"
        echo "🆘 請查看 docs/HUMAN_NEEDED.md 了解需要協助的內容："
        echo "🆘 ============================================================"
        echo ""
        cat docs/HUMAN_NEEDED.md
        echo ""
        echo "🆘 ============================================================"
        echo "🆘 自動開發迴圈已暫停。請解決上述問題後，"
        echo "🆘 刪除 docs/HUMAN_NEEDED.md 再重新執行 loop.sh。"
        echo "🆘 ============================================================"
        exit 1
    fi
}

# 執行 claude 並於結束後顯示使用的 turn 數量
# 用法: run_claude <角色名稱> <max_turns> <claude 的其餘參數...>
# 回傳值: claude 的 exit code
run_claude() {
    local role="$1"
    local max_turns="$2"
    shift 2

    # 若 jq 不可用，退回到一般輸出模式（無 turn 計數）
    if ! command -v jq &>/dev/null; then
        echo "⚠️  [${role}] 未偵測到 jq，以一般模式執行（無 turn 計數）"
        claude "$@"
        return $?
    fi

    local stream_log
    stream_log=$(mktemp /tmp/claude_stream_XXXXXX.jsonl)

    # 以 stream-json 輸出，同時 tee 到暫存檔，並即時萃取文字顯示
    claude "$@" --output-format stream-json --verbose \
        | tee "$stream_log" \
        | jq -rj 'if .type == "content_block_delta" and .delta.type == "text_delta"
                  then .delta.text
                  else empty
                  end' 2>/dev/null
    local exit_code=${PIPESTATUS[0]}

    # 優先從 result 事件取 num_turns，fallback 到計算 message_start 數量
    local turn_count
    turn_count=$(grep '"type":"result"' "$stream_log" \
        | jq -r '.num_turns // empty' 2>/dev/null | head -1)
    if [ -z "$turn_count" ]; then
        turn_count=$(grep -c '"type":"message_start"' "$stream_log" 2>/dev/null || echo "?")
    fi

    rm -f "$stream_log"

    echo ""
    echo "ℹ️  [${role}] 共使用 ${turn_count} / ${max_turns} turns"

    return $exit_code
}

while true; do
    echo "=================================================="

    # 每次迴圈開始前先檢查是否有待處理的人類協助請求
    check_human_needed

    # 檢查是否所有目標都已完成 (docs/GOALS.md 中沒有 [TODO] 且沒有 [IN PROGRESS])
    if ! grep -q "\[TODO\]\|\[IN PROGRESS\]" docs/GOALS.md; then
        echo "🎉 [$(date '+%Y-%m-%d %H:%M:%S')] 偵測到 docs/GOALS.md 中的任務已全數完成！結束自動開發迴圈。"
        break
    fi

    prepare_clean_env

    echo "👔 [PM] 正在讀取進度、維護計畫並指派下一個任務..."
    echo "⏱️ [PM 開始時間]: $(date '+%Y-%m-%d %H:%M:%S')"

    run_claude "PM" 15 \
        -p "$(cat .prompts/pm.txt)" \
        --allowedTools "Read,Edit,Write,Glob,Grep" \
        --model sonnet \
        --max-turns 15
    if [ $? -ne 0 ]; then
        echo "⚠️ [$(date '+%Y-%m-%d %H:%M:%S')] PM 執行發生錯誤 (可能為 API 限制或網路中斷)。紀錄錯誤並等待 ${ERROR_SLEEP_TIME} 秒後進入下一輪..."
        sleep $ERROR_SLEEP_TIME
        continue
    fi

    echo "⏱️ [PM 結束時間]: $(date '+%Y-%m-%d %H:%M:%S')"

    # 檢查 PM 是否正常完成（未被 max-turns 截斷）
    if [ ! -f "docs/PM_DONE" ]; then
        echo "⚠️ [$(date '+%Y-%m-%d %H:%M:%S')] 未偵測到 docs/PM_DONE，判定 PM 被 max-turns 截斷。回滾所有未 commit 變更並等待 ${ERROR_SLEEP_TIME} 秒後重試..."
        prepare_clean_env
        sleep $ERROR_SLEEP_TIME
        continue
    fi
    rm -f docs/PM_DONE  # 清除信號，不讓它進入 commit

    # PM 完成後檢查是否需要人類介入
    check_human_needed

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

    # allowedTools 明確包含 npm/node/npx 相關 Bash 指令
    run_claude "Coder" 30 \
        -p "$(cat .prompts/coder.txt)" \
        --allowedTools "Bash(npm install*),Bash(npm run *),Bash(npm test*),Bash(npm ci*),Bash(npx *),Bash(node *),Bash(git status*),Bash(git diff*),Read,Edit,Write,Glob,Grep" \
        --max-turns 30
    if [ $? -ne 0 ]; then
        echo "⚠️ [$(date '+%Y-%m-%d %H:%M:%S')] Coder 執行發生錯誤 (可能為 API 限制或網路中斷)。紀錄錯誤並等待 ${ERROR_SLEEP_TIME} 秒後進入下一輪..."
        sleep $ERROR_SLEEP_TIME
        continue
    fi

    echo "⏱️ [Coder 結束時間]: $(date '+%Y-%m-%d %H:%M:%S')"

    # 檢查 Coder 是否正常完成（未被 max-turns 截斷）
    if [ ! -f "docs/CODER_DONE" ]; then
        echo "⚠️ [$(date '+%Y-%m-%d %H:%M:%S')] 未偵測到 docs/CODER_DONE，判定 Coder 被 max-turns 截斷。回滾所有未 commit 變更並等待 ${ERROR_SLEEP_TIME} 秒後重試..."
        prepare_clean_env
        sleep $ERROR_SLEEP_TIME
        continue
    fi
    rm -f docs/CODER_DONE  # 清除信號，不讓它進入 commit

    # Coder 完成後檢查是否需要人類介入
    check_human_needed

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
