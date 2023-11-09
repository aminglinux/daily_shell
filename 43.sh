## shell脚本一天一练系列 -- Day43
<< 'COMMENT'
写一个支持选项的增加或删除用户的shell脚本，具体要求如下：

1) 只支持三个选项:'--del','--add','--help'，输入其他选项报错。
2) 使用'--add'时，需要验证用户名是否存在，存在则反馈存在，且不添加。 不存在则创建该用户，需要设置与该用户名相同的密码。
3) 使用'--del'时，需要验证用户名是否存在，存在则删除用户及其家目录。不存在则反馈该用户不存在。 
4) --help选项反馈出使用方法。
5) 能用echo $?检测脚本执行情况，成功删除或添加用户为0，不成功为非0正整数。
6) 能以英文逗号分割，一次性添加或者删除多个用户。例如 adddel.sh --add user1,user2,user3

COMMENT

### ------- 分割线,以下为脚本正文 -------
#!/bin/bash
# author: aming  (微信:  lishiming2009)
# version: v1
# date: 2023-11-08

## 先检查参数个数为0或者参数个数大于2的情况
if [ $# -eq 0 ] || [ $# -gt 2 ]
then
    echo "Wrong, use bash $0 --add username, or bash $0 --del username or bash $0 --help" >&2
    exit 1
fi

## 编写添加用户的函数
add_user()
{
    if ! id $1 2>/dev/null >/dev/null
    then
	(useradd $1 && echo "$1 add successful." && return 0) || return 2
    else
	echo "Wrong $1 exist." >&2
        return 2
    fi
}

## 编写删除用户的函数
del_user()
{
    if id $1 2>/dev/null >/dev/null
    then
	(userdel -r $1 && echo "$1 delete successful." && return 0) || return 2
    else
	echo "Wrong $1 not exist." >&2
        return 2
    fi
}
	

case $1 in 
    --add)
        ## 当参数个数为1时
	if [ $# -eq 1 ]
	then
	    echo "Wrong, use bash $0 --add user or bash	$0 --add user1,user2,user3..." >&2
	    exit 1
	else
            ## 获取要添加用户的个数
	    n=`echo $2| awk -F ',' '{print NF}'`

            ## 如果用户个数大于1，需要遍历所有用户
	    if [ $n -gt 1 ]
	    then
                ## n1为计数器，目的是计算add_user函数返回值是否为0
                n1=0
	        for i in `seq 1 $n`
		do
                    ## 获取用户名
		    username=`echo $2 |awk -v j=$i -F ',' '{print $j}'`
		    add_user $username
                    n1=$[$n1+$?]
	        done
                [ $n1 -gt 0 ] && exit 3 || exit 0
	    else
		add_user $2
                [ $? -gt 0 ] && exit 3 || exit 0
	    fi
	fi
	;;

    --del)
        ## 当参数个数为1时
	if  [ $# -eq 1 ]
        then
            echo "Wrong, use bash $0 --del user or bash $0 --del user1,user2,user3..." >&2
            exit 1
        else
            n=`echo $2| awk -F ',' '{print NF}'`
            if [ $n -gt 1 ]
            then
                ## n1为计数器，目的是计算del_user函数返回值是否为0
                n1=0
                for i in `seq 1 $n`
                do
                    username=`echo $2 |awk -v j=$i -F ',' '{print $j}'`
		    del_user $username
                    n1=$[$n1+$?]
                done
                [ $n1 -gt 0 ] && exit 3 || exit 0
            else
		del_user $2
                [ $? -gt 0 ] && exit 3 || exit 0
            fi
        fi
        ;;

    --help)
        if  [ $# -ne 1 ]
        then
            echo "Wrong, use bash $0 --help" >&2
            exit 1
        else

	echo "Use bash $0 --add username or bash $0 --add user1,user2,user3... add user."
	echo "    bash $0 --del username -r bash $0 --del user1,user2,user3... delete user."
	echo "    bash $0 --help print this info."
	fi
    ;;

    *)
	echo "Wrong, use bash $0 --add username, or bash $0 --del username or bash $0 --help" >&2
    ;;

esac

