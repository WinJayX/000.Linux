#!/bin/bash
# author:WinJayX
# date:2020-04-28
# Maintainer WinJayX <WinJayX@Gmail.com>
# func:Clear System Logs
# 
echo “开始清除日志文件”

sed -i '1,50d' /var/log/boot.log >/dev/null 2>&1
sed -i '1,50d' /var/log/firewalld >/dev/null 2>&1
sed -i '1,1000d' /var/log/messages >/dev/null 2>&1 #清除系统开机发生的错误
sed -i '1,50d' /var/log/yum.log >/dev/null 2>&1
sed -i '1,50d' /var/log/mariadb/mariadb.log >/dev/null 2>&1 #清除数据库日志
sed -i '1,50d' /var/log/nginx/access.log >/dev/null 2>&1
sed -i '1,50d' /var/log/nginx/check.log >/dev/null 2>&1
sed -i '1,50d' /var/log/nginx/error_log >/dev/null 2>&1
sed -i '1,50d' /var/log/tuned/tuned.log >/dev/null 2>&1
sed -i '1,100d' /var/log/anaconda/storage.log >/dev/null 2>&1
sed -i '1,500d' /var/log/anaconda/packaging.log >/dev/null 2>&1
sed -i '1,1000d' /var/log/audit/audit.log >/dev/null 2>&1
sed -i '1,1000d' /var/log/anaconda/journal.log >/dev/null 2>&1
sed -i '1,1000d' /var/log/anaconda/anaconda.log >/dev/null 2>&1




# sed -i '1,50d' /var/log/dnf.log >/dev/null 2>&1
# sed -i '1,50d' /var/log/dnf.rpm.log >/dev/null 2>&1
# sed -i '1,50d' /var/log/ntp.log >/dev/null 2>&1
# sed -i '1,50d' /var/log/hawkey.log >/dev/null 2>&1
# sed -i '1,50d' /var/log/chrony >/dev/null 2>&1 #清除定时任务记录
# sed -i '1,50d' /var/log/xferlog >/dev/null 2>&1 #清除ftp记录
# sed -i '1,50d' /var/log/secure >/dev/null 2>&1 #清除sshd信息
# 
# 
history -c #清除历史执行命令

echo > /var/log/wtmp >/dev/null 2>&1 #清除系统登录成功的记录
echo > /var/log/btmp >/dev/null 2>&1 #清除系统登录失败的记录
echo > /var/log/lastlog >/dev/null 2>&1 

rm -fr /var/log/boot.log-* /var/log/btmp-* /var/log/cron-* \
/var/log/maillog-* /var/log/messages-* /var/log/secure-* \
/var/log/spooler-* /var/log/xferlog-* /var/log/messages-* \
/var/log/multi-nic-util/*

rm -fr /var/log/nginx/*.gz /var/log/*.old 

rm -rf /mnt/001.BoxSrc/003.task/WisdomBoxJob/wwwroot/001.logs/001.taskLogs/*.* 
rm -rf /mnt/001.BoxSrc/003.task/WisdomBoxJob/wwwroot/001.logs/001.taskLogs/error/*.*



# func:Clear BoxSystem Logs

cd /mnt/001.BoxSrc/003.task/WisdomBoxJob/wwwroot/001.logs/001.taskLogs
declare -i filesum=`ls _* | wc -l`
declare -i delnum=$filesum-2
if [ "${delnum}" -ge 2 ];then
	rm -rf `ls -tr _* | head -${delnum}`
fi

cd /mnt/001.BoxSrc/003.task/WisdomBoxJob/wwwroot/001.logs/001.taskLogs/error
declare -i filesum=`ls _* | wc -l`
declare -i delnum=$filesum-2
if [ "${delnum}" -ge 2 ];then
	rm -rf `ls -tr _* | head -${delnum}`
fi