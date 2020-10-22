

## 版本1参考

```bash
#!/bin/bash
# author:WinJayX
# date:2020-04-28
# Maintainer WinJayX <WinJayX@Gmail.com>
# func:每10秒自动监测nerc.service服务状态且在退出时执行重启操作

while true
do
    ps -ef | grep "nginx" | grep -v "grep"
    if [ "$?" -eq 1 ];then          #若上次执行的命令退出的状态等于1时；0为执行成功正常退出，1为报错非正常退出
        ./startservice.sh
#       systemctl restart nerc.service ;
        echo "nginx has been restarted!"
    else
        echo "Nginx already started!"
    fi
    sleep 10
done
```

## startservice

```bash
#!/bin/bash
# author:WinJayX
# date:2020-04-28
# Maintainer WinJayX <WinJayX@Gmail.com>
# func:启动相应服务

systemctl start nerc.service
```

## 版本2参考

```bash
#!/bin/bash
# author:WinJayX
# date:2020-04-28
# Maintainer WinJayX <WinJayX@Gmail.com>
# func:每10秒自动监测nerc.service服务状态且在退出时执行重启操作
while true
do
    ps -ef | grep "dotnet" | grep -v "grep"
    if [ "$?" -eq 1 ];then
#         这个命令没成功，是否需要加sh systemctl ....
​        systemctl restart nerc.service ;
​        echo "process has been restarted!"    
​    else
​        echo "process already started!"    
​    fi
​    sleep 10
done
```



## ------Check_Nginx------

结合  Nginx+Keepalived高可用使用

```bash
#!/bin/bash
# author:WinJayX
# date:2020-04-28
# Maintainer WinJayX <WinJayX@Gmail.com>
# func:监测Nginx进程是否存在
count=$(ps -ef |grep nginx |egrep -cv "grep|$$")
if [ "$count" -eq 0 ];then
    exit 1
else
    exit 0
fi
```


