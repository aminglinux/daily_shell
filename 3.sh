### 第三天练习题
### 需求：
### 写一个检测脚本，用来检测本机所有磁盘分区读写是否都正常。
### 提示： 可以遍历所有挂载点，然后新建一个测试文件，
### 然后再删除测试文件，如果可以正常新建和删除，那说明该分区没问题

### ------- 分割线,以下为脚本正文 -------
#!/bin/bash
#author: aming  (vx:  lishiming2009)
#version: v1
#date: 2023-09-08

for  mount_p in `df |sed '1d' |grep -v 'tmpfs' |awk '{print $NF}'`
do
    ## 创建测试文件，并删除，从而确定该磁盘分区是否有问题
    touch $mount_p/testfile  &&  rm -f $mount_p/testfile
    if [ $? -ne 0 ]
    then
        echo "$mount_p 读写有问题"
    else
        echo "$mount_p 读写正常"
    fi
done

### 关键知识点总结：
## 1）&& 连接符表示当前面的命令执行成功才会执行后面的命令
##    在本例中，只有两条命令都执行成功了，返回值才是0
##    否则任何一条命令执行出错，返回值都为非0
##
## 2）写脚本的过程中，可以一边在命令行中运行命令调试一边写脚本
##
## 3）shell脚本里sed、grep、awk无处不在，所以用好这三个工具也是关键
