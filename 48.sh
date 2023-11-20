## shell脚本一天一练系列 -- Day48
<< 'COMMENT'
我们用ps aux可以查看到进程的PID，而每个PID都会在/proc内产生。
如果查看到的pid在proc内是没有的，则进程被人修改了，这就代表系统很有可能已经被入侵过了。 
请用上面知识编写一个shell，定期检查下自己的系统是否被人入侵过
COMMENT

### ------- 分割线,以下为脚本正文 -------
#!/bin/bash
# author: aming  (微信:  lishiming2009)
# version: v1
# date: 2023-11-20

## 本shell脚本的pid赋值为pp
pp=$$

## 用ps将所有进程信息全部写入临时文件里
ps -elf |sed '1'd > /tmp/pid.txt

## 利用awk，将pid那一列截取出来（本脚本的pid除外），做遍历循环
for pid in `awk -v ppn=$pp '$5!=ppn {print $4}' /tmp/pid.txt`
do
    ## 如果不存在/proc/pid目录，则判定该进程有异常
    if ! [ -d /proc/$pid ]
    then
	echo "系统中并没有pid为$pid的目录，需要检查。"
    fi    
done

## 删除临时文件
rm -f /tmp/pid.txt
