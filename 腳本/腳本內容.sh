#!/bin/bash

# 安装必要的软件：Ruby, Apache, PHP, MySQL, OpenSSH
echo "安装 Ruby, Apache, PHP, MySQL, OpenSSH..."
sudo apt-get update
sudo apt-get install ruby apache2 php libapache2-mod-php mysql-server openssh-server php-mysqli -y
gem install bundler

# 创建 Ruby 脚本以检查 Gem 版本
echo "生成 Ruby 脚本和 YAML 文件..."
cat > check_gems.rb << 'EOF'
require 'yaml'
require 'rubygems'

# 读取 YAML 文件
config = YAML.load_file('abc.yml')

# 检查 Gem 版本
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

# 创建 YAML 文件
cat > abc.yml << 'EOF'
- name: "rails"
  version: "5.2.0"
- name: "nokogiri"
  version: "1.10.0"
EOF

# 执行 Ruby 脚本以检查 Gems
sudo mv check_gems.rb /usr/local/bin/
sudo chmod 755 /usr/local/bin/check_gems.rb
sudo chown root:root /usr/local/bin/check_gems.rb

# 限制 sudo 权限，普通用户不能使用 sudo su，但可以执行特定的 Ruby 脚本
echo 'sshuser ALL=(ALL) NOPASSWD: /usr/local/bin/check_gems.rb' | sudo tee /etc/sudoers.d/sshuser
echo 'sshuser ALL=(ALL) !/bin/su' | sudo tee -a /etc/sudoers.d/sshuser

# 设置 MySQL (使用弱密码)
echo "设置 MySQL 并设置弱密码..."
sudo systemctl start mysql
sudo mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password123'; FLUSH PRIVILEGES;"

# 创建 MySQL 数据库和表格
echo "创建 MySQL 数据库和表格..."
mysql -u root -ppassword123 <<EOF
CREATE DATABASE userdb;
USE userdb;
CREATE TABLE users (id INT, name VARCHAR(100), email VARCHAR(100), password VARCHAR(100));
INSERT INTO users VALUES (1, 'Alice', 'alice@example.com', 'alicepassword'), (2, 'Bob', 'bob@example.com', 'bobpassword'), (3, 'sshuser', 'sshuser@example.com', '123');
EOF

# 设置网页
echo "设置网页..."
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
    die("Query failed: " . \$conn's error);
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

# 删除默认的 index.html
sudo rm /var/www/html/index.html

# 启动 Apache
sudo systemctl restart apache2

# 创建 SSH 用户
echo "创建 SSH 用户..."
sudo adduser sshuser --gecos "SSH User,RoomNumber,WorkPhone,HomePhone" --disabled-password
echo "sshuser:123" | sudo chpasswd

# 添加自定义用户进行 SSH 连接
echo "添加自定义 SSH 用户..."
sudo adduser customuser --gecos "Custom User,RoomNumber,WorkPhone,HomePhone" --disabled-password
echo "customuser:custompassword" | sudo chpasswd

# 启动 SSH 服务
echo "启动 SSH 服务..."
sudo systemctl enable ssh
sudo systemctl restart ssh

# 创建 user flag
echo "创建 user flag..."
echo "user_flag{this_is_a_test_flag}" | sudo tee /home/sshuser/user_flag.txt

# 创建 root flag
echo "创建 root flag..."
echo "root_flag{this_is_the_root_flag}" | sudo tee /root/root_flag.txt
sudo chmod 600 /root/root_flag.txt

# 清理生成的 YAML 文件
rm abc.yml

echo "靶机设置完成，请开始你的测试！"

