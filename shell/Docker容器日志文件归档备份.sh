#!/bin/bash
# author:WinJayX
# date:2021-06-28
# Maintainer WinJayX <WinJayX@Gmail.com>
# func:对当前服务器所运行的所有Docker容器日志文件进行复制归档至备份目录下并清空原日志文件。

bak_home=/mnt/sdb2/Docker/bak
date="$(date +"%Y%m%d")"
echo $date
docker_home=`docker info |grep 'Docker Root Dir' | awk -F " " '{ print $4 }'`
echo $docker_home

for i in `find $docker_home/containers -name "*.log"`
do
mkdir -p $bak_home/$date
\cp $i $bak_home/$date
echo "" > $i
done
