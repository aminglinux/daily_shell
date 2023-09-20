## shell脚本一天一练系列 -- Day6
## 今日脚本需求:
## 写一个监控脚本，监控系统负载，如果系统负载超过10，需要记录系统状态信息。
## 提示：
## 1）系统负载命令使用uptime看，过去1分钟的平均负载
## 2）系统状态使用如下工具标记：top、 vmstat、   ss 
## 3）要求每隔20s监控一次
## 4）系统状态信息需要保存到/opt/logs/下面，保留一个月，文件名建议带有`date +%s`后缀或者前缀

### ------- 分割线,以下为脚本正文 -------
#!/bin/bash
# author: aming  (vx:  lishiming2009)
# version: v1
# date: 2023-09-12

##首先看/opt/logs目录在不在，不在就创建
[ -d /opt/logs ] || mkdir -p /opt/logs

##while死循环
while :
do
    ## 获取系统1分钟的负载，并且只取小数点前面的数字
    load=`uptime |awk -F 'average:' '{print $2}'|cut -d',' -f1|sed 's/ //g' |cut -d. -f1`
    if [ $load -gt 10 ]
    then
        ##分别记录top、vmstat和ss命令的执行结果
        top -bn1 |head -n 100 > /opt/logs/top.`date +%s` 
        vmstat 1 10 > /opt/logs/vmstat.`date +%s`
        ss -an > /opt/logs/ss.`date +%s`
    fi
    ## 休眠20秒
    sleep 20
    ## 找到30天以前的日志文件删除掉
    find  /opt/logs \( -name "top*" -o -name "vmstat*" -o -name "ss*" \) -mtime +30 |xargs rm  -f
done

<<'COMMENT'
关键知识点总结：
1）||用在两条命令中间，可以起到这样的效果：当前面命令不成功就会执行后面命令
2）死循环可以使用while : + sleep 组合
3）边写脚本边在命令行里调试
4）find里可以使用小括号将多个条件组合起来当成一个整体来处理
COMMENT


