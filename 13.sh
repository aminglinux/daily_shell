## shell脚本一天一练系列 -- Day13
## 今日脚本需求:
## 用shell脚本实现：多人抽签游戏，每人执行脚本产生一个随机数，具体要求如下
## 1）脚本执行后，输入人名，产生1-99之间的数字；
## 2）相同的名字重复执行，抓到的数字应该和之前保持一致；
## 3）前面已经出现过的数字，下次不能再出现；
## 4）需要将名字和对应的数字记录到一个文件里；
## 5）脚本一旦运行，除非按Ctrl+C停止，否则要一直运行。

### ------- 分割线,以下为脚本正文 -------
#!/bin/bash
# author: aming  (vx:  lishiming2009)
# version: v1
# date: 2023-09-21


## 假设记录名字和数字的文件为/tmp/name.log
## 文件格式为： name:number，例如，aming:99

## 创建生成随机数的函数
create_number()
{
    ##当遇到已经出现过的数字，需要自动再次生成随机数，用while循环实现
    while :
    do
        ##$RANDOM为一个随机数字，范围0-32767（2^15-1）
        ##我们为了获取1-99之间的随机数，需要将$RANDOM除以99取余数
        ##但余数范围为0-98，所以再加1就能得到我们想要的数字
	nu=$[$RANDOM%99+1]

        ##如果数字出现在了/tmp/name.log里，则n>0，n就是数字出现的次数
        n=`awk -F ':' -v NUMBER=$nu '$2 == NUMBER' /tmp/name.log|wc -l`
        if [ $n -gt 0 ]
        then
            continue
        else
            echo $nu
            break
        fi
    done
}

## while循环实现脚本不退出
while :
do
    ##和用户交互，输入名字
    read -p  "Please input a name:" name

    if [ ! -f /tmp/name.log ]
    then
        ##当记录名字和数字的文件不存在时，也就是说该脚本第一次执行时
        ##什么都不用考虑，直接打印数字即可
        number=$[$RANDOM%99+1]
        echo "Your number is: $number"
        echo "$name:$number" > /tmp/name.log
    else
        ##如果输入的名字出现在了/tmp/name.log里，则n>0，n就是名字出现的次数
        n=`awk -F ':' -v NAME=$name '$1 == NAME' /tmp/name.log|wc -l`
        if [ $n -gt 0 ]
        then
            echo "The name already exist."
            awk -F ':' -v NAME=$name '$1 == NAME' /tmp/name.log
            continue
        else
            number=`create_number`
        fi
        echo "Your number is: $number"
        echo "$name:$number" >> /tmp/name.log
    fi
done

<<'COMMENT'
关键知识点总结：
1）awk调用shell中的变量用法 awk -v NAME=$name '$1 == NAME'
2）while 循环用法，continue和break用法
3）$RANDOM用法
4）函数以及调用函数并赋值变量的用法
COMMENT

