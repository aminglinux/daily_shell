## shell脚本一天一练系列 -- Day45
<< 'COMMENT'
写一个shell脚本，把192.168.0.0/24网段在线的ip列出来

COMMENT

### ------- 分割线,以下为脚本正文 -------
#!/bin/bash
# author: aming  (微信:  lishiming2009)
# version: v1
# date: 2023-11-10

## 整个网段从1到254，做遍历
for i in `seq 1 254`
do 
    ## 如果ping通，则命令执行成功，条件为真，否则执行失败，条件为假
    if ping -c 2 -W 2 192.168.0.$i >/dev/null 2>/dev/null
    then
	echo "192.168.0.$i 是通的."
    else
	echo "192.168.0.$i 不通."
    fi
done

