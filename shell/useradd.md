```bash
#!/bin/bash
#description:useradd
#Author by WinJay <WinJayX@Gmail.com>.
#Date 11/8/2014

for i in `seq 1 20` ; do
  useradd user$i
  echo user$i | passwd --stdin user$i > /dev/null 2>&1
  chage -d 0 user$i
done

#默认添加20个用户，用户名和密码为user$（user1--user20）,首次登录用户需要强制修改密码。

#--------------------------#

if [ $# -eq 0 ];then
	echo ‘Usage: /root/mkusers userfile’
	exit 1
fi

if [ ! -f $1 ];then
	echo ‘Input file not found’
	exit 1
fi

while read line
do
	useradd -d /home/$line $line
	echo Nerc$line | passwd --stdin $line > /dev/null 2>&1
#chage -d 0 $line
done < $1

# while do  循环实现批量添加用户，需要读取 用户列表文件$1来实现增加的用户名信息。 ./useradd userlist
```

