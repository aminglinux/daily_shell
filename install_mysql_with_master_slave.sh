#!/bin/bash

## 自动安装两个MySQL，并配置主从
## 作者：阿铭 微信: lishiming2009
## 日期：2023-10-13
## 版本：v1.1


### 设置变量 ###
mysql_url="https://cdn.mysql.com//Downloads/MySQL-8.0/mysql-8.0.33-linux-glibc2.12-x86_64.tar.xz"

mysql_master_base_dir="/usr/local/mysql"
mysql_master_data_dir="/data/mysql"

mysql_slave_base_dir="/usr/local/mysql_slave"
mysql_slave_data_dir="/data/mysql_slave"

mysql_root_pwd="aminglinux.Com"
mysql_rep_pwd="Aminglinux123"

##########################


ck_ok()
{
        if [ $? -ne 0 ]
        then
                echo "$1 error."
                exit 1
        fi
}


download_mysql()
{
        ##下载前，先判断当前目录下是否已经下载过
        cd /usr/local
        if [ -f mysql-8.0.33-linux-glibc2.12-x86_64.tar.xz ]
        then
                echo "当前目录已经存在mysql-8.0.33-linux-glibc2.12-x86_64.tar.xz"
                echo "检测md5"
                mysql_md5=`md5sum mysql-8.0.33-linux-glibc2.12-x86_64.tar.xz|awk '{print $1}'`
                if [ ${mysql_md5} == "2469b1ae79e98110277d9b5bee301135" ]
                then
                        return 0
                else
                        sudo /bin/mv mysql-8.0.33-linux-glibc2.12-x86_64.tar.xz mysql-8.0.33-linux-glibc2.12-x86_64.tar.xz.old
                fi
        fi
        sudo wget ${mysql_url}
        ck_ok "下载mysql"
}


install_master()
{
        cd /usr/local
        echo "解压mysql"
        sudo tar Jxf mysql-8.0.33-linux-glibc2.12-x86_64.tar.xz
        ck_ok "解压mysql"
        if [ -d ${mysql_master_base_dir} ]
        then
                echo "${mysql_master_base_dir}已经存在，挪走"
                sudo /bin/mv ${mysql_master_base_dir} ${mysql_master_base_dir}-`date +%s`
        fi
        sudo mv mysql-8.0.33-linux-glibc2.12-x86_64 mysql
        if id mysql &>/dev/null
        then
                echo "系统已经存在mysql用户，跳过创建"
        else
                echo "创建mysql用户"
                sudo useradd -s /sbin/nologin  mysql
        fi

        if [ -d ${mysql_master_data_dir} ]
        then
                echo "${mysql_master_data_dir}已经存在，挪走"
                sudo /bin/mv ${mysql_master_data_dir} ${mysql_master_data_dir}-`date +%s`
        fi
        echo "创建mysql datadir"
        sudo mkdir -p ${mysql_master_data_dir}
        sudo chown -R mysql ${mysql_master_data_dir}


        if [ -f ${mysql_master_base_dir}/my.cnf ]
        then
                echo "master配置文件已经存在,删除"
                sudo rm -f ${mysql_master_base_dir}/my.cnf
        fi
        echo "创建master配置文件my.cnf"
        cat > /tmp/my.cnf <<EOF
[mysqld]
user = mysql
port = 3306
server_id = 1
basedir = ${mysql_master_base_dir}
datadir = ${mysql_master_data_dir}
socket = /tmp/mysql-master.sock
pid-file = ${mysql_master_data_dir}/mysqld.pid
log-error = ${mysql_master_data_dir}/mysql.err
EOF
        sudo /bin/mv /tmp/my.cnf  ${mysql_master_base_dir}/my.cnf


        echo "安装依赖"
        ## 基于Rocky8的依赖安装方法
        sudo yum install -y ncurses-compat-libs-6.1-9.20180224.el8.x86_64  libaio-devel


        echo "初始化"
        sudo ${mysql_master_base_dir}/bin/mysqld --console  --datadir=${mysql_master_data_dir} --initialize-insecure --user=mysql
        ck_ok "初始化"


        if [ -f /usr/lib/systemd/system/mysqld.service ]
        then
                echo "mysql服务管理脚本已经存在，挪走"
                sudo /bin/mv  /usr/lib/systemd/system/mysqld.service /usr/lib/systemd/system/mysqld.service-`date +%s`
        fi
        echo "创建服务启动脚本"
        cat > /tmp/mysqld.service <<EOF
[Unit]
Description=MYSQL server
After=network.target
[Install]
WantedBy=multi-user.target
[Service]
Type=forking
TimeoutSec=0
PermissionsStartOnly=true
ExecStart=${mysql_master_base_dir}/bin/mysqld --defaults-file=${mysql_master_base_dir}/my.cnf --daemonize $OPTIONS
ExecReload=/bin/kill -HUP -$MAINPID
ExecStop=/bin/kill -QUIT $MAINPID
KillMode=process
LimitNOFILE=65535
Restart=on-failure
RestartSec=10
RestartPreventExitStatus=1
PrivateTmp=false
EOF


        sudo /bin/mv /tmp/mysqld.service /usr/lib/systemd/system/mysqld.service
        sudo systemctl unmask mysqld
        sudo systemctl daemon-reload
        sudo systemctl enable mysqld
        echo "启动mysql"
        sudo systemctl start mysqld
        ck_ok "启动mysql"


        echo "设置mysql密码"
        ${mysql_master_base_dir}/bin/mysqladmin -S/tmp/mysql-master.sock -uroot  password "${mysql_root_pwd}"
        ck_ok "设置mysql密码"
}


