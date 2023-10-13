## shell脚本一天一练系列 -- Day25
## 今日脚本需求:
## 假设，当前MySQL服务的root密码为123456，写脚本检测MySQL服务是否正常
## 比如，可以正常进入mysql执行show processlist，并检测一下当前的MySQL服务是主还是从，
## 如果是从，请判断它的主从服务是否异常。如果是主，则不需要做什么。

### ------- 分割线,以下为脚本正文 -------
#!/bin/bash
# author: aming  (微信:  lishiming2009)
# version: v1
# date: 2023-10-13

## 把这串命令直接赋值到变量里，方便后面多次调用
#Mysql_c="mysql -uroot -p123456"
Mysql_c="mysql -uroot -paminglinux.Com -h127.0.0.1 -P3307"

## 将登录MySQL并执行命令的正确和错误输出分别指向不同的文件
$Mysql_c -e "show processlist" >/tmp/mysql_pro.log 2>/tmp/mysql_log.err

## 将已知警告信息删除
sed -i '/Using a password on the command line interface can be insecure/d' /tmp/mysql_log.err

## 如果错误日志文件内容不为空，则认为MySQL服务不正常
if [ -s /tmp/mysql_log.err ]
then
    echo "MySQL服务不正常，错误信息为:"
    cat /tmp/mysql_log.err
    rm -f /tmp/mysql_pro.log /tmp/mysql_log.err
    exit 1
else

    ## 将show slave status的输出信息写入到临时文件
    $Mysql_c -e "show slave status\G" >/tmp/mysql_s.log 2>/dev/null

    ## 如果临时文件内容不为空，则认为是从，否则就是主
    if [ -s /tmp/mysql_s.log ]
    then
        ## 判断主从状态是否正常，主要就是看Slave_IO_Running和Slave_SQL_Running这两行是不是Yes
        y1=`grep 'Slave_IO_Running:' /tmp/mysql_s.log|awk -F : '{print $2}'|sed 's/ //g'`
        y2=`grep 'Slave_SQL_Running:' /tmp/mysql_s.log|awk -F : '{print $2}'|sed 's/ //g'`

        ## 只有两个全部为Yes，主从状态才是正常的
        if [ $y1 == "Yes" ] && [ $y2 == "Yes" ]
        then
            echo "从状态正常"
        else
            echo "从状态不正常"
        fi
    fi
fi

rm -f /tmp/mysql_pro.log /tmp/mysql_s.log /tmp/mysql_log.err
