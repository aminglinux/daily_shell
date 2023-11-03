## shell脚本一天一练系列 -- Day40
<< 'COMMENT'
计算文档a.txt中每一行中出现的数字个数并且要计算一下整个文档中一共出现了几个数字。
例如a.txt内容如下： 
12aa*lkjskdj
alskdflkskdjflkjj

我们脚本名字为 ncount.sh, 运行它时： bash ncount.sh a.txt 
输出结果应该为： 
2 
0 
sum:2

COMMENT

### ------- 分割线,以下为脚本正文 -------
#!/bin/bash
# author: aming  (微信:  lishiming2009)
# version: v1
# date: 2023-11-3

if [ $# -ne 1 ]
then
    echo "参数个数只能是1"
fi


##先给sum赋值0
sum=0

## 遍历文件每一行
while read line
do
    ## 将该行所有非数字字符删除，剩下数字，再计算有几个数字
    line_n=`echo $line|sed 's/[^0-9]//g'|wc -L`
    echo "$line_n"

    ## sum的值为sum+line_n
    sum=$[$sum+$line_n]
done  < $1
echo "sum:$sum"
