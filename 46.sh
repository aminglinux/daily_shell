## shell脚本一天一练系列 -- Day46
<< 'COMMENT'
写一个shell脚本，检查指定的shell脚本是否有语法错误，若有错误，首先显示错误信息，然后提示用户输入q或者Q退出脚本，输入其他内容则直接用vi打开该shell脚本。

COMMENT

### ------- 分割线,以下为脚本正文 -------
#!/bin/bash
# author: aming  (微信:  lishiming2009)
# version: v1
# date: 2023-11-15

## sh的-n选项可以检测shell脚本是否有错误
## 如果有错误，则将错误信息写入/tmp/sh.err文件里
sh -n $1 2>/tmp/sh.err

## 用$?返回值来判断是否有语法错误
if [ $? -ne 0 ]
then
    cat /tmp/sh.err
    read -p "请输入q/Q退出脚本。" c

    ## 如果用户没有输入任何字符直接回车了，则退出脚本
    if [ -z "$c" ]
    then
	vi $1
        ## vi结束后要记得删除临时文件，并退出脚本
        rm -f /tmp/sh.err
        exit 0
    fi

    if [ "$c" == "q" ] || [ "$c" == "Q" ]
    then
        rm -f /tmp/sh.err
	exit 0
    else
	vi $1
        rm -f /tmp/sh.err
	exit 0
    fi
else
    echo "脚本$1没有语法错误."
    rm -f /tmp/sh.err
fi

