## shell脚本一天一练系列 -- Day50
<< 'COMMENT'
一个网站，使用了cdn，全国各地有几十个节点。需要你写一个shell脚本来监控各个节点是否正常。 假如
    1) 监控的url为http://www.aminglinux.com/index.php
    2) 源站ip为88.88.88.88
    3) 所有CDN节点的IP列表为/data/ip.list

COMMENT

### ------- 分割线,以下为脚本正文 -------
#!/bin/bash
# author: aming  (微信:  lishiming2009)
# version: v1
# date: 2023-11-22

## 思路：
## 首先使用curl访问源站的监控url，将结果写入临时文件1
## 遍历CDN节点列表，依次使用curl访问每一个节点IP，写入临时文件2
## 对比临时文件1和临时文件2内容是否有差异
## 如果有差异，说明该节点有异常

s_ip=88.88.88.88
url=http://www.aminglinux.com/index.php
ipf=/data/ip.list

## 访问源站，写入临时文件1
curl -H "Host:www.aminglinux.com" http://${s_ip}/index.php 2>/dev/null >/tmp/source.txt

## 遍历所有CDN节点IP
for ip in `cat $ipf`
do
    ## 访问每一个节点IP，写入临时文件2
    curl -x$ip:80 $url 2>/dev/null >/tmp/$ip.txt
    diff /tmp/source.txt /tmp/$ip.txt > /tmp/$ip.diff

    ## 如果对比有差异，说明/tmp/$ip.diff文件有内容
    n=`wc -l /tmp/$ip.diff|awk '{print $1}'`
    if [ $n -gt 0 ]
    then
	echo "节点$ip有异常."
    fi
    ## 删除临时文件
    rm -f /tmp/$ip.diff
    rm -f /tmp/$ip.txt
done

## 删除临时文件
rm -f /tmp/source.txt
