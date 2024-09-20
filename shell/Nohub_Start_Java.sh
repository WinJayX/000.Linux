#!/bin/bash
# Author:WinJayX
# date:2024-05-11
# Maintainer WinJayX
# func:更新升级后端项目
#!/bin/sh

# JAR文件的名称和路径
JAR_NAME="lit-message.jar"
JAR_PATH="/tmp/$JAR_NAME" # JAR文件的完整路径
TARGET_DIR="/tmp/" # 指定要删除JAR文件的目录
PID_FILE="nohup.pid" # 保存PID的文件
LOG_FILE="LitMessage.log" # 日志文件


# 重新启动nohup服务
# 首先，尝试杀死旧的进程
if [ -f "/mnt/000.Docker/003.Lit-Message/$PID_FILE" ]; then
    read -r pid < "/mnt/000.Docker/003.Lit-Message/$PID_FILE"
    if kill -0 "$pid" 2>/dev/null; then
        kill "$pid"
        echo "Old process with PID $pid terminated."
    else
        echo "No process found with PID $pid."
    fi
    rm -f "/mnt/000.Docker/003.Lit-Message/$PID_FILE" # 清理PID文件
fi

rm -f "/mnt/000.Docker/003.Lit-Message/$JAR_NAME"
cp "$JAR_PATH" "/mnt/000.Docker/003.Lit-Message/"
# 再次启动新的JAR文件
# nohup java -jar "$JAR_NAME" > "$LOG_FILE" 2>&1 &
nohup java -jar "/mnt/000.Docker/003.Lit-Message/$JAR_NAME"  --spring.active=dev > "/mnt/000.Docker/003.Lit-Message/$LOG_FILE" 2>&1 &
echo $! > "/mnt/000.Docker/003.Lit-Message/$PID_FILE"

# rm -f "$TARGET_DIR"/"$JAR_NAME"
echo "New process started with PID $!"

# 脚本结束
