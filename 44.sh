## shell脚本一天一练系列 -- Day44
<< 'COMMENT'
写一个猜数字脚本，当用户输入的数字和预设数字（随机生成一个0-100的数字）一样时，直接退出，
否则让用户一直输入，并且提示用户的数字比预设数字大或者小。
COMMENT

### ------- 分割线,以下为脚本正文 -------
#!/bin/bash
# author: aming  (微信:  lishiming2009)
# version: v1
# date: 2023-11-09

## n为0-100内的随机数字
n=$[$RANDOM%101]

## while死循环
while :
do
    ## 让用户输入一个数字
    read -p "请输入一个0-100的数字：" n1


    ## 如果没有输入数字，提示让用户必须输入数字，然后继续循环
    if [ -z "$n1" ]
    then
	echo "必须要输入一个数字。"
	continue
    fi


    ## 判断用户输入的是否是纯数字
    n2=`echo $n1 |sed 's/[0-9]//g'`
    if [ -n "$n2" ]
    then
	echo "你输入的数字并不是正整数."
	continue
    else
        ## 当输入数字比目标数字小，提示数字小，然后继续循环
        ## 当输入数字比目标数字大，提示数字大，然后继续循环
	if [ $n -gt $n1 ]
	then
	    echo "你输入的数字小了，请重试。"
	    continue
	elif [ $n -lt $n1 ]
	then
	    echo "你输入的数字大了，请重试。"
	    continue
	else
            ## 猜对数字，退出循环
	    echo "恭喜你，猜对了！"
	    break
	fi
    fi
done

