## shell脚本一天一练系列 -- Day38
<< 'COMMENT'
写个shell，看看你的Linux系统中是否有普通用户，若是有，一共有几个？
提示： 对于CentOS7/CentOS8/Rocky8/RHEL8/Rocky9/RHEL9 系统，普通用户uid大于等于1000
而早期的CentOS5/CentOS6，普通用户uid大于等于500
COMMENT

### ------- 分割线,以下为脚本正文 -------
#!/bin/bash
# author: aming  (微信:  lishiming2009)
# version: v1
# date: 2023-11-1

## 定义函数，方便后面调用
## 给定函数的参数即为普通用户的数量
usernumber()
{
      if [ $1 -eq 0 ]
      then
          echo "系统没有自定义的用户"
      else
          echo "系统存在自定义用户，有$1个"
      fi
}

## 如果系统没有/etc/redhat-release文件，退出脚本
## 否则过滤出系统版本
if [ -f /etc/redhat-release ]
then
    v=`awk -F 'release ' '{print $2}' /etc/redhat-release |cut -d '.' -f1`
else
    echo "本脚本不适配该系统"
    exit 1
fi

case $v in 
  5|6)
      ## 用awk计算第三列（即uid）大于等于500的行有多少
      n=`awk -F ':' '$3>=500' /etc/passwd|wc -l`
      usernumber $n
      ;;
  7|8|9)
      ## 用awk计算第三列（即uid）大于等于1000的行有多少
      n=`awk -F ':' '$3>=1000' /etc/passwd|wc -l`
      usernumber $n
      ;;
  *)
      echo "脚本出错."
      ;;
esac 

