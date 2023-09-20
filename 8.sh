## shell脚本一天一练系列 -- Day8
## 今日脚本需求:
## 写一个脚本实现如下功能：  
## 输入一个数字，然后运行对应的一个命令。
## 显示命令如下：
## *cmd meau**  1—date 2–ls 3–who 4–pwd
## 当输入1时，会运行date, 输入2时运行ls, 依此类推。

### ------- 分割线,以下为脚本正文 -------
#!/bin/bash
# author: aming  (vx:  lishiming2009)
# version: v1
# date: 2023-09-14

##先把提示语打印出来
echo "*cmd meau**  1—date 2–ls 3–who 4–pwd"

##使用死循环，目的是为了当用户输入的字符并非要求的字符时，
##不能直接退出脚本，而是再次重新开始
while :
do
    ##然后使用read实现和用户交互，提示让用户输入一个数字
    read -p "please input a number 1-4: " n
    case $n in
        1|5)
            date
	    ## 之所以要break，是因为当用户执行完命令就要退出脚本了
	    break
            ;;
        2)
            ls
	    break
            ;;
        3)
            who
	    break
            ;;
        4)
            pwd
	    break
            ;;
        *)
            ##如果输入的并不是1-4的数字，提示出错
            echo "Wrong input, try again!"
            ;;
    esac
done


<<'COMMENT'
关键知识点总结：
1）read -p可以在shell脚本中实现和用户交互的效果
2）case ... esac 这种逻辑判断用法，非常适合做选择题，尤其是选项很多时，选项也可以有多个值，比如1|5)
3）如果想要反复和用户交互，必须使用while循环，并借助break或者continue来控制循环流程
4）break表示退出循环体，continue表示结束本次循环，进入下一次循环
COMMENT


