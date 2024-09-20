#!/bin/bash
# author:WinJayX
# date:2021-07-06
# Maintainer WinJayX <WinJayX@Gmail.com>
# func:每日对Docker MSSQL2019的数据库文件进行复制备份

DATA_DIR="/home/docker/001.mssql/data"
BACK_DIR="/home/docker/001.mssql/cifs_DB_Backup"
DATE=`date +%Y%m%d%H%M%S`

mkdir -p "$BACK_DIR"/$DATE

# TODO
echo "Start backup..."
cp -rf $DATA_DIR/*DB $BACK_DIR/$DATE/
echo "Backup end"
