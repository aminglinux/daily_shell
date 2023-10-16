## shell脚本一天一练系列 -- Day27
## 今日脚本需求:

<<'COMMENT'
写一个自动部署nginx服务的脚本。手动部署步骤如下，请将下面的步骤写成shell脚本。

1）下载源码
cd  /usr/local/src
sudo curl -O http://nginx.org/download/nginx-1.23.0.tar.gz

2）解压
sudo tar zxf nginx-1.23.0.tar.gz
cd nginx-1.23.0

3）安装依赖
## RHEL/Rocky
sudo yum install -y gcc  make  pcre-devel zlib-devel  openssl-devel

4）配置
sudo ./configure --prefix=/usr/local/nginx  --with-http_ssl_module

5）编译和安装
sudo make  && sudo  make install

6）编辑system服务管理脚本
sudo vi /lib/systemd/system/nginx.service  #写入如下内容
[Unit]
Description=nginx - high performance web server
Documentation=http://nginx.org/en/docs/
After=network-online.target remote-fs.target nss-lookup.target
Wants=network-online.target

[Service]
Type=forking
PIDFile=/usr/local/nginx/logs/nginx.pid
ExecStart=/usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
ExecReload=/bin/sh -c "/bin/kill -s HUP $(/bin/cat /usr/local/nginx/logs/nginx.pid)"
ExecStop=/bin/sh -c "/bin/kill -s TERM $(/bin/cat /usr/local/nginx/logs/nginx.pid)"

[Install]
WantedBy=multi-user.target

7）加载服务
sudo  systemctl daemon-reload

8）启动服务
sudo systemctl start nginx

COMMENT

### ------- 分割线,以下为脚本正文 -------
#!/bin/bash
# author: aming  (微信: lishiming2009)
# version: v1
# date: 2023-10-17

ck_ok()
{
        if [ $? -ne 0 ]
        then
                echo "$1 error."
                exit 1
        fi
}

download_ng()
{
    cd  /usr/local/src
    if [ -f nginx-1.23.0.tar.gz ]
    then
        echo "当前目录已经存在nginx-1.23.0.tar.gz"
        echo "检测md5"
        ng_md5=`md5sum nginx-1.23.0.tar.gz|awk '{print $1}'`
        if [ ${ng_md5} == 'e8768e388f26fb3d56a3c88055345219' ]
        then
            return 0
        else
            sudo /bin/mv nginx-1.23.0.tar.gz nginx-1.23.0.tar.gz.old
        fi
    fi

    sudo curl -O http://nginx.org/download/nginx-1.23.0.tar.gz
    ck_ok "下载Nginx"
}

install_ng()
{
    cd /usr/local/src
    echo "解压Nginx"
    sudo tar zxf nginx-1.23.0.tar.gz
    ck_ok "解压Nginx"
    cd nginx-1.23.0


    echo "安装依赖"
    if which yum >/dev/null 2>&1
    then
        ## RHEL/Rocky
        for pkg in gcc make pcre-devel zlib-devel openssl-devel
        do
            if ! rpm -q $pkg >/dev/null 2>&1
            then
                sudo yum install -y $pkg
                ck_ok "yum 安装$pkg"
            else
                echo "$pkg已经安装"
            fi
        done
    fi


    if which apt >/dev/null 2>&1
    then
        ##ubuntu
        for pkg in make libpcre++-dev  libssl-dev  zlib1g-dev
        do
            if ! dpkg -l $pkg >/dev/null 2>&1
            then
                sudo apt install -y $pkg
                ck_ok "apt 安装$pkg"
            else
                echo "$pkg已经安装"
            fi
        done
    fi

    echo "configure Nginx"
    sudo ./configure --prefix=/usr/local/nginx  --with-http_ssl_module
    ck_ok "Configure Nginx"


    echo "编译和安装"
    sudo make && sudo make install
    ck_ok "编译和安装"


    echo "编辑systemd服务管理脚本"


    cat > /tmp/nginx.service <<EOF
[Unit]
Description=nginx - high performance web server
Documentation=http://nginx.org/en/docs/
After=network-online.target remote-fs.target nss-lookup.target
Wants=network-online.target

[Service]
Type=forking
PIDFile=/usr/local/nginx/logs/nginx.pid
ExecStart=/usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
ExecReload=/bin/sh -c "/bin/kill -s HUP \$(/bin/cat /usr/local/nginx/logs/nginx.pid)"
ExecStop=/bin/sh -c "/bin/kill -s TERM \$(/bin/cat /usr/local/nginx/logs/nginx.pid)"

[Install]
WantedBy=multi-user.target
EOF

    sudo /bin/mv /tmp/nginx.service /lib/systemd/system/nginx.service
    ck_ok "编辑nginx.service"

    echo "加载服务"
    sudo systemctl unmask nginx.service
    sudo  systemctl daemon-reload
    sudo systemctl enable nginx
    echo "启动Nginx"
    sudo systemctl start nginx
    ck_ok "启动Nginx"
}

download_ng
install_ng
