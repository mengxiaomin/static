#! /bin/bash

#备份目录
backup_dir=/data/backup/code
src_dir=/home/wwwroot/$1

#判断源目录是否为空
if [ -z $1 ]; then
	echo '参数不能为空'
	exit 1
fi

#判断源代码文件目录是否为空
if [ ! -e $src_dir ]; then
	echo '源代码文件目录不能为空'
	exit 2
fi

#判断备份目录是否是有效目录
if [ -d $bckup_dir ]; then
	mkdir -p $backup_dir
fi

cd $backup_dir
tar -zcvf $1_$(date +%Y%m%d).tar.gz $src_dir