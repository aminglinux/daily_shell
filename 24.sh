## shell脚本一天一练系列 -- Day24
## 今日脚本需求:
## 写一个脚本判断你的Linux服务器里是否开启web服务？（监听80端口）
## 如果开启了，请判断出跑的是什么服务，是httpd呢还是nginx又或者是其他的什么？

### ------- 分割线,以下为脚本正文 -------
#!/bin/bash
# author: aming  (微信:  lishiming2009)
# version: v1
# date: 2023-10-12

## 定义检测web服务是什么的函数
what_web() {
    case $1 in
       httpd)
           echo "跑的是Httpd."
           ;;
       nginx)
           echo "跑的是Nginx."
           ;;
       *)
           echo "跑的是其它服务，既不是Nginx也不是Httpd."
           ;;
    esac
}

## 如果没有监听80端口，则说明没有跑Web服务
port_n=`ss -lntp | grep ':80 '|wc -l`
if [ ${port_n} -eq 0 ]; then
     echo "没有开启Web服务";
     exit;
fi

## 将监听80端口的所有进程去重后先写入临时文件
ss -lntp|grep ':80 '|awk -F '"' '{print $2}'|sort|uniq > /tmp/web.txt

## 计算临时文件有多少行
line=`wc -l /tmp/web.txt|awk '{print $1}'`

## 如果进程不止一种，那需要做遍历
if [ $line -gt 1 ]
then
    for web in `cat /tmp/web.txt`
    do
        what_web $web
    done
else
    web=`cat /tmp/web.txt`
    what_web $web
fi

rm -f /tmp/web.txt

