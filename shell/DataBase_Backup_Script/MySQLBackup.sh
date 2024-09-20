#!/bin/bash
# Author:WinJayX
# Date:2022-04-08
# Maintainer WinJayX <WinJayX@Gmail.com>
# Func:每日对指定数据库进行备份，并在备份完成后上传至OSS及清除本地备份文件。
# File:/root/RDS_Backup/Auto_Backup_RDS.sh
# Database Lit info SyS

DB_HOST="YourMySQLConnectInfo.mysql.rds.aliyuncs.com"
# DB_USER="litsoft"
# DB_PASS="pass@word1"
DB_INFO="-hYourMySQLConnectInfo.mysql.rds.aliyuncs.com -P3306 -uroot -pYourMySQLPassword"
DB_OPS="--default-character-set=utf8mb4 --hex-blob --source-data=2 --single-transaction --opt --set-gtid-purged=OFF --skip-tz-utc --events --triggers --routines"
BACK_DIR="/BashScript/TempBackupDir/"

: '
----------DB_OPS 相关说明----------
--default-character-set=utf8mb4
--single-transaction:备份期间不锁表；--https://blog.csdn.net/u013810234/article/details/105978479
--set-gtid-purged=OFF：mysqldump默认导出带gitd，不写binlog;mysqldump --set-gtid-purged=OFF 不带gid，写binlog，因不带gitd所以直接开启主从会报错binlog找不到(如果master binlog有自动清除)，需reset master，或master停止业务后备份
--opt：默认Mysqldump导出的SQL文件中不但包含了导出的数据，还包括导出数据库中所有数据表的结构信息。此Mysqldump命令参数是可选的，如果带上这个选项代表激活了Mysqldump命令的quick，add-drop-table，add-locks，extended-insert，lock-tables参数，也就是通过–opt参数在使用Mysqldump导出Mysql数据库信息时不需要再附加上述这些参数。
 –extended-insert (-e)：此参数表示可以多行插入.
 –quick：代表忽略缓冲输出，Mysqldump命令直接将数据导出到指定的SQL文件.
 –add-drop-table：顾名思义，就是在每个CREATE TABEL命令之前增加DROP-TABLE IF EXISTS语句，防止数据表重名.
 –add-locks：表示在INSERT数据之前和之后锁定和解锁具体的数据表，你可以打开Mysqldump导出的SQL文件，在INSERT之前会出现LOCK TABLES和UNLOCK TABLES语句.
更多参数说明请看 mysqldump --help
'

# TODO
echo "Start backup..."

#  备份MySQL数据库

: '
## ----------参考信息----------
  mysqldump -hYourMySQLConnectInfo.mysql.rds.aliyuncs.com -P3306 -uroot -pYourMySQLPassword --default-character-set=utf8mb4 --hex-blob --master-data=2 --single-transaction --opt --set-gtid-purged=OFF --skip-tz-utc --events --triggers --routines lit_inf_sys_db | gzip > /BashScript/TempBackupDir/$(date +%Y%m%d%H%M%S)_lit_inf_sys_db.sql.gz
  mysqldump $DB_INFO  $DB_OPS  lit_info_attendance | gzip > $BACK_DIR/$(date +%Y%m%d%H%M%S)_lit_info_attendance.sql.gz
# ----------参考结束----------
'

## Lit_Info_DB
mysqldump $DB_INFO  $DB_OPS  lit_info_oa | gzip > $BACK_DIR/$(date +%Y%m%d%H%M%S)_lit_info_oa.sql.gz
mysqldump $DB_INFO  $DB_OPS  lit_inf_sys_db | gzip > $BACK_DIR/$(date +%Y%m%d%H%M%S)_lit_inf_sys_db.sql.gz

echo "Backup end"


echo "Upload to OSS..."
: '
将备份数据上传至阿里云OSS保存
	 前提是需要先安装及配置阿里云ossutil64工具后，才可正常使用工作。
	 -r : 递归操作。
	 -u : --update,只有当目标文件不存在，或源文件的最后修改时间晚于目标文件时，ossutil才会执行上传操作。
	 具体使用请参考：https://help.aliyun.com/document_detail/179388.html
'
/usr/local/bin/ossutil64 cp -r /BashScript/TempBackupDir oss://Your-BucKet-Name/RDS_Backup/ -u

echo "Upload end..."



#  删除备份至本地存储的备份库，以节省本地存储空间
echo "Delete SQL Files..."
cd $BACK_DIR && rm -rf *sql.gz
echo "Delete end..."
echo '------备份信息化系统数据库及OA数据库，每3小时备份一次，此次完成-------'
