## shell脚本一天一练系列 -- Day33
<< 'COMMENT'
设计一个shell脚本来备份数据库，首先在本地服务器上保存一份数据，然后再远程拷贝一份，本地保存一周的数据，远程保存一个月。

假定，我们知道mysql root账号的密码，要备份的库为dz，本地备份目录为/bak/mysql, 远程服务器ip为192.168.123.30， 远程提供了一个rsync服务，备份的地址是 192.168.123.30::backup  

写完脚本后，需要加入到cron中，每天凌晨3点执行，cron这部分不用考虑
COMMENT

### ------- 分割线,以下为脚本正文 -------
#!/bin/bash
# author: aming  (微信:  lishiming2009)
# version: v1
# date: 2023-10-25

## 当脚本执行到某一步有问题，立即退出脚本，后续部分不再执行了
set -e

d1=`date +%w`
d2=`date +%d`
local_bakdir=/bak/mysql
remote_bakdir=192.168.123.30::backup

bak()
{
    echo "mysql bakcup begin at `date`"
    echo "执行mysqldump,备份文件为$local_bakdir/dz.sql.$d1"
    mysqldump -uroot -pxxxx dz > $local_bakdir/dz.sql.$d1
    echo "远程拷贝到$remote_bakdir/dz.sql.$d2"
    rsync -az $local_bakdir/dz.sql.$d1 $remote_bakdir/dz.sql.$d2
    echo "mysql backup end at `date`"
}

bak >>${local_bakdir}/mysqlbak.log 2>>${local_bakdir}/mysqlbak.err

##关闭set -e功能
set +e 
