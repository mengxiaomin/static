#!/bin/bash

#当前日期
CurrDate=`date +"%Y-%m-%d"`

#备份日志路径
BackupLogpath=/var/log/gitlab_backup/$CurrDate.log

#本地备份路径
LocalBackuppath=/gitlab_backups

#本地备份实现
function localBackup()
{
    /opt/gitlab/bin/gitlab-rake gitlab:backup:create
}

#远程备份实现
function remoteBackup()
{
    #远程备份登陆账号
    RemoteUser=root

    #远程备份的服务器IP
    RemoteIp=192.168.0.19

    #远程备份的目录
    RemoteDir=/mnt/data/gitlab_backups

    #上传到远程服务器最新的文件,在1个小时内的
    BACKUPFILE_SEND_TO_REMOTE=$(find $LocalBackuppath -type f -mmin -60 -name '*.tar')

    scp -v $BACKUPFILE_SEND_TO_REMOTE $RemoteUser@$RemoteIp:$RemoteDir >> $BackupLogpath 2>&1

    echo "--------------------\n" >> $BackupLogpath
}

case $1 in
    local)
        localBackup
    ;;
    remote)
        remoteBackup
        exit 1
    ;;
    *)
        echo "Usage: $0 {local|remote}"
        exit 1
    ;;
esac