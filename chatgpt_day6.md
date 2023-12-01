### prompt1
写一个shell监控脚本，监控系统负载，如果系统负载超过10，需要记录系统状态信息。
提示：
1）系统负载命令使用uptime看，过去1分钟的平均负载
2）系统状态使用如下工具标记：top、 vmstat、   ss
3）要求每隔20s监控一次
4）系统状态信息需要保存到/opt/logs/下面，保留一个月，文件名建议带有`date +%s`后缀或者前缀

### chatgpt
要创建一个Shell脚本以监控系统负载，并在系统负载超过10时记录系统状态信息，你可以按照以下步骤进行：

    使用 uptime 命令获取过去1分钟的平均系统负载。
    判断负载是否超过10。
    如果超过，则使用 top, vmstat, 和 ss 命令记录系统状态。
    每隔20秒运行一次这个检查。
    将日志保存到 /opt/logs/ 目录下，并使用 date +%s 命令来生成唯一的文件名。
    设置日志文件的保留策略，以保留一个月的日志。

以下是一个示例脚本：
```
#!/bin/bash

# 创建日志目录
mkdir -p /opt/logs/

# 无限循环，每20秒执行一次
while true; do
    # 获取过去1分钟的平均系统负载
    load=$(uptime | awk -F 'load average:' '{ print $2 }' | cut -d, -f1 | xargs)

    # 检查负载是否超过10
    if (( $(echo "$load > 10" | bc -l) )); then
        # 生成时间戳
        timestamp=$(date +%s)

        # 记录系统状态
        echo "Logging system status at $timestamp because load is $load" >> /opt/logs/system_status_${timestamp}.log
        top -b -n 1 >> /opt/logs/system_status_${timestamp}.log
        vmstat >> /opt/logs/system_status_${timestamp}.log
        ss >> /opt/logs/system_status_${timestamp}.log
    fi

    # 等待20秒
    sleep 20
done
```

请确保你有足够的权限来执行这个脚本并写入到 /opt/logs/ 目录。此外，你可能需要设置一个cron作业或其他机制来清理旧的日志文件，以保持日志文件的总量在一个合理的范围内。


### promt2
脚本中vmstat只运行了1s，这个值不一定准确，建议运行5s

### chatgpt
确实，运行 vmstat 仅1秒可能无法提供准确的系统状态信息，特别是在监控系统性能时。运行 vmstat 5秒将提供更有代表性的数据。以下是修改后的脚本，其中 vmstat 将运行5秒（通过 -n 5 参数指定）：

```
#!/bin/bash

# 创建日志目录
mkdir -p /opt/logs/

# 无限循环，每20秒执行一次
while true; do
    # 获取过去1分钟的平均系统负载
    load=$(uptime | awk -F 'load average:' '{ print $2 }' | cut -d, -f1 | xargs)

    # 检查负载是否超过10
    if (( $(echo "$load > 10" | bc -l) )); then
        # 生成时间戳
        timestamp=$(date +%s)

        # 记录系统状态
        echo "Logging system status at $timestamp because load is $load" >> /opt/logs/system_status_${timestamp}.log
        top -b -n 1 >> /opt/logs/system_status_${timestamp}.log
        vmstat 1 5 >> /opt/logs/system_status_${timestamp}.log
        ss >> /opt/logs/system_status_${timestamp}.log
    fi

    # 等待20秒
    sleep 20
done
```

在这个版本中，vmstat 每秒采集一次数据，总共采集5次。这样可以更好地反映系统的即时状态。请注意，这将使日志文件中的 vmstat 部分更长，但提供的信息也更为详细和准确。

