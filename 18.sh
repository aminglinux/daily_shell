## shell脚本一天一练系列 -- Day18
## 今日脚本需求:
## 写一个脚本可以接受选项[i，I]，完成下面任务：
## 1）使用一下形式：xxx.sh [-i interface | -I ip]
## 2）当使用-i选项时，显示指定网卡的IP地址；
##    当使用-I选项时，显示其指定ip所属的网卡。
## 例：sh xxx.sh -i ens160
##     sh xxx.sh -I 192.168.0.1
## 3）当使用除[-i | -I]选项时，显示[-i interface | -I ip]此信息。
## 4）当用户指定信息不符合时，显示错误。（比如指定的eth0没有，而是eth1时）

### ------- 分割线,以下为脚本正文 -------
#!/bin/bash
# author: aming  (vx:  lishiming2009)
# version: v1
# date: 2023-09-28

## 创建打印脚本使用帮助的函数
useage()
{
    echo "Please useage: $0 -i 网卡名字 or $0 -I ip地址"
}

## 当参数不等于2，要提示脚本的使用帮助信息
if [ $# -ne 2 ]
then
    useage
    exit
fi

## 将本机所有网卡名字全部获取，暂记入临时文件
ip add |awk -F ":" '$1 ~ /^[1-9]/ {print $2}'|sed 's/ //g' > /tmp/eths.txt

## 接下来会将本机所有网卡以及对应IP记录到eth_ip.log文件里
## 但在执行脚本时，会先看是否有该文件，有的话删除掉
[ -f /tmp/eth_ip.log ] && rm -f /tmp/eth_ip.log

## 遍历网卡
for eth in `cat /tmp/eths.txt`
do
    ## 获取到网卡对应的IP地址
    ip=`ip add |grep -A2 ": $eth" |grep inet |awk '{print $2}' |cut -d '/' -f 1`
    echo "$eth:$ip" >> /tmp/eth_ip.log
done

## 删除临时文件
del_tmp_file()
{
    [ -f /tmp/eths.txt ] && rm -f /tmp/eths.txt
    [ -f /tmp/eth_ip.log ] && rm -f /tmp/eth_ip.log
}


## 当提供的网卡名字错误时要报错
wrong_eth()
{
    if ! awk -F ':' '{print $1}' /tmp/eth_ip.log | grep -qw "^$1$"
    then
        echo "请指定正确的网卡名字"
        del_tmp_file
        exit
    fi
}

## 当提供的IP地址错误时要报错
wrong_ip()
{
    if ! awk -F ':' '{print $2}' /tmp/eth_ip.log | grep -qw "^$1$"
    then
        echo "请指定正确的ip地址"
        del_tmp_file
        exit
    fi
}

## 根据第一个参数来决定执行什么指令
case $1 in
    -i)
    wrong_eth $2
    grep -w $2 /tmp/eth_ip.log |awk -F ':' '{print $2}'
    ;;


    -I)
    wrong_ip $2
    grep -w $2 /tmp/eth_ip.log |awk -F ':' '{print $1}'
    ;;

    *)
    useage
    del_tmp_file
    exit
    ;;
esac

del_tmp_file

<<'COMMENT'
关键知识点总结：
1）边写脚本，边调试
2）临时文件可以大大降低写shell脚本的难度，但不要忘记在脚本执行结束时删除掉。
3）巧用函数，减少冗余代码

COMMENT


