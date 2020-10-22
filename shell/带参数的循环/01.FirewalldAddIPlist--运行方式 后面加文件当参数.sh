#!/bin/bash

# func:Firewalld 批量添加 IP地址,并限定这些 IP 地址访问 TCP 的 80 端口。
# author:WinJayX
# date:2019-11-23
# local:HunaZhuzhou Hunahuagongzhiyejishuxueyuan

if [ $# -eq 0 ];then
    echo ‘Usage: /root/UptimeMoition.list AddIP’
exit 1
fi
if [ ! -f $1 ];then
    echo ‘Input file not found’
exit 1
fi
while read line
do
    firewall-cmd --permanent --add-rich-rule="rule family="ipv4" \
    source address="$line" port protocol="tcp" port="80" accept" &&\
    firewall-cmd --reload
done < $1