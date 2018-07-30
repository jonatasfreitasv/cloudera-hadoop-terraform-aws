#!/usr/bin/env bash

# Install dependencies and update
sudo yum update -y
sudo yum install wget -y

wget http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
sudo rpm -ihv epel-release-6-8.noarch.rpm

sudo yum update -y
sudo yum install nano wget htop curl -y

# Install Oracle JDK 1.8
wget --no-check-certificate -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/jdk-8u181-linux-x64.rpm
sudo rpm -ivh jdk-8u181-linux-x64.rpm

# Install MYSQL Java Connector
wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.46.tar.gz
tar zxvf mysql-connector-java-5.1.46.tar.gz
sudo mkdir -p /usr/share/java/
sudo cp mysql-connector-java-5.1.46/mysql-connector-java-5.1.46-bin.jar /usr/share/java/mysql-connector-java.jar

# Clean
rm epel-release-6-8.noarch.rpm
rm mysql-connector-java-5.1.46.tar.gz
rm -rf mysql-connector-java-5.1.46

# Tunning
sudo sysctl -w vm.swappiness=1
echo 'vm.swappiness=1' | sudo tee --append /etc/sysctl.d/99-sysctl.conf

echo never | sudo tee --append /sys/kernel/mm/transparent_hugepage/defrag
echo never | sudo tee --append /sys/kernel/mm/transparent_hugepage/enabled

echo "echo never >> /sys/kernel/mm/transparent_hugepage/defrag" | sudo tee --append /etc/rc.local
echo "echo never >> /sys/kernel/mm/transparent_hugepage/enabled" | sudo tee --append /etc/rc.local

sudo systemctl start tuned
sudo tuned-adm off
sudo systemctl stop tuned
sudo systemctl disable tuned