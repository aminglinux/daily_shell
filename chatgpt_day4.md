### prompt
写一个shell脚本，需求如下:
      检查/data/wwwroot/app目录下所有文件和目录，看是否满足下面条件：
      1）所有文件权限为644
      2）所有目录权限为755
      3）文件和目录所有者为www，所属组为root
      如果不满足，改成符合要求
      注意，不要直接改权限，一定要有判断的过程。

### chatGPT
要编写一个满足这些要求的Shell脚本，我们需要遍历 /data/wwwroot/app 目录下的所有文件和目录，检查它们是否符合指定的权限和所有权要求。如果不符合，脚本应自动调整它们以满足这些要求。以下是一个可能的脚本实现：

```
#!/bin/bash

# 目标目录
TARGET_DIR="/data/wwwroot/app"

# 遍历目标目录下的所有文件和目录
find "$TARGET_DIR" -exec stat -c "%n %a %U %G" {} \; | while read line; do
    # 读取文件或目录的路径、权限、用户和组
    file_path=$(echo $line | awk '{print $1}')
    file_perm=$(echo $line | awk '{print $2}')
    file_user=$(echo $line | awk '{print $3}')
    file_group=$(echo $line | awk '{print $4}')

    # 检查和设置文件权限
    if [ -f "$file_path" ]; then
        if [ "$file_perm" != "644" ] || [ "$file_user" != "www" ] || [ "$file_group" != "root" ]; then
            chmod 644 "$file_path"
            chown www:root "$file_path"
            echo "已修改文件 $file_path 的权限和所有权"
        fi
    fi

    # 检查和设置目录权限
    if [ -d "$file_path" ]; then
        if [ "$file_perm" != "755" ] || [ "$file_user" != "www" ] || [ "$file_group" != "root" ]; then
            chmod 755 "$file_path"
            chown www:root "$file_path"
            echo "已修改目录 $file_path 的权限和所有权"
        fi
    fi
done
```

这个脚本执行以下步骤：

    使用 find 命令遍历 /data/wwwroot/app 目录下的所有文件和目录。
    对于每个文件和目录，使用 stat 命令获取其路径、权限、所有者和组。
    如果是文件且其权限不是644或所有者和组不是www和root，则修改其权限和所有权。
    如果是目录且其权限不是755或所有者和组不是www和root，则修改其权限和所有权。

请在使用此脚本之前进行充分测试，以确保其行为符合您的预期。在生产环境中运行任何自动化脚本之前进行测试始终是一个好习惯。
