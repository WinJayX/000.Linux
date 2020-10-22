#!/bin/bash
# author:WinJayX
# date:2020-06-19
# Maintainer WinJayX <WinJayX@Gmail.com>
# func:Linux 并发在FTP服务器上断点续传下载文件脚本
# 
# 
killall -9 wget 
#  ps -ef | grep wget egrep -cv "grep|$$"

cd /opt/ftpfile/

wget -b -c -nH -m --ftp-user=fydd --ftp-password=63634643@ahdd ftp://218.22.21.229:21012/vod1/*
wget -b -c -nH -m --ftp-user=fydd --ftp-password=63634643@ahdd ftp://218.22.21.229:21012/ip/*
wget -b -c -nH -m --ftp-user=fydd --ftp-password=63634643@ahdd ftp://218.22.21.229:21012/asfroot/hbr/*




