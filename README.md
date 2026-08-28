# 個人收支紀錄｜GitHub Pages + Supabase 多裝置同步版

這一版把「網頁程式」放在 GitHub Pages，把「實際財務資料」放在 Supabase。只要使用同一組 Email / 密碼登入，手機、電腦與不同瀏覽器都會讀取同一份紀錄。

## 已保留功能
- 七家銀行：玉山（緊急）、台灣（學貸）、第一（娛樂）、中信（生活）、永豐（預存）、國泰（零用）、LINE BANK。
- 七家銀行左右兩欄；手機自動改單欄。
- 信用卡每月使用金額與額度使用率。
- 快速登錄：信用卡刷費、銀行／現金支出、收入、繳信用卡費。
- 月份切換與每月關鍵字搜尋。
- Excel 匯出、JSON 備份／還原。
- Supabase Email / 密碼登入，多裝置同步。
- 原舊版 LocalStorage 若有資料，而雲端尚無資料，第一次登入會自動把舊資料建立到雲端。
- 若短暫斷網，先保留在本機；恢復網路後會再嘗試同步。

## 第一次建置（約 4 個步驟）

### 1. 建立 Supabase 專案
到 Supabase 建立免費 Project。

### 2. 建立資料表與安全政策
到 Supabase Dashboard → **SQL Editor**，把本資料夾的 `supabase.sql` 全部貼上並執行。

這份 SQL 已經開啟 Row Level Security（RLS），規則是：登入使用者只能讀寫自己的 `user_id` 那一列。

### 3. 設定 config.js
到 Supabase Dashboard 找到：
- Project URL
- Publishable key（舊專案可能顯示 anon key）

打開 `config.js`，換掉：

```js
window.FINANCE_CONFIG = {
  SUPABASE_URL: "https://YOUR_PROJECT_ID.supabase.co",
  SUPABASE_PUBLISHABLE_KEY: "YOUR_PUBLISHABLE_KEY"
};
```

**只可使用 Publishable / anon key，絕對不要把 `service_role` key 放進 GitHub 或瀏覽器。**

### 4. 上傳 GitHub Pages
把這三個檔案放在同一個 GitHub repository 根目錄：
- `index.html`
- `config.js`
- `supabase.sql`（網頁執行不需要，但建議保留作設定紀錄）

GitHub → Settings → Pages → Deploy from a branch → `main` → `/ (root)`。

## 第一次使用
1. 開啟 GitHub Pages 網址。
2. 按「第一次建立帳號」。
3. 輸入 Email 與至少 6 碼密碼。
4. 若 Supabase Auth 預設要求 Email 驗證，先到信箱點驗證連結，再回網站登入。
5. 登入後，右上角顯示「雲端已同步」即完成。

## 舊版資料搬移
如果你原本同一個瀏覽器已經有舊版 LocalStorage 紀錄：
- 雲端帳號第一次使用、尚無 `finance_data` 資料時，新版會直接把本機舊資料寫入雲端。
- 如果雲端已經有資料，正常情況以雲端為主。
- 升級前仍建議先按一次「JSON 備份」或「匯出 Excel」。

## 安全說明
- GitHub Pages 只放前端程式，不保存你的交易內容。
- 財務資料保存在 Supabase Postgres。
- 資料表啟用 RLS，以 `auth.uid()` 限制每個使用者只能存取自己的資料。
- `config.js` 中的 Publishable / anon key 是瀏覽器前端用金鑰；安全邊界由 RLS 負責。不要使用 service_role key。

## 檔案
- `index.html`：主程式
- `config.js`：Supabase 專案設定
- `supabase.sql`：資料表與 RLS 建置 SQL


## 行動版分頁更新
- 預設首頁：快速紀錄。
- 快速紀錄頁：月份、快速登錄、信用卡本月使用、每月紀錄搜尋。
- 資金總覽頁：銀行總額、信用卡刷費、收入、支出、七家銀行餘額。
- 銀行總額預設隱藏，可按顯示／隱藏切換。
- 修正 iPhone 日期欄位超出卡片寬度。
