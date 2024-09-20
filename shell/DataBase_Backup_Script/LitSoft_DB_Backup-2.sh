#!/bin/bash
# author:WinJayX
# date:2022-04-08
# Maintainer WinJayX <WinJayX@Gmail.com>
# func:每日对RCEDB数据库进行备份
# File:/var/sh/database/database_backup.sh
# Database info
DB_USER="root"
DB_PASS="1qazXSW@"
DB_NAME="rcedb"


# Others vars
BIN_DIR="/opt/mysql/bin/"
# BACK_DIR="/rcloud/bak/DB_Backup"
DATE=`date +%Y%m%d%H%M%S`

# mkdir -p "$BACK_DIR"/$DATE

# TODO
echo "Start backup..."

# 备份MySQL数据库
mysqldump --opt --all-databases  > /data/backup/mysql/$(date +%Y%m%d%H%M%S)_all-databases.tar.gz
mysqldump --opt rcedb > /data/backup/mysql/$(date +%Y%m%d%H%M%S)_rcedb.sql
mysqldump --opt comcloud_x > /data/backup/mysql/$(date +%Y%m%d%H%M%S)_comcloud_x.sql
mysqldump --opt schdb > /data/backup/mysql/$(date +%Y%m%d%H%M%S)_schdb.sql
mysqldump --opt management > /data/backup/mysql/$(date +%Y%m%d%H%M%S)_management.sql

# 备份rce、rcx数据文件
tar zcvf /data/backup/rcdb/$(date +%Y%m%d%H%M%S)_rcx-rcdb.inst-0.tar.gz /data/data/rcx-rcdb.inst-0
tar zcvf /data/backup/rcdb/$(date +%Y%m%d%H%M%S)_rcx-rcdb.inst-1.tar.gz /data/data/rcx-rcdb.inst-1
tar zcvf /data/backup/rcdb/$(date +%Y%m%d%H%M%S)_rce-rcdb.inst-0.tar.gz /data/data/rce-rcdb.inst-0
tar zcvf /data/backup/rcdb/$(date +%Y%m%d%H%M%S)_rce-rcdb.inst-1.tar.gz /data/data/rce-rcdb.inst-1

# 备份es及fdfs文件
tar zcvf /data/backup/es/$(date +%Y%m%d%H%M%S)_elasticsearch.inst-0.tar.gz /data/data/elasticsearch.inst-0
tar zcvf /data/backup/fastdfs/$(date +%Y%m%d%H%M%S)_fastdfs.inst-0.tar.gz /data/data/fastdfs.inst-0

# 清理过期备份数据
find /data/backup/ -mtime +90 -name "*.tar.gz" -exec rm -rf {} \;
find /data/backup/ -mtime +90 -name "*.sql" -exec rm -rf {} \;

echo "Backup end"

