## shell脚本一天一练系列 -- Day10
## 今日脚本需求:
## 写一个监控脚本，监控某站点访问是否正常。
## 提示：
## 1）可以将访问的站点以参数的形式提供，例如 sh xxx.sh www.aminglinux.com
## 2) 状态码为2xx或者3xx表示正常
## 3）正常时echo正常，不正常时echo不正常


### ------- 分割线,以下为脚本正文 -------
#!/bin/bash
# author: aming  (vx:  lishiming2009)
# version: v1
# date: 2023-09-18

##检查本机有没有curl命令
if ! which curl &>/dev/null
then
    echo "本机没有安装curl"
    ## 这里假设系统为CentOS/RHEL/Rocky
    yum install -y curl 
    if [ $? -ne 0 ]
    then
        echo "没有安装成功curl"
        exit 1
    fi
fi
## 获取状态码
code=`curl --connect-timeout 3 -I $1 2>/dev/null |grep 'HTTP'|awk '{print $2}'`

## 如果状态码是2xx或者3xx，则条件成立
if echo $code |grep -qE '^2[0-9][0-9]|^3[0-9][0-9]'
then
    echo "$1访问正常"
else
    echo "$1访问不正常"
fi