install_slave()
{

        cd /usr/local
        echo "解压mysql"
        sudo tar Jxf mysql-8.0.33-linux-glibc2.12-x86_64.tar.xz
        ck_ok "解压mysql"
        if [ -d ${mysql_slave_base_dir} ]
        then
                echo "${mysql_slave_base_dir}已经存在，挪走"
                sudo /bin/mv ${mysql_slave_base_dir} ${mysql_slave_base_dir}-`date +%s`
        fi
        sudo mv mysql-8.0.33-linux-glibc2.12-x86_64 mysql_slave
        if id mysql &>/dev/null
        then
                echo "系统已经存在mysql用户，跳过创建"
        else
                echo "创建mysql用户"
                sudo useradd -s /sbin/nologin  mysql
        fi


        if [ -d ${mysql_slave_data_dir} ]
        then
                echo "${mysql_slave_data_dir}已经存在，挪走"
                sudo /bin/mv ${mysql_slave_data_dir} ${mysql_slave_data_dir}-`date +%s`
        fi
        echo "创建mysql datadir"
        sudo mkdir -p ${mysql_slave_data_dir}
        sudo chown -R mysql ${mysql_slave_data_dir}


        if [ -f ${mysql_slave_base_dir}/my.cnf ]
        then
                echo "slave配置文件已经存在,删除"
                sudo rm -f ${mysql_slave_base_dir}/my.cnf
        fi
        echo "创建slave配置文件my.cnf"
        cat > /tmp/my.cnf <<EOF
[mysqld]
user = mysql
port = 3307
server_id = 2
basedir = ${mysql_slave_base_dir}
datadir = ${mysql_slave_data_dir}
socket = /tmp/mysql-slave.sock
pid-file = ${mysql_slave_data_dir}/mysqld.pid
log-error = ${mysql_slave_data_dir}/mysql.err
EOF
        sudo /bin/mv /tmp/my.cnf ${mysql_slave_base_dir}/my.cnf


        echo "安装依赖"
        sudo yum install -y ncurses-compat-libs-6.1-9.20180224.el8.x86_64  libaio-devel

        echo "初始化"
        sudo ${mysql_slave_base_dir}/bin/mysqld  --datadir=${mysql_slave_data_dir} --console --initialize-insecure --user=mysql
        ck_ok "初始化"


        if [ -f /usr/lib/systemd/system/mysqld-slave.service ]
        then
                echo "mysql-slave服务管理脚本已经存在，挪走"
                sudo /bin/mv  /usr/lib/systemd/system/mysqld-slave.service /usr/lib/systemd/system/mysqld-slave.service-`date +%s`
        fi
        echo "创建服务启动脚本"
        cat > /tmp/mysqld-slave.service <<EOF
[Unit]
Description=MYSQL server
After=network.target
[Install]
WantedBy=multi-user.target
[Service]
Type=forking
TimeoutSec=0
PermissionsStartOnly=true
ExecStart=${mysql_slave_base_dir}/bin/mysqld --defaults-file=${mysql_slave_base_dir}/my.cnf --daemonize $OPTIONS
ExecReload=/bin/kill -HUP -$MAINPID
ExecStop=/bin/kill -QUIT $MAINPID
KillMode=process
LimitNOFILE=65535
Restart=on-failure
RestartSec=10
RestartPreventExitStatus=1
PrivateTmp=false
EOF


        sudo /bin/mv /tmp/mysqld-slave.service /usr/lib/systemd/system/mysqld-slave.service
        sudo systemctl unmask mysqld-slave
        sudo systemctl daemon-reload
        sudo systemctl enable mysqld-slave
        echo "启动mysql"
        sudo systemctl start mysqld-slave
        ck_ok "启动mysql"


        echo "设置mysql密码"
        ${mysql_slave_base_dir}/bin/mysqladmin -S/tmp/mysql-slave.sock -uroot  password "${mysql_root_pwd}"
        ck_ok "设置mysql密码"

}


