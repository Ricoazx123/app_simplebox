# app_simplebox
simple hack box

```
# Rsc-Neo4J

## 壹、運用構想

### 一、運用目標

* 運用雲端Docker資源，以建置本地端Neo4J容器映像檔之作法。

### 二、運用架構

* DockerHub提供Neo4J官方映像檔。
* 本Repo提供DockerFile及初始化Cypher檔範例。

### 三、運作流程

* 利用DockerFile及初始化Cypher檔，建置本地映像檔後，可實例化為容器作為單一SOA端。
* 其他SOA或User透過網路存取資料庫。
  * Neo4j Browser & Neo4j Cypher HTTP : Port 7474
  * Neo4j Browser & Neo4j Cypher HTTPS: Port 7473

## 貳、內容結構

* Github Repo<br/>
  📁.github資料夾<br/>
  └ 📁actions<br/>
  　└ ◻️UnitTest.yml<br/>
  　└ ◻️ModuleTest.yml<br/>
  　└ ◻️TestThenPublishZip.yml<br/>
  　└ ◻️TestThenPublishContainer.yml<br/>
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

設計(滾修)後直接於Readme註記。

### 四、模發測佈

#### (一)模組發展

主要是dockerfile及資料庫初始化腳本，完成後直接存檔。

#### (二)模組測試

利用github action做自動化測試。

#### (三)模組發佈

測試通過後，手動於release介面發佈。

### 五、系測版控

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
