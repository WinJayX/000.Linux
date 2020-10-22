Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00    0.00    0.00   0.00   0.00

################ 配置配合 计划任务每20秒更新一次 ###################
#!/bin/bash
#
#   Name:iostat 只升不降，取出iostst最新io写入写出 
#   Version Number:1.01
#   Type:服务启动脚本 
#   Language:bash shell  
#   Date:2017-07-17
#   Author:xiong

# 每隔多少秒刷新一次iostat,默认的那个值只降不升  
iostat -xdtk 5 3 > /tmp/iostst_temp.txt

# 取出现在时间
times=`date  "+%Y"年0"%h%d"日" %H"时"%M"分"%S"秒""`

# 取出最后一次iostat更新的数据,为最新数据,将最新的数据更新至/tmp/2.txt 不输出
grep "$times" -A 100 /tmp/iostst_temp.txt  > /tmp/iostst_temp2.txt


# 时间格式： 07/17/2017 03:03:06 PM
# times=`date "+%D %r"`   
# 
# 时间格式： 2017年07月17日 15时01分03秒
# times=`date  "+%Y"年0"%h%d"日" %H"时"%M"分"%S"秒""`


#############################  zabbix脚本 ###########################
#!/bin/bash
#
disk=$1
case $2 in
rrqm)
        grep "$disk" /tmp/iostst_temp2.txt | awk '{print $2}' ;;
wrqm)
        grep "$disk" /tmp/iostst_temp2.txt | awk '{print $3}' ;;
read)
		grep "$disk" /tmp/iostst_temp2.txt | awk '{print $4}' ;;
wirte)
		grep "$disk" /tmp/iostst_temp2.txt | awk '{print $5}' ;;
readin)
        grep "$disk" /tmp/iostst_temp2.txt | awk '{print $6}' ;;
wirtein)
        grep "$disk" /tmp/iostst_temp2.txt | awk '{print $7}' ;;
avgrqsz)
		grep "$disk" /tmp/iostst_temp2.txt | awk '{print $8}' ;;
avgqusz)
		grep "$disk" /tmp/iostst_temp2.txt | awk '{print $9}' ;;
await)
		grep "$disk" /tmp/iostst_temp2.txt | awk '{print $10}' ;;
rawait)
		grep "$disk" /tmp/iostst_temp2.txt | awk '{print $11}' ;;
wawait)
		grep "$disk" /tmp/iostst_temp2.txt | awk '{print $12}' ;;
svctm)
		grep "$disk" /tmp/iostst_temp2.txt | awk '{print $13}' ;;
util)
        grep "$disk" /tmp/iostst_temp2.txt | awk '{print $14}' ;;
*)
        echo "使用方法  /bash disk_name $2" 
        exit 5 ;;
esac



rrqm/s: 每秒进行 merge 的读操作数目。即 rmerge/s
wrqm/s: 每秒进行 merge 的写操作数目。即 wmerge/s
r/s: 每秒完成的读 I/O 设备次数。即 rio/s
w/s: 每秒完成的写 I/O 设备次数。即 wio/s
rsec/s: 每秒读扇区数。即 rsect/s
wsec/s: 每秒写扇区数。即 wsect/s
rkB/s: 每秒读K字节数。是 rsect/s 的一半，因为每扇区大小为512字节。
wkB/s: 每秒写K字节数。是 wsect/s 的一半。
avgrq-sz: 平均每次设备I/O操作的数据大小 (扇区)。
avgqu-sz: 平均I/O队列长度。
await: 平均每次设备I/O操作的等待时间 (毫秒)。
svctm: 平均每次设备I/O操作的服务时间 (毫秒)。
%util: 一秒中有百分之多少的时间用于 I/O 操作，即被io消耗的cpu百分比



############# 第1个版本 ##############
#!/bin/bash
#
set -e

abc=`/usr/bin/iostat -k | grep $1`
echo "$abc" > /tmp/1.txt

case $2 in
read)
        awk '{print $3}' /tmp/1.txt  ;;
wrtn)
        awk '{print $4}' /tmp/1.txt  ;;
*)
        echo " Please Use read | wrtn , Use ./bash.sh sdb read|wrtn "
esac