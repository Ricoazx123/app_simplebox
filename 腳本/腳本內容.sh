#!/bin/bash

# 安裝必要的軟件
echo "安裝 Apache 和 PHP..."
sudo apt-get update
sudo apt-get install apache2 php libapache2-mod-php mysql-server openssh-server php-mysqli -y

# 設置 MySQL (使用弱密碼)
echo "設置 MySQL 並設置弱密碼..."
sudo systemctl start mysql
sudo mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password123'; FLUSH PRIVILEGES;"

# 創建 MySQL 資料庫和表格
echo "創建 MySQL 資料庫和表格..."
mysql -u root -ppassword123 <<EOF
CREATE DATABASE userdb;
USE userdb;
CREATE TABLE users (id INT, name VARCHAR(100), email VARCHAR(100), password VARCHAR(100));
INSERT INTO users VALUES (1, 'Alice', 'alice@example.com', 'alicepassword'), (2, 'Bob', 'bob@example.com', 'bobpassword'), (3, 'sshuser', 'sshuser@example.com', '123');
EOF

# 設置網頁
echo "設置網頁..."
cat <<EOF > /var/www/html/index.php
<!DOCTYPE html>
<html>
<head>
  <title>SQL Injection</title>
</head>
<body>
  <h1>Vulnerability: SQL Injection</h1>
  <form action="result.php" method="GET">
    <label for="userID">User ID:</label>
    <input type="text" id="userID" name="userID">
    <input type="submit" value="Submit">
  </form>
</body>
</html>
EOF

cat <<EOF > /var/www/html/result.php
<?php
  error_reporting(E_ALL);
  ini_set('display_errors', 1);

  \$conn = new mysqli('localhost', 'root', 'password123', 'userdb');

  if (\$conn->connect_error) {
    die("Connection failed: " . \$conn->connect_error);
  }

  \$userID = \$_GET['userID'];
  \$query = "SELECT name, email, password FROM users WHERE id = \$userID";
  \$result = \$conn->query(\$query);

  if (!\$result) {
    die("Query failed: " . \$conn->error);
  }

  if (\$result->num_rows > 0) {
    while(\$row = \$result->fetch_assoc()) {
      echo "Name: " . \$row["name"] . " - Email: " . \$row["email"] . " - Password: " . \$row["password"] . "<br>";
    }
  } else {
    echo "0 results";
  }

  \$conn->close();
?>
EOF

# 刪除預設的 index.html
sudo rm /var/www/html/index.html

# 啟動 Apache
sudo systemctl restart apache2

# 創建 SSH 用戶
echo "創建 SSH 用戶..."
sudo adduser sshuser --gecos "SSH User,RoomNumber,WorkPhone,HomePhone" --disabled-password
echo "sshuser:123" | sudo chpasswd

# 添加自定義用戶以進行 SSH 連接
echo "添加自定義 SSH 用戶..."
sudo adduser customuser --gecos "Custom User,RoomNumber,WorkPhone,HomePhone" --disabled-password
echo "customuser:custompassword" | sudo chpasswd

# 啟動 SSH
echo "啟動 SSH 服務..."
sudo systemctl enable ssh
sudo systemctl restart ssh

# 創建 user flag
echo "創建 user flag..."
echo "user_flag{this_is_a_test_flag}" | sudo tee /home/sshuser/user_flag.txt

echo "靶機設置完成。請開始你的測試！"
