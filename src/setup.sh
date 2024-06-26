#!/bin/bash

echo "开始安装必要的软件..."
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y ruby apache2 php libapache2-mod-php mysql-server openssh-server php-mysqli

echo "安装 Ruby 的 bundler..."
sudo gem install bundler

echo "生成 Ruby 脚本和 YAML 文件..."
cat > /tmp/check_gems.rb << 'EOF'
require 'yaml'
require 'rubygems'

config = YAML.load_file('/tmp/abc.yml')

config.each do |gem_info|
  gem_name = gem_info['name']
  required_version = gem_info['version']
  latest_version = Gem.latest_version_for(gem_name)

  if Gem::Version.new(latest_version) > Gem::Version.new(required_version)
    puts "#{gem_name} 需要更新. 最新版本是 #{latest_version}."
  else
    puts "#{gem_name} 已是最新版本."
  end
end
EOF

cat > /tmp/abc.yml << 'EOF'
- name: "rails"
  version: "5.2.0"
- name: "nokogiri"
  version: "1.10.0"
EOF

echo "移动 Ruby 脚本到全局可执行路径..."
sudo mv /tmp/check_gems.rb /usr/local/bin/
sudo chmod 755 /usr/local/bin/check_gems.rb
sudo chown root:root /usr/local/bin/check_gems.rb

echo "配置 sudo 权限..."
echo 'sshuser ALL=(ALL) NOPASSWD: /usr/local/bin/check_gems.rb' | sudo tee /etc/sudoers.d/sshuser
echo 'sshuser ALL=(ALL) !/bin/su' | sudo tee -a /etc/sudoers.d/sshuser

echo "设置 MySQL 并初始化数据库..."
sudo systemctl start mysql
sudo mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password123'; FLUSH PRIVILEGES;"

echo "创建 MySQL 数据库和表格..."
mysql -u root -ppassword123 <<EOF
CREATE DATABASE userdb;
USE userdb;
CREATE TABLE users (id INT, name VARCHAR(100), email VARCHAR(100), password VARCHAR(100));
INSERT INTO users VALUES (1, 'Alice', 'alice@example.com', 'alicepassword'), (2, 'Bob', 'bob@example.com', 'bobpassword'), (3, 'sshuser', 'sshuser@example.com', '123');
EOF

echo "设置网页..."
sudo rm /var/www/html/index.html
sudo bash -c 'cat <<EOF > /var/www/html/index.php
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
EOF'

sudo bash -c 'cat <<EOF > /var/www/html/result.php
<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

$servername = "localhost";
$username = "root";
$password = "password123";  // 替换为你的数据库密码
$dbname = "userdb";

// 创建与数据库的连接
$conn = new mysqli($servername, $username, $password, $dbname);

// 检查连接是否成功
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// 从GET请求中直接获取userID，无任何过滤或预处理
$userID = $_GET['userID'];

// 直接将用户输入用于SQL查询
$query = "SELECT name, email, password FROM users WHERE id = '$userID'";
$result = $conn->query($query);

// 检查查询是否成功
if (!$result) {
    die("Query failed: " . $conn->error);
}

// 处理查询结果
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        echo "Name: " . $row["name"] . " - Email: " . $row["email"] . " - Password: " . $row["password"] . "<br>";
    }
} else {
    echo "0 results";
}

// 关闭连接
$conn->close();
?>


EOF'

echo "重启 Apache 以使配置生效..."
sudo systemctl restart apache2

echo "创建 SSH 用户..."
sudo adduser sshuser --gecos "SSH User,RoomNumber,WorkPhone,HomePhone" --disabled-password
echo "sshuser:123" | sudo chpasswd

echo "添加自定义 SSH 用户..."
sudo adduser customuser --gecos "Custom User,RoomNumber,WorkPhone,HomePhone" --disabled-password
echo "customuser:custompassword" | sudo chpasswd

echo "启动 SSH 服务..."
sudo systemctl enable ssh
sudo systemctl restart ssh

echo "创建 user flag..."
echo "user_flag{this_is_a_test_flag}" | sudo tee /home/sshuser/user_flag.txt

echo "创建 root flag..."
echo "root_flag{this_is_the_root_flag}" | sudo tee /root/root_flag.txt
sudo chmod 600 /root/root_flag.txt

echo "清理生成的 YAML 文件..."
rm /tmp/abc.yml

echo "靶机设置完成，请开始你的测试！"
