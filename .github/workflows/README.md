請求事項說明
========
用於在每次 push 時觸發建立和部署任務。這個工作流程包含了多個步驟，用於檢出代碼、設置版本變量、準備文件、上傳文件包、構建並運行 Docker 容器，最後創建並發布 GitHub Release。

# 運用構想
1. 檢出代碼
這一步使用了 actions/checkout@v3 這個動作，用於檢出仓库代码到 GitHub Actions 的運行器上。這使得後續步驟可以對代碼進行各種操作。

2. 設置版本變量
此步驟將當前的日期和時間設置為一個環境變量 RELEASE_VERSION。這個版本標記用於標識發布的版本，格式為 vYYYYMMDDHHMMSS。

3. 準備文件
此步驟首先創建一個 release 目錄，然後將 LICENSE、README.md、dockerfile 以及 setup.sh 複製到該目錄中。最後使用 zip 命令將整個 release 目錄壓縮為 release.zip，這個壓縮文件包含了所有需要的發布文件。

4. 上傳文件
使用 actions/upload-artifact@v3 將壓縮後的 release.zip 作為工件上傳。這使得其他工作流程或作業可以訪問這些文件。

5. 構建和運行 Docker 容器
此步驟將 release 目錄中的文件複製到 deployment 目錄，然後在該目錄中使用 dockerfile 來構建 Docker 映像。建立完成後，運行一個 Docker 容器，映射 2222 端口到容器的 22 端口。

6. 創建 Release
使用 softprops/action-gh-release@v1 創建一個新的 GitHub Release，版本號使用之前設定的 RELEASE_VERSION，並將 release.zip 文件作為發布內容。

7. 檢查資產是否已上傳
這個步驟使用 octokit/request-action@v2.x 檢查特定版本號的發布是否已經存在，並且確認資產（如 release.zip）是否已被成功上傳。
