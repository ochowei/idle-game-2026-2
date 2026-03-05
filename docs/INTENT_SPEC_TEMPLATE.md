# Intent Spec 範本 (供 PM 參考)

> 每個 `CURRENT_TASK.md` 都應包含以下結構。
> Intent Spec 的核心思想：先說清楚「為什麼」和「完成長什麼樣子」，再說「怎麼做」。

---

## 任務：[Task ID] [任務名稱]

**狀態：** [IN PROGRESS]
**指派時間：** YYYY-MM-DD HH:MM

---

## 一、意圖說明 (Intent)

### 為什麼要做這個任務？
> 從使用者/玩家的角度說明。不要說「因為 GOALS.md 說要做」。

範例：
- 玩家目前沒有辦法看到自己的資源數量，這讓遊戲完全無法進行。
- 沒有存檔系統，玩家關掉頁面就會失去所有進度，體驗很差。

### 這個任務完成後，什麼行為應該正常運作？
> 用「使用者故事」格式，列出可被觀察到的行為。

範例：
- 玩家打開頁面，可以看到資源計數器從 0 開始
- 玩家點擊按鈕，資源數量增加 1
- 玩家購買生產者後，資源每秒自動增加

### 這個任務的邊界（不在範圍內）
> 明確說明哪些事情不要做，避免 Coder 過度實作。

範例：
- 本任務不包含升級系統
- 本任務不需要處理大數值（資源維持整數即可）
- 不需要 UI 美化，功能正確即可

---

## 二、技術規格 (Technical Spec)

### 要修改/新增的檔案

| 檔案路徑 | 操作 | 說明 |
|---------|------|------|
| `src/store/gameStore.ts` | 新增 | 全域狀態管理 |
| `src/components/ResourcePanel.tsx` | 新增 | 資源顯示元件 |
| `src/App.tsx` | 修改 | 整合新元件 |

### 需要安裝的套件

```bash
npm install zustand          # 狀態管理
npm install -D @types/node   # TypeScript 型別
```

### 程式碼範本

```typescript
// src/store/gameStore.ts 範本
import { create } from 'zustand'

interface GameState {
  resources: number
  addResources: (amount: number) => void
}

export const useGameStore = create<GameState>((set) => ({
  resources: 0,
  addResources: (amount) => set((state) => ({
    resources: state.resources + amount
  })),
}))
```

---

## 三、驗證指令 (Verification Commands)

> Coder 完成實作後**必須**依序執行以下指令，並將輸出結果貼到回報中。

```bash
# 1. 確認可以編譯
npm run build

# 2. 執行單元測試
npm test

# 3. 確認程式碼風格
npm run lint
```

**預期結果：**
- `npm run build` 輸出無錯誤，產生 dist/ 目錄
- `npm test` 所有測試通過（0 failures）
- `npm run lint` 無 error（warning 可接受）

---

## 四、驗收標準 Checklist

> PM 審核 Coder 的回報時，逐條確認。每條標準都必須可被測試驗證。

- [ ] 點擊按鈕後，畫面上的資源數字正確增加
- [ ] 購買生產者後，每秒資源自動增加（數值正確）
- [ ] `npm run build` 成功，無編譯錯誤
- [ ] `npm test` 通過，覆蓋率達到核心邏輯 80% 以上
- [ ] 頁面重新整理後，資源數值從 0 重新開始（存檔尚未實作）

---

## 五、實作進度回報（由 Coder 填寫）

> Coder 完成後在此填寫，不要修改上方內容。

**完成時間：** YYYY-MM-DD HH:MM

**驗證結果：**
```
# 貼上 npm run build 的輸出
# 貼上 npm test 的輸出
```

**完成狀況：**
- [x] 已完成的項目
- [ ] 未完成的項目（說明原因）

**備註：**
（遇到的問題、偏離規格的地方、給 PM 的提示）
