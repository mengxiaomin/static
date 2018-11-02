#! /bin/bash

:<<BLOCK
压缩代码文件
第一个参数表示tar文件名,
第二个参数表示压缩的代码文件路径,
第三个参数表是否要全部压缩: 1:全部，0:非全部
BLOCK

#判断第一个参数表示代码tar文件是否为空
if [ -z $1 ]; then
	echo '压缩的tar文件不能为空！'
	exit 1
fi

#判断第二个参数表示压缩的文件路径
if [ -z $2 ]; then
	echo '压缩的代码文件路径不能为空！'
	exit 2
fi

#定义压缩文件和压缩目录
tarFile=$1
tarDir=$2

#判断路径是否存在
if [ ! -e /home/wwwroot/$tarDir ]; then
	echo '压缩的代码文件路径不存在！'
	exit 3
fi

#定义导出目录
exportDir=/data/exportCode/$tarDir
#判断路径不是有效目录
if [ ! -d $exportDir ]; then
	mkdir -p $exportDir
fi

#先将代码导出来
cp -R /home/wwwroot/$tarDir $exportDir

#打包项目目录文件
cd /data/exportCode

rm -rf ${tarDir}/.git

tar -czvf ${tarFile} --exclude=${tarDir}/data/logs --exclude=${tarDir}/data/conf/db.php --exclude=${tarDir}/data/conf/cache.php --exclude=${tarDir}/app/Extend/Task/Core/Config/db.php --exclude=${tarDir}/app/Extend/Task/Core/Config/cache.php --exclude=${tarDir}/index.php --exclude=${tarDir}/map.php --exclude=${tarDir}/info.php --exclude=${tarDir}/.git --exclude=${tarDir}/Uploads ${tarDir}


#打包成功后，删除导出目录
if [ -e $exportDir ]; then
	rm -rf $exportDir
fi
