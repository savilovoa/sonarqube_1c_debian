#!/bin/bash

apt update
apt install net-tools wget unzip curl gnupg2 ca-certificates lsb-release socat -y
# install java
apt-get install openjdk-17-jre -y
# install postrges
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -
apt update
apt-get install postgresql postgresql-contrib -y
systemctl enable postgresql
systemctl start postgresql

echo "vm.max_map_count=262144" >> /etc/sysctl.conf
echo "fs.file-max=65536" >> /etc/sysctl.conf
echo "ulimit -n 65536" >> /etc/sysctl.conf
echo "ulimit -u 4096" >> /etc/sysctl.conf

passwd postgres
# su - postgres
# createuser sonarqube
# psql
# ALTER USER sonarqube WITH ENCRYPTED password 'sonar';
# CREATE DATABASE sonarqube OWNER sonarqube ENCODING UTF-8;
# GRANT ALL PRIVILEGES ON DATABASE sonarqube to sonarqube;
# \l проверяем кодировку если там SQL_ANSI то надо менять на UTF-8
# UPDATE pg_database SET datistemplate = FALSE WHERE datname = 'template1';
# DROP DATABASE Template1;
# CREATE DATABASE template1 WITH owner=postgres ENCODING = 'UTF-8' lc_collate = 'en_US.utf8' lc_ctype = 'en_US.utf8' template template0;
# UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template1';
# и уже пересоздать sonarqube с нужной кодировкой
# \q
# exit




