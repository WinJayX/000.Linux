#!/bin/bash
mkdir -p /ops/inst/
cd /ops/inst/
wget https://mirrors.tuna.tsinghua.edu.cn/jenkins/redhat-stable/jenkins-2.204.5-1.1.noarch.rpm
yum -y install jenkins-2.204.5-1.1.noarch.rpm
sed -i "s#/etc/alternatives/java#/etc/alternatives/java\n/usr/java/jdk1.8.0_144/bin/java#g" /etc/rc.d/init.d/jenkins
systemctl daemon-reload
systemctl start jenkins
echo -e "\033[32m 初始化,请等待5min... \033[0m"
sleep 300

sed -i 's/http:\/\/updates.jenkins-ci.org\/download/https:\/\/mirrors.tuna.tsinghua.edu.cn\/jenkins/g' /var/lib/jenkins/updates/default.json && sed -i 's/http:\/\/www.google.com/https:\/\/www.baidu.com/g' /var/lib/jenkins/updates/default.json

systemctl restart jenkins
echo -e "\033[32m Jenkins安装成功，请登录使用! \033[0m"
