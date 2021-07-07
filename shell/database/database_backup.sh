#!/bin/sh
# File:/var/sh/database/database_backup.sh
# Database info
DB_USER="root"
DB_PASS="mder.mder/1"
#GKNX DB
GKNX_DB_NAME="db_gknx"
#DISCUZ DB
BBS_DB_NAME="ultrax"
#UCHOME DB
SPACE_DB_NAME="space"
#MOODLE DB
MOODLE_DB_NAME="moodle"

# Others vars
BIN_DIR="/usr/bin"
BACK_DIR="/var/backup/databases"
DATE=`date +%Y%m%d%H%M%S`

mkdir -p "$BACK_DIR"/$DATE

# TODO
echo "Start backup..."
$BIN_DIR/mysqldump -u$DB_USER -p$DB_PASS --opt $GKNX_DB_NAME|gzip > $BACK_DIR/$DATE/"$GKNX_DB_NAME".sql.gz
$BIN_DIR/mysqldump -u$DB_USER -p$DB_PASS --opt $BBS_DB_NAME|gzip > $BACK_DIR/$DATE/"$BBS_DB_NAME".sql.gz
$BIN_DIR/mysqldump -u$DB_USER -p$DB_PASS --opt $SPACE_DB_NAME|gzip > $BACK_DIR/$DATE/"$SPACE_DB_NAME".sql.gz
$BIN_DIR/mysqldump -u$DB_USER -p$DB_PASS --opt $MOODLE_DB_NAME|gzip > $BACK_DIR/$DATE/"$MOODLE_DB_NAME".sql.gz
echo "Backup end"

