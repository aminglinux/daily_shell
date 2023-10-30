## shell脚本一天一练系列 -- Day36
<< 'COMMENT'
需求： 
根据web服务器上的访问日志，把一些请求量非常高的ip给拒绝掉！
并且每隔半小时把不再发起请求或者请求量很小的ip给解封。   
假设：
一分钟内请求量高于100次的IP视为不正常请求。
访问日志路径为/data/logs/access_log。

日志示例：
112.111.12.248 – [25/Sep/2013:16:08:31 +0800]formula-x.haotui.com “/seccode.php?update=0.5593110133088248″ 200″http://formula-x.haotui.com/registerbbs.php” “Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1;)”
61.147.76.51 – [25/Sep/2013:16:08:31 +0800]xyzdiy.5d6d.com “/attachment.php?aid=4554&k=9ce51e2c376bc861603c7689d97c04a1&t=1334564048&fid=9&sid=zgohwYoLZq2qPW233ZIRsJiUeu22XqE8f49jY9mouRSoE71″ 301″http://xyzdiy.5d6d.com/thread-1435-1-23.html” “Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 1.1.4322; .NET CLR 2.0.50727)”

COMMENT

### ------- 分割线,以下为脚本正文 -------
#!/bin/bash
# author: aming  (微信:  lishiming2009)
# version: v1
# date: 2023-10-30

## 定义封IP的函数
block_ip()
{
    ## 上一分钟
    t1=`date -d "-1 min" +%Y:%H:%M`
    log=/data/logs/access_log
 
    ## 将上一分钟的日志截取出来定向输入到/tmp/tmp_last_min.log
    egrep "$t1:[0-9]+" $log > /tmp/tmp_last_min.log

    ## 把IP访问次数超过100次的计算出来，写入到临时文件
    awk '{print $1}' /tmp/tmp_last_min.log |sort -n |uniq -c|sort -n |awk '$1>100 {print $2}' > /tmp/bad_ip.list 
    
    ## 看临时文件的行数
    n=`wc -l /tmp/bad_ip.list|awk '{print $1}'`

    ## 如果临时文件行数为0，说明我们前面没有过滤出IP，否则就是过滤出来了
    if [ $n -ne 0 ]
    then
        ## 遍历所有满足条件的IP，然后封掉这些IP
        for ip in `cat /tmp/bad_ip.list`
        do
	    iptables -I INPUT -s $ip -j REJECT
        done
    fi

    ## 删除临时文件
    rm -f /tmp/tmp_last_min.log /tmp/bad_ip.list
}

## 定义解封IP的函数
unblock_ip()
{
    ## 将包数少于5个的IP记入IP白名单临时文件里
    iptables -nvL INPUT|sed '1d' |awk '$1<5 {print $8}' > /tmp/good_ip.list

    ## 计算白名单临时文件行数
    n=`wc -l /tmp/good_ip.list|awk '{print $1}'`
    ## 如果文件不为空
    if [ $n -ne 0 ]
    then
        ## 遍历所有IP，依次解封
        for ip in `cat /tmp/good_ip.list`
        do
	    iptables -D INPUT -s $ip -j REJECT
        done
    fi
    ## 最后需要将计数器清空，从零开始
    iptables -Z

    ## 删除临时文件
    rm -f /tmp/good_ip.list
}

## 获取当前时间中的分钟
t=`date +%M`

## 如果分钟为0或者30，也就是说每隔半小时会执行封IP的函数
## 先解封，再封
if [ $t == "00" ] || [ $t == "30" ]
then
   unblock_ip
   block_ip
else
   block_ip
fi

