#!/bin/bash

# 定義虛擬成員工作後的休息時間 (單位: 秒)
SLEEP_TIME=20

echo "🚀 開始啟動虛擬團隊 (PM & Coder) 自動開發迴圈..."

# 確保必要目錄存在
mkdir -p docs
mkdir -p .prompts

while true; do
    echo "=================================================="
    echo "👔 [PM] 正在讀取進度、維護計畫並指派下一個任務..."
    
    # 執行 Claude Code CLI 處理 PM 工作
    # (註：請確認你的 claude cli 接受 stdin 或特定參數來傳遞 prompt。
    # 以下使用常見的 "-p" 參數格式，若你的 CLI 支援直接吃檔案，請改為對應語法，例如 claude -p "$(cat .prompts/pm.txt)")
    claude -p "$(cat .prompts/pm.txt)" --allowedTools "Bash(git *),Read,Edit,Write"
    
    echo "⏳ PM 工作完成，休息 ${SLEEP_TIME} 秒避免 API Rate Limit..."
    sleep $SLEEP_TIME
    
    echo "=================================================="
    echo "💻 [Coder] 正在讀取 CURRENT_TASK.md 並執行開發工作..."
    
    # 執行 Claude Code CLI 處理 Coder 工作
    claude -p "$(cat .prompts/coder.txt)" --allowedTools "Bash(git *),Read,Edit,Write"
    
    echo "⏳ Coder 實作完成，休息 ${SLEEP_TIME} 秒避免 API Rate Limit..."
    sleep $SLEEP_TIME
done