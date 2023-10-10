## shell脚本一天一练系列 -- Day22
<<'COMMENT'
今日脚本需求: 自动添加ftp用户
假设手动添加用户的命令如下：

vi /etc/login.txt  ##增加两行,上面的为用户名，下面的为密码
username
new_password

##密码生效
db_load -T -t hash -f /etc/login.txt  /etc/vsftpd/vsftpd_login.db

##拷贝配置文件
cd  /etc/vsftpd/ftpuser
cp aaa username  ##这里的aaa为一个模板配置文件，username为新添加用户名字
sed -i "s/aaa/username/" username  ##该模板配置里，aaa为用户名，需要把里面的aaa改为新的用户名字

##重启服务
systemctl restart vsftpd

现在需要写一个脚本，把用户名以参数的形式提供给脚本，自动创建用户，密码要求随机生成。
COMMENT

### ------- 分割线,以下为脚本正文 -------
#!/bin/bash
# author: aming  (微信:  lishiming2009)
# version: v1
# date: 2023-10-10

ftpudir="/etc/vsftpd/ftpuser"

## 如果没有提供参数，需要报错，并退出脚本
if [ -z "$1" ]
then
    echo "ERROR, 请带上用户名字，例如sh $0 username" >&2
    exit 1
fi

## 如果提供的用户对应的配置文件已经存在，意味着要添加的用户已经存在，也要报错
if [ -f $ftpudir/$1 ]
then
    echo "ERROR, 用户名已经存在，请重新定义用户" >&2
    exit 1
fi

## 项目名和添加的用户名一样
pro=$1
ftp_p=`mkpasswd -s 0 -l 12`

## echo -e 可以用\n换行
echo -e "$pro\n$ftp_p" >> /etc/login.txt
db_load -T -t hash -f /etc/login.txt  /etc/vsftpd/vsftpd_login.db
cd $ftpudir
cp aaa $pro   
sed -i "s/aaa/$pro/" $pro  //把里面的aaa改为新的项目名字
systemctl restart vsftpd

echo "新用户创建完成，密码为$ftp_p"

<<'COMMENT'
关键知识点总结：
1）在shell脚本中可以在echo的字符后面增加 >&2来实现错误输出
2）echo -e 支持使用\n换行，\t 制表，而且还可以带上颜色，例如echo -e "\e[31m这是红色文本\e[0m"

COMMENT

