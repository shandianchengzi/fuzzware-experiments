#!/bin/bash

# 定义要搜索和杀死的关键字
keyword=$1

# 排除自己
self_pid=$$

# 使用ps和grep命令查找匹配的进程，并使用awk命令提取进程ID
pids=$(ps -aux | grep "$keyword" | grep -v grep | grep -v $self_pid | awk '{print $2}')

# 循环杀死每个进程
for pid in $pids; do
    echo "Killing process with PID: $pid"
    kill -9 $pid
done

echo "All processes matching '$keyword' have been killed."
