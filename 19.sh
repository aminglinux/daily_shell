## shell脚本一天一练系列 -- Day19
## 今日脚本需求:
## 编写一个巡检脚本，用来检测系统里面所有服务是否都正常运行。
## 假定，系统运行的服务有Nginx、MySQL、Redis、Tomcat
## 要求脚本有内容输出，可以明确告知服务是否正常运行。
## 提示：
## 1）如果服务进程存在并且端口监听说明服务正常。
## 2）Nginx端口443
## 3）MySQL端口3306
## 4）Redis端口6379
## 5）Tomcat端口8825
## 6）进程是否存在使用 pgrep  'xxx'  
## 7）端口是否存在使用 ss -lnp |grep 'xxxx'

### ------- 分割线,以下为脚本正文 -------
#!/bin/bash
# author: aming  (vx:  lishiming2009)
# version: v1
# date: 2023-10-07


## 判断pgrep或ss命令是否存在
check_tools()
{
    if ! which pgrep &>/dev/null
    then
         echo "本机没有pgrep命令"
         exit 1
    fi

    if ! which ss &>/dev/null
    then
         echo "本机没有ss命令"
         exit 1
    fi
}

## 使用pgrep来检测某服务进程是否在
## 该函数只有返回值为0或者1,
## 当返回值为0说明进程在，返回值为1说明进程不在
check_ps()
{ 
    if  pgrep "$1" &>/dev/null
    then
        return 0
    else
        return 1
    fi
}

## 使用ss -lnp来检测指定端口是否在
check_port()
{
    port_n=`ss -lnp|grep ":$1 "|wc -l`
    if [ $port_n -ne 0 ]
    then   
        return 0
    else
        return 1
    fi
}

## 只有check_ps和check_port同时返回值为0才能说明指定服务是正常的
check_srv()
{
    if check_ps $1 && check_port $2
    then
        echo "$1服务正常"
    else
        echo "$1服务不正常"
    fi
}

check_tools
check_srv nginx 443
check_srv mysql 3306
check_srv redis  6379
## tomcat服务要检查有没有java进程
check_srv java  8825


<<'COMMENT'
关键知识点总结：
1）如果将一条命令的结果作为if的判断条件，则当命令执行成功时条件为真，也就是说当返回值为0时，条件为真
2）pgrep后面跟进程名关键字即可将相关进程的pid列出来
3）巧用函数，减少冗余代码

COMMENT

