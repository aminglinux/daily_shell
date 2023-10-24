## shell脚本一天一练系列 -- Day32
<< 'COMMENT'
设计一个脚本，监控远程的一台机器(假设ip为119.29.29.29)的存活状态，当发现宕机时发一封邮件给你自己。

核心命令:
ping -c10 119.29.29.29 通过ping来判定对方是否在线

发邮件脚本 https://aminglinux.coding.net/public/aminglinux-book/aminglinux-book/git/files/master/D22Z/mail2.py

COMMENT

### ------- 分割线,以下为脚本正文 -------
#!/bin/bash
# author: aming  (微信:  lishiming2009)
# version: v1
# date: 2023-10-24

IP="119.29.29.29"
email="aminglinux@qq.com"

n=`ping -c5 $IP|grep 'packet' |awk -F '%' '{print $1}' |awk '{print $NF}'`
if [ -z "$n" ]
then
    echo "脚本有问题。"
    exit 1
else
    n1=`echo $n|sed 's/[0-9]//g'`
    if [ -n "$n1" ]
    then
        echo "脚本有问题。"
        exit  1
    fi
fi

if [ $n -ge 20 ]
then
    echo "机器$IP宕机,丢包率是${n}%"
    #python mail.py $emil "机器$IP宕机" "丢包率是${n}%"
else
    echo "机器$IP正常，丢包率是${n}%"
fi
