#!/usr/bin/env bash

# CDH installation

sudo rpm --import https://archive.cloudera.com/cdh5/redhat/7/x86_64/cdh/RPM-GPG-KEY-cloudera -y
sudo wget https://archive.cloudera.com/cm5/redhat/7/x86_64/cm/cloudera-manager.repo -P /etc/yum.repos.d/

sudo yum install cloudera-manager-daemons cloudera-manager-server -y

# MySQL installation

wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
sudo rpm -ivh mysql-community-release-el7-5.noarch.rpm
sudo yum install mysql-server -y

# MySQL start
sudo systemctl start mysqld
sudo systemctl enable mysqld

# MySQL secure install
sudo bash /tmp/mysql_secure_install_automated.sh

# Create CDH databases
mysql -u root -pabc123 < /tmp/cloudera_database.sql
sudo /usr/share/cmf/schema/scm_prepare_database.sh mysql scm root abc123

# Start CDH
sudo systemctl start cloudera-scm-server
sudo systemctl enable cloudera-scm-server

# Install Spark 2
sudo mkdir -p /var/log/spark2/lineage
sudo chown hdfs:hdfs /var/log/spark2/lineage
sudo wget http://archive.cloudera.com/spark2/csd/SPARK2_ON_YARN-2.3.0.cloudera3.jar
sudo mv SPARK2_ON_YARN-2.3.0.cloudera3.jar /opt/cloudera/csd

# Add this no parcels in scm http://archive.cloudera.com/spark2/parcels/2.3.0.cloudera3/

sleep 60;sudo systemctl restart cloudera-scm-server

# Clean
rm mysql-community-release-el7-5.noarch.rpm