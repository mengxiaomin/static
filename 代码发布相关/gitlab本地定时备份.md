# 一、手动备份命令
gitlab有直接手动备份的命令

```
gitlab-rake gitlab:backup:create
```
> **特别说明：**
如果/etc/gitlab/gitlab.rb配置了参数“backup_path” (gitlab_rails['backup_path'] = '/data/backups')，则备份文件就存在/data/backups下。
不然，gitlab备份默认路径放在/var/opt/gitlab/backups

如果用这样子手动备份，很不智能，所以需要采用定任务去备份，这样子可以节省工作量。

# 二、定时自动备份
我们暂定每天凌晨1点定时自动备份

```
0 1 * * * /opt/gitlab/bin/gitlab-rake gitlab:backup:create
```

重启crontab服务

```
systemctl restart crond
```

# 三、自动清理
这块gitlab已经支持了，只要改个配置就可以搞定

```
vim /etc/gitlab/gitlab.rb
```

将其中backup_keep_time的配置取消注释，根据需要设置自动清理多少天前的备份，我这里是设置备份保留7天(7*24*3600=604800)

```
gitlab_rails['backup_keep_time'] = 604800
```
重启配置

```
gitlab-ctl reconfigure
```

