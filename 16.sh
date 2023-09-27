## shell脚本一天一练系列 -- Day16
## 今日脚本需求:
## 写一个脚本产生随机3位的数字，并且可以根据用户的输入参数来判断输出几组。 
## 比如，脚本名字为 abc.sh。
## 执行方法：
## bash  number3.sh 直接产生一组3位数字。
## bash number3.sh 10 产生10组3位数字。

### ------- 分割线,以下为脚本正文 -------
#!/bin/bash
# author: aming  (vx:  lishiming2009)
# version: v1
# date: 2023-09-26

## 思路：产生随机的一个1位数字，然后产生三次，再然后将三个数字组合在一起

## 产生一位数字的函数 
get_a_num() {
    ## 除以10取余数
    n=$[$RANDOM%10]
    echo $n
}

## 组合三位数字的函数
get_numbers() {
    for i in 0 1 2; do
        ## 数组赋值
        a[$i]=`get_a_num`
    done
    ## 将多余的空格删除掉
    echo ${a[@]} |sed 's/ //g' 
}

if [ $# -gt 1 ]
then
     echo "The number of your parameters can only be 1."
     echo "example: bash $0 5"
     exit
fi

## 如果没有提供参数，那直接产生一个3位数字
## 如果提供了参数，要判断参数是否是一个正整数
if [ $# -eq 1 ]; then
    ## 将所有数字删除，如果是空，就说明是纯数字
    m=`echo $1|sed 's/[0-9]//g'`
    if [ -n "$m" ]; then
        echo "Useage bash $0 n, n is a number, example: bash $0 5"
        exit
    else
        echo "The numbers are:"
        for i in `seq $1`
        do
            get_numbers
        done
    fi
else
    get_numbers

fi



<<'COMMENT'
关键知识点总结：
1）RANDOM为Linux系统产生随机数的一个变量，取值范围：0-32767（2^15-1）
2）数组可以元素为单位赋值：a[0]=1;a[1]=2，获取数组的值：echo ${a[@]}，但是元素之间有空格
3）判断一个字符是否为纯数字，可以：echo $a|sed 's/[0-9]//g'，看它是否为空
4）[ -n "$a" ]判断一个变量的值是否不为空; [ -z "$a" ]判断一个变量的值是否为空

COMMENT

