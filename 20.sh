## shell脚本一天一练系列 -- Day20
## 今日脚本需求:
## 写一个监控服务器CPU使用率的监控脚本。
## 思路：用top -bn1 命令，取当前空闲CPU百份比值（只取整数部分），然后用100去减这个数值。

### ------- 分割线,以下为脚本正文 -------
#!/bin/bash
# author: aming  (vx:  lishiming2009)
# version: v1
# date: 2023-10-08

while :
do
    ## 先把CPU idle的值获取到
    idle=`top -bn1 |sed -n '3p' |awk -F 'ni,' '{print $2}'|cut -d. -f1 |sed 's/ //g'`
    use=$[100-$idle]
    if [ $use -gt 90 ]
    then
        echo "CPU use percent too high."
        #发邮件省略
    fi
    sleep 10
done

<<'COMMENT'
关键知识点总结：
1）监控脚本有两种方案：第一种是使用while死循环+sleep，第二种是借助系统crontab周期性执行脚本
2）编写脚本，边在命令行里调试

COMMENT

