## shell脚本一天一练系列 -- Day17
## 今日脚本需求:
## 有两个文件a.txt和b.txt，需求是，
## 把a.txt中有的且b.txt中没有的行找出来，并写入到c.txt，
## 然后计算c.txt文件的行数。

### ------- 分割线,以下为脚本正文 -------
#!/bin/bash
# author: aming  (vx:  lishiming2009)
# version: v1
# date: 2023-09-27

## 如果c.txt已经存在就先删除掉
[ -f c.txt ] && rm -f c.txt

## 使用wile循环遍历a.txt所有行
cat a.txt |while read line 
do
    ## 如果b.txt里面没有这行内容，将其写入c.txt
    if ! grep -q "^${line}$" b.txt
    then
        echo ${line} >>c.txt
    fi
done

## 计算c.txt行数
wc -l c.txt

## 或者用grep实现
## grep -vwf b.txt a.txt > c.txt;  wc -l c.txt


<<'COMMENT'
关键知识点总结：
1）遍历文件每一行，用while read ... 而不是for
2）grep "^${abc}$" b.txt，过滤的是完整的行，从头匹配到结尾

COMMENT

