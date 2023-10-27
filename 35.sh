## shell脚本一天一练系列 -- Day35
<< 'COMMENT'
在服务器上，写一个监控脚本，要求如下：
1）每隔10s去检测一次服务器上的httpd进程数，如果大于等于500的时候，就需要自动重启一下apache服务，并检测启动是否成功？
2）若没有正常启动还需再一次启动，最大不成功数超过3次则需要立即发邮件通知管理员，并且以后不需要再检测！
3）如果启动成功后，1分钟后再次检测httpd进程数，若正常则重复之前操作（每隔10s检测一次），若还是大于等于500，那放弃重启并需要发邮件给管理员，然后自动退出该脚本。
4）其中发邮件脚本为之前使用的mail.py

COMMENT

### ------- 分割线,以下为脚本正文 -------
#!/bin/bash
# author: aming  (微信:  lishiming2009)
# version: v1
# date: 2023-10-27

## 定义重启并检测apache服务的函数
check_service()
{
    ## n为一个计数器，初始值为0
    n=0
   
    ## 尝试重启apache 3次
    for i in `seq 1 3`
    do
        /usr/local/apache2/bin/apachectl restart 2>/tmp/apache.err
        if [ $? -ne 0 ]
        then
            ## 如果apache启动不成功，计数器加1
            n=$[$n+1]
            sleep 5
        else
            ## 如果apache启动成功，直接退出for循环
            break
        fi
    done

    ## 3次都没有成功，就要发邮件了
    if [ $n -eq 3 ]
    then
        ##下面的mail.py 参考https://aminglinux.coding.net/public/aminglinux-book/aminglinux-book/git/files/master/D22Z/mail2.py
        python mail.py "123@qq.com" "httpd service down" "`cat /tmp/apache.err`"
        exit 0
    fi
}   

## 监控脚本为一个死循环，每隔10s检测一次
while true
do
    ## 计算httpd进程数量
    p_n=`ps -C httpd --no-heading |wc -l`

    ## 如果进程数大于等于500
    if [ ${p_n} -ge 500 ]
    then
        ## 重启apache
        /usr/local/apache2/bin/apachectl restart
        ## 如果重启失败，需要运行check_service函数
        ## 该函数会尝试连续重启3次
        ## 若3次都重启失败则发邮件告警，并退出脚本
        if [ $? -ne 0 ]
        then
            check_service
        fi

        ## 休眠60秒，继续检测httpd进程数
        sleep 60
        p_n=`ps -C httpd --no-heading |wc -l`

        ## 如果进程数还是大于等于500，则发邮件告警
        if [ ${p_n} -ge 500 ]
        then
            python mai.py "123@qq.com" "httpd service somth wrong" "the httpd process is busy."
            exit 0
        fi
    fi
    sleep 10
done

