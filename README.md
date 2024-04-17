# simplebox

## 壹、運用構想

### 一、運用目標

* 提供一個腳本，執行後可建立簡單靶機環境

### 二、運用架構

* 本Repo提供一個bash script

### 三、運作流程

* 將bash script複製到Ubuntu的VM或DockerContainer中。
* 使用特殊的port用以執行gitlab的頁面
* 能夠模擬特殊版本的gitlab登入介面 同時具有郵件登入的功能
* 其中gitlab包含像是利用這CVE-2023-7028類的exploit 能夠做密碼重設的POC
* 透過登入使用者gitlab後 能夠檢查使用者開發項目 並其中尋得ssh連線的關鍵
* 以Root權限執行後，可：
  -自動設定弱密碼之ssh服務。
  -自動設定一般使用者CP提權弱點 
* 使用者可以此設定後之VM或DockerContainer，作為練習破密及提權靶機

## 貳、內容結構

* Github Repo<br/>
  📁.github資料夾<br/>
  └ 📁actions<br/>
  　└ ◻️ModuleTest.yml<br/>  //測試檔案上傳能否使用
  　└ ◻️TestThenPublishZip.yml<br/> //放之前版本的內容
  📁.vs資料夾<br/>
  📁doc資料夾<br/>
  ◻️.gitignore檔案<br/>
  ◻️docker-compose.yml檔案<br/>
  ◻️Dockerfile檔案<br/>
  ◻️Mod_Gundam1.sln檔案<br/>
  ◻️README.md<br/>

## 參、作業步驟

### 一、需求分析 & 二、系統設計

None

### 三、模組設計
用gpt跑跑看 可以把劇本寫寫看 或是直接叫gpt寫一個有漏洞的環境(or 網頁?)
設計(滾修)後直接於Readme註記。

### 四、模發測佈

#### (一)模組發展

主要是dockerfile及資料庫初始化腳本，完成後直接存檔。

#### (二)模組測試

利用github action做自動化測試。

#### (三)模組發佈

利用github action做自動化發佈。

### [待修更]五、系測版控

#### (一)獨立使用

* [方法]執行image
  * 利用docker直接建置，將新增image至本地registry
    ```bash
    # -t: tag
    # . : 單點表示目前目錄
    # --no-cache: 避免在Build時被cache，造成沒有讀到最新的Dockerfile
    docker build -t neo4j . --no-cache
    ```
  * 檢視本地images
    ```bash
    docker images
    ```  
  * 使用本地image起容器
    ```
    docker run --publish=7474:7474 --publish=7687:7687 --volume=$HOME/neo4j/data:/data neo4j
    ```
* 瀏覽器開啟 
* [方法]執行dockercompose
  * 直接執行dockercompose
    ```powershell
    docker-compose up
    ```
* 登入瀏覽器確認運作正常
* http://localhost:7474/browser/

* 使用UI關閉container並刪除image

#### (二)併入SOA使用

* 將dockercompose內容複製至系統dockercompose使用。
  ```
  docker-compose up 
  ```
```

### 補充Gitignore

補下列文字：
```
#chen
*.lck
*.bak_*
*.vbak
```
