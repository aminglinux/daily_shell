## shell脚本一天一练系列 -- Day9
## 今日脚本需求:
## 写一个脚本，执行后，打印一行提示"Please input a number:"
## 要求用户输入数值，然后打印出该数值，然后再>次要求用户输入数值。
## 直到用户输入"end"停止。


### ------- 分割线,以下为脚本正文 -------
#!/bin/bash
# author: aming  (vx:  lishiming2009)
# version: v1
# date: 2023-09-15

## 死循环，做到让用户反复输入
while :
do
    ## 提示语
    read -p "Please input a number:(Input "end" to quit) " n
    ## 使用sed将用户输入的字符串中数字替换为空，如果是纯数字，那么num的值为1
    ## 为什么是1而不是0呢，因为wc -c会把回车也标记为1个字符
    num=`echo $n |sed -r 's/[0-9]//g'|wc -c`
    if [ $n == "end" ]
    then
         exit
    fi
    if [ $num -ne 1 ]
    then
         echo "What you input is not a number! Try again!"
    else
         echo "The number you entered is: $n"
    fi
done

<<'COMMENT'
关键知识点总结：
1）wc -c计算字符串长度，其中回车也算是一个字符
2）使用sed 's/[0-9]//g'可以将字符串里的数字删除
3）exit直接退出脚本
COMMENT

