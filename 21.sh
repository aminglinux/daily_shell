## shell脚本一天一练系列 -- Day21
## 今日脚本需求:
## 写一个监控网卡的脚本
## 1）每10分钟检测一次网卡ens33的流量
## 2）如果流量为0，则重启网卡
## 提示：使用sar -n DEV

### ------- 分割线,以下为脚本正文 -------
#!/bin/bash
# author: aming  (微信:  lishiming2009)
# version: v1
# date: 2023-10-09

## 为了能够精准匹配关键字，需要设定语言为英语
LANG=en

## 检查sar命令是否存在，不存在需要安装对应的包
if ! which sar &>/dev/null
then
    echo "没有sar命令，使用yum安装"
    ## 通过安装sysstat包来安装sar命令
    yum install -y sysstat &> /dev/null || (echo "sar命令无法安装";exit 1)
fi

## 将eth0网卡1分钟的流量数据写入临时文件/tmp/ens33.log
sar -n DEV 1 60 |grep ens33 > /tmp/ens33.log

## n1为网卡接收的数据量
## n2为网卡发送的数据量
n1=`grep -i average /tmp/ens33.log |awk '{print $5}'|sed 's/\.//g'`
n2=`grep -i average /tmp/ens33.log |awk '{print $6}'|sed 's/\.//g'`

## 删除临时文件
rm -f /tmp/ens33.log

## 当接收和发送的数据量全部为0时，说明网卡有问题了，需要重启网卡
if [ $n1 == "000" ] && [ $n2 == "000" ]
then
    echo "网卡ens33有问题，需要重启网卡"
    ifdown ens33 && ifup ens33
fi

<<'COMMENT'
关键知识点总结：
1）临时文件可以给我们带来很大便利，但不要忘记在脚本结束时删除
2）用if which xxx 来判定某个命令在不在
3）使用||或者&&时，可以用()将多条命令作为一个整体

COMMENT

