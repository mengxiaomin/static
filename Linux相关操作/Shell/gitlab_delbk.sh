#!/bin/bash

#删除5天前的gitlab备份
find /mnt/data/gitlab_backups -mtime +5 -name "*.tar" -exec rm -rf {} \;
exit