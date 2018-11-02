# 1. 增加一个linux用户

```
adduser hjc

passwd hjc
```

# 2. 设置sshd配置文件

```
cd /etc/ssh

//将原始配置进行备份,这是每次操作中要文件时必须的
cp sshd_config sshd_config_back

vim sshd_config
```

```
//注释改行，不注释就会报错
#Subsystem sftp /usr/libexec/openssh/sftp-server

//改成如下
Subsystem sftp internal-sftp

//如下这一段加入到"UseDNS no"的下面不然sshd服务无法启动，会报错

/**
* 添加用户和配置访问目录的格式
* Match User 用户名
  ChrootDirectory 允许访问的目录
*/
Match User hjc
ChrootDirectory /data/hjc
ForceCommand internal-sftp
X11Forwarding no
AllowTcpForwarding no
```

# 3. 重启sshd服务

```
# 如果是centos6系列的
service sshd restart

# 如果是centos7系列的
systemctl restart sshd
```

# 4. sshd的日志配置
默认sshd的日志路径为空的，所以需要设置sshd的日志路径，来排查sshd的问题

```
//设置sshd的日志路径
vim /etc/rsyslog.conf

//local7.*    /var/log/boot.log在这一行下添加如下一行
local0.*    /var/log/sshd.log

//重启日志服务
systemctl restart rsyslog
```

# 5. 测试一下
如果测试成功的话，像cd..是回不了上级目录，只会在ChrootDirectory的目录下。

```
sftp -oPort=22 hjc@192.168.0.22
```



