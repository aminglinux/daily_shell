## shell脚本一天一练系列 -- Day41
<< 'COMMENT'
需求：
1）有两台Linux服务器A和B，假如A可以直接ssh到B，不用输入密码。
2）A和B都有一个目录叫做/data/web/ 这下面有很多文件，
当然我们不知道具体有几层子目录，假若之前A和B上该目录下的文件都是一模一样的。
3）但现在不确定是否一致了。需要我们写一个脚本检测A机器和B机器/data/web/目录下文件的异同，我们以A机器上的文件作为标准。
4）假若B机器少了一个a.txt文件，那我们应该能够检测出来，或者B机器上的b.txt文件有过改动，我们也应该能够检测出来
5）B机器上多了文件不用考虑

COMMENT

### ------- 分割线,以下为脚本正文 -------
#!/bin/bash
# author: aming  (微信:  lishiming2009)
# version: v1
# date: 2023-11-06

## 执行脚本的机器为A

## 赋值变量
dir=/data/web

[ -f /tmp/md5.list ] && rm -f /tmp/md5.list

## 找到/data/web下所有文件，将文件列表写入/tmp/file.list
find $dir/ -type f > /tmp/file.list

## 遍历所有文件
## 计算每一个文件的md5值
while read line 
do
    md5sum $line  >> /tmp/md5.list
done < /tmp/file.list

## 假设A机器可以免密登录B机器
## 将/tmp/md5.list文件拷贝到B机器
scp /tmp/md5.list hostB:/tmp/

## 编写在B机器上执行的检测md5值的脚本
## 以下方式为嵌入文档
cat >/tmp/check_md5.sh << EOF
#!/bin/bash

while read line 
do
    ## 获取文件名
    file_name=\$(echo \$line|awk '{print \$2}')
    ## 获取文件的md5值
    md5=\$(echo \$line|awk '{print \$1}')

    ## 如果文件存在，对比md5值是否一样，不存在则输出文件丢失
    if [ -f \$file_name ]
    then
        # 获取B机器上对应文件的md5值
	md5_b=\$(md5sum \$file_name|awk '{print \$1}')
	if [ \$md5_b != \$md5 ]
	then
	    echo "\$file_name changed."
	fi
    else
	echo "\$file_name lose."
    fi
done < /tmp/md5.list
EOF
scp /tmp/check_md5.sh hostB:/tmp/
ssh hostB "/bin/bash /tmp/check_md5.sh"

