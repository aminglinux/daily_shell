## shell脚本一天一练系列 -- Day15
## 今日脚本需求:
## 写一个脚本判断给定的一串数字是否是合法的日期
## 比如20231301就不合法

### ------- 分割线,以下为脚本正文 -------
#!/bin/bash
# author: aming  (vx:  lishiming2009)
# version: v1
# date: 2023-09-25

## 判断是否提供一个参数
## 判断提供参数长度是否是8
if [ $# -ne 1 ] || [ ${#1} -ne 8 ]
then
    echo "Usage: bash $0 yyyymmdd"
    exit 1
fi

mydate=$1
## 截取前4个字符
year=${mydate:0:4}
## 截取第5个到第6个字符
month=${mydate:4:2}
## 截取第7个到第8个字符
day=${mydate:6:2}


if cal $day $month $year >/dev/null 2>/dev/null
then
    echo "The date is OK. The date is $year年$month月$day日"
else
    echo "The date is Error."
fi


<<'COMMENT'
关键知识点总结：
1）$#表示参数个数，${#1}表示第一个参数的长度
2）${a:n1:n2}表示变量a从第n1（从0开始算）个字符开始截取，一共截取n2个
3）cal为linux的日志，用法：cal 日 月 年; cal 月 年; cal 年; cal"
COMMENT

