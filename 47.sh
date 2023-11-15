## shell脚本一天一练系列 -- Day47
<< 'COMMENT'
输入一串随机数字，然后按千分位输出。   
比如输入数字串为"123456789"，输出为123,456,789。
COMMENT

### ------- 分割线,以下为脚本正文 -------
#!/bin/bash
# author: aming  (微信:  lishiming2009)
# version: v1
# date: 2023-11-16

## 判断用户有没有提供数字
if [ -z "$1" ] || [ $# -ne 1 ]
then
    echo "请提供一串数字作为参数，且参数只需提供一个"
    echo "例: sh $0 1234567"
    exit 1
fi

## 判断提供的第一个参数是否是纯数字
if ! echo $1| egrep -q '^[0-9]+$'
then
    echo "请提供纯数字作为参数"
    exit 1
fi

## 先获取数字长度
n=`echo $1|wc -L`

## 数字加上空格，做遍历循环
for d in `echo $1|sed 's/./& /g'`
do
    ## n为数字个数，每循环一次，n减1
    ## 用n除以3取余数
    n2=$[$n%3]
    
    ## 当余数为0时，说明当前这个数字以及后面数字合起来正好是N组3位的数字，
    ## 所以需要在该数字前面增加一个逗号
    ## 否则不需要增加逗号
    ## 如果按此方法，如果数字正好是N组3位的数字，那么最终数字开头会多出来一个逗号，所以还需要处理掉
    if [ $n2 -eq 0 ]
    then
        ## 我们用echo -n使其不换号
	echo -n ",$d"
    else
	echo -n "$d"
    fi
    n=$[$n-1]
done |sed 's/^,//'

## 最后来一个换行
echo

