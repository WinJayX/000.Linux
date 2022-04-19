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
BIN_DIR="/rcloud/app/rce-mysql-node-1/bin/"
BACK_DIR="/rcloud/bak/DB_Backup"
DATE=`date +%Y%m%d%H%M%S`

mkdir -p "$BACK_DIR"/$DATE

# TODO
echo "Start backup..."
$BIN_DIR/mysqldump -h127.0.0.1 -u$DB_USER -p$DB_PASS -P4307 --opt $DB_NAME > $BACK_DIR/$DATE/"$DB_NAME".sql
$BIN_DIR/mysqldump -h127.0.0.1 -u$DB_USER -p$DB_PASS -P4307 --opt $DB_NAME|gzip > $BACK_DIR/$DATE/"$DB_NAME".sql.gz


$BIN_DIR/mysqldump -h127.0.0.1 -u$DB_USER -p$DB_PASS -P4307 --opt $DB_NAME|gzip > $BACK_DIR/$(date +%Y%m%d%H%M%S)_"$DB_NAME".sql.gz

echo "Backup end"

