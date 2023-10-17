## shell脚本一天一练系列 -- Day30
<< 'COMMENT'
交互式脚本，根据提示，需要用户输入一个数字作为参数，最终打印出一个正方形。
在这里我提供一个linux下面的特殊字符■，可以直接打印出来。
示例： 如果用户输入数字为5，则最终显示的效果为
■ ■ ■ ■ ■
■ ■ ■ ■ ■
■ ■ ■ ■ ■
■ ■ ■ ■ ■
■ ■ ■ ■ ■
COMMENT

### ------- 分割线,以下为脚本正文 -------
#!/bin/bash
# author: aming  (微信:  lishiming2009)
# version: v1
# date: 2023-10-20

read -p "please input a number:" sum
a=`echo $sum |sed 's/[0-9]//g'`
if [ -n "$a" ]
then
    echo "请输入一个纯数字。"
    exit 1
fi


for n in `seq $sum`
do
    for m in `seq $sum`
    do
        if [ $m -lt $sum ]
        then
            echo -n "■ "
        else
            echo "■"
        fi
    done
done
