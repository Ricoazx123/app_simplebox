# Shell腳本介紹

## 概覽
### 滲透
這個Ubuntu環境被設計來模擬一個具有一定安全漏洞的Web和數據庫伺服器。用戶可以通過這個環境學習基本的Web安全概念，如SQL注入和SSH登入。
使用者可以nmap掃描得知使用apache2的伺服器，這是一個簡單關於線上使用者帳密查詢的網站，同時可以透過SQL注入找到SSH連接的關鍵。

### 提權
希望使用者透過`sudo -l`之類的指令找尋能夠使用的檔案。對ruby檔導入YAML程式碼這一行為進行觀察 看能不能找到提權的關鍵

## 基本結構
1. 軟件安裝
腳本開始於更新系統的軟件庫並安裝一系列必要的包。這包括 Web 伺服器、數據庫服務和開發環境所需的組件。

2. Ruby 腳本創建
接下來，腳本創建一個 Ruby 腳本 (check_gems.rb) 用來檢查 abc.yml 指定的 Ruby gems 版本是否為最新。這個部分涉及到文件的動態創建和寫入，並將腳本移動到系統的 bin 目錄以便執行。

3. YAML 配置文件
abc.yml 是一個 YAML 配置文件，其中包含了需要檢查的 gems 及其版本。這個文件也是動態創建的。

4. 網頁設置
腳本設置了一個簡單的 PHP 網頁，目的是展示 SQL 注入的風險。它包括兩個文件：index.php 用於用戶輸入，和 result.php 用於展示數據庫查詢結果。

5. 用戶和權限管理
腳本設置了特定的 sudo 權限規則，以限制普通用戶的特權提升，同時允許執行特定的管理腳本。此外，還創建了一些用於 SSH 登入的用戶帳戶。

6. 服務啟動和系統清理
最後，腳本啟動了 Apache 和 SSH 服務，確保這些服務在系統啟動時可用。還包括了一步清理操作，移除安裝過程中生成的臨時文件，並通過結束語來標示配置過程的完成。


## 在本地端使用&建置
1. 創建.sh檔
> nano set.sh

2. 提權
 > chmod +x set.sh

3. 使用
 > ./set.sh

## 總結
這個 Bash 腳本是為了建立一個教育用的測試環境，具體針對安全漏洞如 SQL 注入進行演示和實踐。這份腳本的核心功能包括安裝並設置必要的軟件、創建並運行用於檢查 Gem 版本的 Ruby 腳本、部署含有安全漏洞的 Web 應用、以及配置用戶權限和服務。

