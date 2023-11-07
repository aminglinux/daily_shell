## shell脚本一天一练系列 -- Day42
<< 'COMMENT'
脚本运行时需要检测该脚本上次是否执行完成，如果还在执行直接退出脚本，否则直接执行该脚本。

COMMENT

### ------- 分割线,以下为脚本正文 -------
#!/bin/bash
# author: aming  (微信:  lishiming2009)
# version: v1
# date: 2023-11-07

## 计算进程数
## 将本次执行的pid以及grep进程都过滤掉
p_n=$(ps -ef|grep $0|egrep -v "grep|$$" |wc -l)

## 如果进程数大于0说明上次没有执行完
if [ ${p_n} -gt 0 ]
then
    echo "上次脚本还没有执行完"
    exit 0
fi

## 后面为脚本正文，省略
## 我们可以用个sleep来测试
sleep 30
