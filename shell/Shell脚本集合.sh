#/bin/bash
#This is my test shell
echo "当前进程总数为："
ps -aux | wc -l

echo "当前系统盘使用百分比为："
df -h | grep '/$' | awk '{print$5}'

echo "当前磁盘总大小及使用空间为"
df -h | grep '/$' | awk '{print $2}' && \
df -h | grep '/$' | awk '{print $3}'


# 查看当前网络连接数
netstat -n | awk '/^tcp/{++b[$NF]} END {for(a in b) print a,b[a]}'



