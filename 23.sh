## shell脚本一天一练系列 -- Day23
<<'COMMENT'
一个同学提到一个问题，他不小心用iptables规则把sshd端口22给封掉了，结果不能远程登录，
要想解决这问题，还要去机房，登录物理机去删除这规则。 
问题来了，要写个监控脚本，监控iptables规则是否封掉了22端口，如果封掉了，给打开。 
写好脚本，放到任务计划里，每分钟执行一次。
COMMENT

### ------- 分割线,以下为脚本正文 -------
#!/bin/bash
# author: aming  (微信:  lishiming2009)
# version: v1
# date: 2023-10-11

## 将iptables规则中，针对22端口进行DROP或者REJECT的规则ID记录到/tmp/drop.txt里
/sbin/iptables -nvL --line-number|awk '$12 == "dpt:22" && $4 ~/REJECT|DROP/ {print $1}' > /tmp/drop.txt

## 如果/tmp/drop.txt不为空，说明系统里已经封了22端口了
if [ -s /tmp/drop.txt ]
then
    ## 这里用tac命令，从最后一行开始读取，这是因为iptables的id会随着规则的删除而变化，从最后面的开始删，那么前面的id不会变
    for id in `tac /tmp/drop.txt`
    do
        /sbin/iptables -D INPUT $id
    done
fi

rm -f /tmp/drop.txt

<<'COMMENT'
关键知识点总结：
1）awk 多个条件同时满足使用&&;
2）tac倒序查看文件;
3）iptalbes删除规则，id是会变的;
COMMENT
