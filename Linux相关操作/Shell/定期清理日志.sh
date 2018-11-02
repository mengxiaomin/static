#!/bin/bash
:<<BLOCK
青橄榄删除项目下产生的日志文件
第一个参数是项目目录名称,存在linux_op库下的code_dir表下dir_name
BLOCK

# if [ -z $1 ]; then
#     echo '项目目录名称不能为空！'
#     exit 1
# fi

#项目路径
DirArray=(project1  project2  project3 project4)


baseCodeDir="data/www"
#声明代码基础路径
#判断代码基础路径是否存在
if [ ! -d $baseCodeDir ]; then
    echo '代码基础路径不是有效目录'
    exit 2
fi


for var in ${DirArray[@]}; do
    #进入代码基础路径
    cd ${baseCodeDir}


    #完整的代码路径
    codeDir="$var/BEESCRMdata/logs/Logs"
    echo "进入${codeDir}"

    #判断代码路径是否为目录
    if [ ! -d $codeDir ]; then
        echo $codeDir
        echo '代码路径不是有效目录！'
        exit 3
    fi
    #进入代码路径
    cd ${codeDir}

    #删除7天前的日志
    find ./ -mtime +7 -name "*.log" -exec rm -rf {} \;
done