# Idle Game 2026 - AI Virtual Team Project

An experimental idle game built entirely by an autonomous AI Virtual Team.

---

## 🚀 關於本專案 (About)

**Idle Game 2026** 是一款基於瀏覽器的放置型/增量型遊戲。
本專案最大的特色在於**「全自動化 AI 協作開發」**。透過指令碼驅動，虛擬團隊的成員（專案經理與工程師）會自動閱讀規格、分配任務、撰寫程式碼並提交版本，直到達成所有預設目標。

---

## 👥 團隊組成 (The Virtual Team)

這個專案由一位人類管理員與兩位 AI 虛擬成員共同維護：

* **👑 人類管理員 (Admin - William)**
    * 負責高階決策與專案初始化。
    * 定義 `.ai/GOALS.md` 中的 Epic 與 Task 優先順序。
    * 啟動與監控自動化開發迴圈 (`.ai/loop.sh`)。
* **👔 專案經理 (PM - Claude)**
    * **職責：** 規劃與管理，不寫程式碼。
    * **行為：** 讀取 `.ai/GOALS.md` 與程式碼變更，更新任務進度（標記 `[DONE]`），並挑選下一個優先任務。
    * **產出：** 將詳細規格寫入 `.ai/CURRENT_TASK.md` 供 Coder 執行，並產生 Commit 訊息。
* **💻 軟體工程師 (Coder - Claude)**
    * **職責：** 執行任務與撰寫程式碼。
    * **行為：** 讀取 `.ai/CURRENT_TASK.md`，實作功能，處理錯誤並回報實作進度。
    * **產出：** 遊戲源始碼檔案變更，以及產生對應的 Commit 訊息。

---

## ⚙️ 運作方式 (How it Works)

本專案的核心驅動引擎是 `.ai/loop.sh`。它是一個自動化的 Bash 腳本，透過呼叫 `claude` CLI 來模擬團隊協作。

### 🔄 開發迴圈流程
1. **PM 規劃階段**：腳本載入 `.ai/prompts/pm.txt` 喚醒 PM。PM 分析現狀、更新 `.ai/GOALS.md`，並產出 `.ai/CURRENT_TASK.md`。腳本自動將變更 `git commit`。
2. **冷卻休息**：暫停 5 分鐘（300 秒），避免觸發 API Rate Limit。
3. **Coder 開發階段**：腳本載入 `.ai/prompts/coder.txt` 喚醒 Coder。Coder 依照 `.ai/CURRENT_TASK.md` 寫 Code，並在文件底部加上實作回報。腳本自動將程式碼與文件 `git commit`。
4. **冷卻休息**：再次暫停 5 分鐘，隨後進入下一個迴圈。

### 🛡️ 安全與中斷機制
* **🎉 任務完成：** 當 `.ai/GOALS.md` 內不再有 `[TODO]` 或 `[IN PROGRESS]` 標籤時，迴圈會自動判定專案完成並光榮結束。
* **⚠️ API 異常容錯：** 若遇到網路中斷或 API 額度耗盡，腳本會印出警告並暫停 60 秒後重試，不會直接崩潰。
* **❌ 防卡死機制 (Anti-Stuck)：** 若 AI 陷入邏輯盲區，連續 3 次執行都沒有產生任何實質的檔案變更 (Git Diff 為空)，腳本會強制中斷迴圈，交由人類管理員介入處理。

---

## 🛠️ 如何啟動 (Getting Started)

為了避免 `.ai/loop.sh` 本身在開發過程中被 AI 誤改，腳本需放置於專案的**上層目錄**來執行。

### 執行步驟：

1. **配置環境**：確保你的環境已安裝 Node.js、Git 以及 `claude` 官方命令列工具，並已完成 API 驗證。
2. **複製腳本**：將 `.ai/loop.sh` 複製或移動到專案資料夾的上一層目錄。
    ```bash
    cp .ai/loop.sh ../
    ```
3. **進入專案目錄**：確保你當前位於專案根目錄內。
    ```bash
    cd idle-game-2026-2
    ```
4. **啟動虛擬團隊**：從上層目錄呼叫執行腳本。
    ```bash
    ../loop.sh
    ```
5. **觀察輸出**：放下一杯咖啡，看著終端機裡印出的時間戳記，享受自動化開發的成果！