config_rep()
{


        echo "在master上创建rep用户"
        sudo ln -s ${mysql_master_base_dir}/bin/mysql /usr/bin/mysql


        mysql -uroot -S/tmp/mysql-master.sock -p"${mysql_root_pwd}" -e "create user 'repuser'@'127.0.0.1' identified with 'mysql_native_password' by \"${mysql_rep_pwd}\";"
        mysql -uroot -S/tmp/mysql-master.sock -p"${mysql_root_pwd}" -e "grant REPLICATION SLAVE ON *.* to 'repuser'@'127.0.0.1'; flush privileges;"
        ck_ok "创建rep用户"




        echo "获取mster的binlog文件和位置"
        mysql -uroot -S/tmp/mysql-master.sock -p"${mysql_root_pwd}" -e "show master status\G"  > /tmp/master_file_pos.txt
        ck_ok "获取master status"
        binfile=`grep "File" /tmp/master_file_pos.txt|awk -F': ' '{print $2}'`
        pos=`grep "Position" /tmp/master_file_pos.txt|awk -F': ' '{print $2}'`


        echo "到slave上配置主从"
        mysql -uroot -S/tmp/mysql-slave.sock -p"${mysql_root_pwd}" -e "stop slave; change master to master_host='127.0.0.1',master_user='repuser',master_password=\"${mysql_rep_pwd}\",master_log_file=\"${binfile}\",master_log_pos=${pos}; start slave;"


        echo "检测主从状态"
        mysql -uroot -S/tmp/mysql-slave.sock -p"${mysql_root_pwd}" -e "show slave status\G" > /tmp/slave_stat.txt
        ck_ok "获取slave status"
        io_run=`grep 'Slave_IO_Running:' /tmp/slave_stat.txt|awk -F': ' '{print $2}'`
        sql_run=`grep 'Slave_SQL_Running:' /tmp/slave_stat.txt|awk -F': ' '{print $2}'`
        if [ ${io_run} == "Yes" ] && [ ${sql_run} == 'Yes' ]
        then
                echo "mysql主从状态正常"
        else
                echo "mysql主从状态不正常"
                exit 1
        fi
}


main()
{
        download_mysql
        install_master
        install_slave
        config_rep
}

main
