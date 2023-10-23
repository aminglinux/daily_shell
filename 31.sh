## shell脚本一天一练系列 -- Day31
<< 'COMMENT'
用户输入一个数字，然后打印一个三角形，比如用户输入5，打印如下图形：
    *
   * *
  * * *
 * * * *
* * * * *
COMMENT

### ------- 分割线,以下为脚本正文 -------
#!/bin/bash
# author: aming  (微信:  lishiming2009)
# version: v1
# date: 2023-10-23

## 先来一个死循环，如果用户输入的不是纯数字，那就重新输入
while true
do
    read -p "please input the lenth: " n
    ## 判断有没有输入字符
    if [ -z $n ]
    then
        echo "要输入一个数字。"
        ## 再次循环
        continue
    else
        ## 用户输入了字符，还要判断输入的字符是不是纯数字
        n1=`echo $n|sed 's/[0-9]//g'`
        if [ -n "$n1" ]
        then
            echo "你输入的不是纯数字，重新输入。"
            ## 如果输入的不是纯数字，再次循环
            continue
        else
            ## 如果是纯数字，退出循环
            break
        fi
    fi
done

## i为行，j为列
for i in `seq 1 $n`
do
    ## 先打印空格，第一行空格为n-1，第二行为n-2,一直到0，
    ## 这里可以用n-i来表示
    j=$[$n-$i]
    for m in `seq $j`
    do
        ## 用echo -n为了不换行
        echo -n " "
    done

    ## 打印完空格，开始打印 * + 空格
    ## 第一行打印1个，第二行2个，一直到n个
    for p in `seq 1 $i` 
    do
        echo -n "* "
    done
    ## 因为前面不换行，所以最后要换行，这里直接echo即可
    echo
done
