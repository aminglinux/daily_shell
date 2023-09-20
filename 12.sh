## shell脚本一天一练系列 -- Day12
## 今日脚本需求:
## 编写一个带参数的脚本，实现下载文件的效果，参数有两个：
## 1）第一个参数为文件下载链接；
## 2）第二个参数为目录，即下载后保存的位置；
## 3）注意要考虑目录不存在的情况，脚本需要提示用户是否创建目录

### ------- 分割线,以下为脚本正文 -------
#!/bin/bash
# author: aming  (vx:  lishiming2009)
# version: v1
# date: 2023-09-20

## 无限循环，目的是为了创建目录
while :
do
    ## 目录存在，就跳出循环了
    if [ -d $2 ]
    then
        break
    else
        ## 目录不存在，会询问是否创建
        read -p "目录不存在，是否要创建？(输入y或者n)" yn
        case $yn in
            y|Y)
                mkdir -p $2
                break
                ;;
            n|N)
                ## 当用户输入n，意味着他不想创建目录，然后脚本直接退出即可
                exit 2
                ;;
            *)
                ##如果用户输入的提示词并不符合要求，则需要再次询问用户
                echo "你只能输入y或者n"
                continue
                ;;
        esac
    fi
done


## 进入到目标目录里
cd $2
## 使用wget命令来下载，这里假设wget命令存在，并且用户提供的链接也是没问题的
wget $1


if [ $? -eq 0 ];then
    echo "下载成功"
    exit 0
else
    echo "下载失败"
    exit 1
fi


<<'COMMENT'
关键知识点总结：
1）脚本参数为$1,$2
2）read -p使用在和用户交互的场景下
3）while循环特别适合使用在和用户交互时需要多次交互的场景下
4）break会退出循环体，continue会直接进入下一次循环
COMMENT


