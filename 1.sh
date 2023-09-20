### 第一天练习题
### 需求：
### 写一个脚本，遍历/data/目录下的txt文件
### 将这些txt文件做一个备份
### 备份的文件名增加一个年月日的后缀，比如将aming.txt备份为aming.txt_20231001

### ------- 分割线,以下为脚本正文 -------

#!/bin/bash
#author: aming  (vx:  lishiming2009)
#version: v1
#date: 2023-09-06

##定义后缀变量，大家注意下面这个``（反引号）的含义。
suffix=`date +%Y%m%d`

##找到/data/目录下的txt文件,用for循环遍历
for f in `find /data/ -type f -name "*.txt"`
do
    echo "备份文件$f"
    cp ${f} ${f}_${suffix}
done

##关键知识点总结：
##1）date命令用法，可以根据日期、时间获取到想要的字符
##2）for循环如何遍历文件 
