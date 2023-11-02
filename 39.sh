## shell脚本一天一练系列 -- Day39
<< 'COMMENT'
一个脚本每小时都需要执行。
在脚本中实现这样的功能：当时间是0点和12点时，需要将目录/data/log/下的文件全部清空，
注意只能清空文件内容而不能删除文件。
而其他时间只需要统计一下每个文件的大小，一个文件一行，输出到一个按日期和时间为名字的日志里。
需要考虑/data/log/目录下的二级、三级等子目录里面的文件。

COMMENT

### ------- 分割线,以下为脚本正文 -------
#!/bin/bash
# author: aming  (微信:  lishiming2009)
# version: v1
# date: 2023-11-2

dir=/tmp/log_stat
t=`date +%d%H`
t1=`date +%H`
logdir=/data/log

## 目录不存在就创建该目录
[ -d $dir ] || mkdir $dir

## 如果日志文件存在就需要删除该文件
[ -f $dir/$t.log ] && rm -f $dir/$t.log

## 当小时为0或者12时
if [ $t == "00" -o $t == "12" ]
then
    ## 遍历所有文件
    for f in `find $logdir/ -type f`
    do
        ## 清空文件内容
	> $f
    done
else
    ## 遍历所有文件
    for f in `find $logdir/ -type f`
    do
        ## 将文件大小以及文件名写入到日志里
	du -sh $f >> $dir/$t.log
    done
fi

