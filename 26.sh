## shell脚本一天一练系列 -- Day26
## 今日脚本需求:

<<'COMMENT'
要求：
写一个自动化重启服务脚本，当访问日志频繁出现502状态码时，重启php-fpm服务。
提示：
1）假定Ngnix访问日志路径为/data/logs/www_access.log
2）重启php-fpm服务的命令为systemctl restart php-fpm
3）脚本可以每分钟执行一次，脚本执行时截取上一分钟的日志，可以计算总日志行数，和出现502的行数，计算比例，这里我给大家定一个比例吧，超过20%就算是有问题啦
访问日志片段（里面的200就是状态码）
123.52.13.247 - [30/Jul/2022:09:03:15 +0800]bbs.aabcc.cn "/thread-2403963-2-198.html" 200 "http://bbs.aabcc.cn/thread-2403963-1-198.html" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.159 Safari/537.36"
171.8.172.146 - [30/Jul/2022:09:03:15 +0800]bbs.aabcc.cn "/thread-2430178-2-7.html" 200 "http://bbs.aabcc.cn:8234/thread-2430178-8-7.html" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.159 Safari/537.36"
171.8.173.103 - [30/Jul/2022:09:03:15 +0800]bbs.aabcc.cn "/forum.php?mod=viewthread&action=printable&tid=2407976" 200 "http://bbs.aabcc.cn:8784/forum.php?mod=viewthread&tid=2407976&extra&ordertype=2" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.159 Safari/537.36"
123.52.13.247 - [30/Jul/2022:09:03:15 +0800]bbs.aabcc.cn "/thread-2396686-1-245.html" 200 "http://bbs.aabcc.cn/thread-2396686-2-245.html" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.159 Safari/537.36"

COMMENT

### ------- 分割线,以下为脚本正文 -------
#!/bin/bash
# author: aming  (微信: lishiming2009)
# version: v1
# date: 2023-10-16

## 日志文件
logfile="/data/logs/www_access.log"

## 上一分钟，关键词
last_t=`date -d "-1 min" +%Y:%H:%M`

## 把最后1万行日志截取出来，然后从这里面再过滤上一分钟的日志
tail -n 10000 $logfile |grep "/${last_t}:"  > /tmp/last.log

## 计算上一分钟日志有多少行
last_1min_c=`wc -l /tmp/last.log|awk '{print $1}'`

## 再计算状态码为502的日志有多少行
s502_c=`grep  -c '" 502 "' /tmp/last.log`

## 计算百分比，这里我们把数字乘以100，方便后续对比
p=`echo "scale=2; ${s502_c}*100/${last_1min_c}"|bc|sed 's/\.//'`

## 如果百分比超过20
if [ $p -gt 2000 ]
then
    echo "`date` 502日志大于20%,需要重启php-fpm服务" >> /tmp/restart_php-fpm.log
    systemctl restart php-fpm
fi

rm -f /tmp/last.log
