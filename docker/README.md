# Docker介紹

## 概覽
本次的docker是為了幫助此靶機的使用者能夠更快的進入靶機所搭建的環境而設計的，其中需要將dockerfile和.sh檔放在放在同個目錄下才可以使用

## Docker 架構介紹
- Docker環境:
  這個 Dockerfile 建立一個基於 Ubuntu 的環境，其中包括了安裝 Ruby, Apache, PHP, MySQL, OpenSSH 等必需的服務和工具，目的是搭建一個具有 Web 服務和 SSH 存取能力的容器，用於測試和開發。

- Docker指令介紹:
  1. 其中一部分的指令用來安裝必要的元件:apache2 、php、mysql-server、openssh、gem、sudo 、suby。指令如下
  ```
  RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    ruby \
    apache2 \
    php \
    libapache2-mod-php \
    mysql-server \
    openssh-server \
    php-mysqli \
    sudo \
    gem
  ```
  
  2. 將本地的 setup.sh 腳本複製到容器中，賦予它執行權限，然後執行它。這個腳本用於進一步配置容器，例如設置 Web 服務和資料庫。
  ```
  COPY setup.sh /setup.sh
  RUN chmod +x /setup.sh
  RUN /setup.sh
  ```

  3.  最後，容器啟動指令
  ```
  CMD service apache2 start && service mysql start && service ssh start && tail -f /dev/null
  ```

## 總結
這個 Dockerfile 提供了一個完整的開發環境，適合進行 Web 和數據庫的開發測試。通過使用 Docker，開發者可以在一個隔離的環境中運行和測試他們的應用，確保環境的一致性和可移植性。


