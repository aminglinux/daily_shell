### prompt1
写一个shell监控脚本，监控某站点访问是否正常。
提示：
1）可以将访问的站点以参数的形式提供，例如 sh xxx.sh www.aminglinux.com
2) 状态码为2xx或者3xx表示正常
3）正常时echo正常，不正常时echo不正常

### chatgpt
要编写一个 Shell 脚本来监控网站的访问状态，你可以使用 curl 命令来获取网站的 HTTP 状态码，并根据状态码来判断网站是否正常。以下是一个基本的脚本示例：

```
#!/bin/bash

# 检查参数是否提供
if [ "$#" -ne 1 ]; then
    echo "使用方法: $0 [网址]"
    exit 1
fi

# 网站地址
URL=$1

# 使用curl获取HTTP状态码
STATUS_CODE=$(curl -o /dev/null -s -w "%{http_code}\n" $URL)

# 检查状态码是否为2xx或3xx
if [[ "$STATUS_CODE" =~ ^2 ]] || [[ "$STATUS_CODE" =~ ^3 ]]; then
    echo "网站状态正常"
else
    echo "网站状态不正常"
fi
```

如何使用这个脚本：

    将上述代码保存到一个文件中，例如 monitor_website.sh。
    通过命令行使脚本可执行，例如：chmod +x monitor_website.sh。
    运行脚本并提供要监控的网站地址，例如：./monitor_website.sh www.aminglinux.com。

这个脚本会输出“网站状态正常”如果网站的状态码是 2xx 或 3xx，否则输出“网站状态不正常”。

### prompt2
你并没有判断curl命令不在的情况，假设系统是CentOS7

### chatgpt
你提出了一个很好的观点。在编写脚本时，应当检查依赖的命令是否存在，这可以提高脚本的健壮性。针对 curl 命令，我们可以在脚本开头添加一个检查步骤，确保 curl 已经安装在系统中。如果 curl 不存在，脚本可以提示用户需要安装 curl。以下是修改后的脚本：
```
#!/bin/bash

# 检查 curl 命令是否存在
if ! command -v curl &> /dev/null; then
    echo "curl 命令未找到，脚本将退出。请先安装 curl。"
    exit 1
fi

# 检查参数是否提供
if [ "$#" -ne 1 ]; then
    echo "使用方法: $0 [网址]"
    exit 1
fi

# 网站地址
URL=$1

# 使用 curl 获取 HTTP 状态码
STATUS_CODE=$(curl -o /dev/null -s -w "%{http_code}\n" $URL)

# 检查状态码是否为 2xx 或 3xx
if [[ "$STATUS_CODE" =~ ^2 ]] || [[ "$STATUS_CODE" =~ ^3 ]]; then
    echo "网站状态正常"
else
    echo "网站状态不正常"
fi
```
在 CentOS 7 上安装 curl 的命令（如果需要）：
```
sudo yum install curl
```
这个命令将通过 CentOS 的包管理器 yum 安装 curl。在运行监控脚本之前，确保已安装 curl。
