Paper Pass Box
====
> github.com/carlton0521

到shields.io這網站搜索github 相關的內容

* Repo Info:<br/> 
  ![C Sharp](https://img.shields.io/badge/C_Sharp-6A2BB2?logo=csharp&logoColor=white)
  ![Bash Script](https://img.shields.io/badge/Bash_Script-1A1B92?logo=gnubash&logoColor=white)
  ![Python使用](https://img.shields.io/badge/Python-14658C?logo=python&logoColor=white)
  ![Docker使用](https://img.shields.io/badge/Docker-2496dD?logo=docker&logoColor=white)
* Public Release:<br/>
  ![版權宣告](https://img.shields.io/github/license/TwMoonBear-Arsenal/Box_PaperPass)
  可維護度: https://codeclimate.com/oss/dashboard
  Repo大小：https://shields.io/badges/git-hub-repo-size
  釋出Tag：https://shields.io/badges/git-hub-tag
  釋出Release: https://shields.io/badges/git-hub-release
  釋出日期: https://shields.io/badges/git-hub-release-date

# 1. 摘要資訊

* 針對多類型決策需求，提供一個通用性決策系統，可以給定場景，進行趨勢推導及決策建議。
* 參考OODA框架，目前版本功能重點為Decison決策輔助，未來將逐步發展Orientation情資管理、Action指揮管制及Observation觀察。

# 2. 項目介紹

## 2.1. Release Asset

- **data資料夾**：
  - **cfgSkOrchestaator.yml**：Mod_SkOrchestrator1組態檔
  - **cfgReasoner.yml**：Mod_Reasoner1組態檔
- **dockercompose檔案**：docker微服務設定
- **LICENSE檔案**：版權宣告
- **README.md檔案**：說明文件

## 2.2. 外部依賴(外部元件)

- Mod_SkOrchestrator1：使用者自然語言訊息入口
- Mod_Reasoner1：配合提供決策輔助功能

# 3. 作業運用

## 3.1 Repo構管

* 此Repo為private，直接於main branch操作更新。

## 3.2. 系統設計 & 模組設計

* 於README.md及/doc/design.vpp說明。
* 主要規格為：
  - 可依要求提供常規知識及多種知識主題決策服務。
  - 依給定場景進行趨勢推導。
  - 依給定場景進行決策建議。 
* 相關模組為：
  - 上述相依外部模組所需組態檔 *2。

## 3.3. 模組發展
 
### 3.3.1. 功能開發

* 外部模組組態檔：依各模組規範如yaml編寫。
* ockercompose：文字檔格式編寫。

### 3.3.2. 模組測試

* 模組部分為組態檔，略過不測。

### 3.3.3. 模組發佈
* 包含對上述外部依賴模組設定組態檔。
  
## 3.4. 系統測試

* 手動方式進行測試，
* 測試個案包括：
  - 個案：Get查詢Hetaoas，應能回傳提供常規知識及<測試用決策知識>
  - 個案：以自然語言詢問常規知識：應能回復一年有幾天。
  -  個案：以自然語言詢問無意義詞彙，應能回復釐清使用者意圖。
  - 個案：
    - 對給定連鎖衝擊場景進行趨勢推導。
    - 對給定連鎖衝擊場景進行決策建議。
  - 個案：
    - 對給定大型救災場景進行趨勢推導。
    - 對給定大型救災場景進行決策建議。
  - 個案：
    - 對給定資安事件場景進行趨勢推導。
    - 對給定資安事件場景進行決策建議。

-----
第二部分(考試範圍外)

* 用例圖 可用visual paradigm 做編輯