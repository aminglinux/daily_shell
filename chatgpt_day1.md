### Prompt:
 需求：写一个shell脚本，遍历/data/目录下的txt文件，需要考虑到该目录下所有子目录下的文件，将这些txt文件做一个备份，备份的文件名增加一个年月日的后缀，比如将aming.txt备份为aming.txt_20231001，备份的文件就放到和txt文件同一级别目录下即可。

### ChatGPT:
编写一个Shell脚本来完成你的需求，这个脚本将遍历/data/目录及其所有子目录下的.txt文件，并将它们备份到同一目录下，文件名加上年月日后缀。这里是一个可能的实现：

```
#!/bin/bash

# 设置备份日期格式，例如 20231001
backup_date=$(date +%Y%m%d)

# 遍历/data目录下的所有.txt文件
find /data/ -type f -name "*.txt" | while read file; do
    # 构造新的备份文件名，例如 aming.txt_20231001
    backup_file="${file}_${backup_date}"

    # 复制文件到新的备份文件
    cp "$file" "$backup_file"
done
```

这个脚本的工作流程如下：

    使用date +%Y%m%d命令获取当前日期，格式为年月日（YYYYMMDD）。
    使用find /data/ -type f -name "*.txt"命令找到/data/目录及其子目录下的所有.txt文件。
    使用while read file; do ... done循环遍历每个找到的文件。
    对于每个文件，构造一个新的文件名，将原文件名与备份日期连接起来，形成如aming.txt_20231001这样的文件名。
    使用cp命令将原文件复制到新的备份文件。

要使用这个脚本，你需要将其保存为一个文件，例如backup_txt_files.sh，给它执行权限（使用chmod +x backup_txt_files.sh命令），然后运行它。请确保在你的系统上运行此脚本的用户对/data/目录有足够的读写权限。
