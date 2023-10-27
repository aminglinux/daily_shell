## shell脚本一天一练系列 -- Day34
<< 'COMMENT'
用shell打印下面这句话中字母数小于6的单词。 
Bash also interprets a number of multi-character options.

COMMENT

### ------- 分割线,以下为脚本正文 -------
#!/bin/bash
# author: aming  (微信:  lishiming2009)
# version: v1
# date: 2023-10-26

## 将这句话赋值给变量c
c="Bash also interprets a number of multi-character options."

## 以空白字符或者-或者.作为分隔符，看一共有多少段
## 这其实就是获取的单词个数
n=`echo $c|awk -F '[ +-.]' '{print NF}'`

## 这里要注意，最后一段为空，并非单词，需要排除掉
for i in `seq $[$n-1]`
do
    ## 遍历所有单词
    w=`echo $c|awk -F '[ +-.]' -v j=$i '{print $j}'`
    ## 获取单词的长度
    l=`echo $w|wc -L`
    if [ $l -lt 6 ]
    then
        echo "单词 $w 长度小于6" 
    fi
done

