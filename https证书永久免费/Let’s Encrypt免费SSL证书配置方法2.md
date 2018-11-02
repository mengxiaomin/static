> 采用letsencrypt.sh来进行安装

[toc]

# 1. 环境准备，安装git和依赖库
由于安装letsencrypt依赖git和python2.7,所以需要进行安装

```
#安装git
yum install git

#安装python所需的依赖库
yum install zlib-devel
yum install bzip2-devel
yum install openssl-devel
yum install ncurses-devel
yum install sqlite-devel
```

# 2. 安装python2.7

由于letsencrypt是依赖于python2.7，所以需要对python进行升级

```
#下载2.7报
cd /usr/local/src

wget https://www.python.org/ftp/python/2.7.14/Python-2.7.14.tgz

#解压python2.7包
tar -zxvf Python-2.7.14.tgz

#编译安装
cd Python-2.7.14
./configure --prefix=/usr/local/python2.7
make && make install
```
这个时候python2.7就会安装在/usr/local/python2.7下了

```
#系统自带的 Python 是在 /usr/bin 目录下
ll -tr /usr/bin/python*

-rwxr-xr-x 1 root root 1418 8月  18 2016 /usr/bin/python2.6-config
-rwxr-xr-x 2 root root 4864 8月  18 2016 /usr/bin/python2.6
-rwxr-xr-x 2 root root 4864 8月  18 2016 /usr/bin/python
lrwxrwxrwx 1 root root    6 9月   4 2017 /usr/bin/python2 -> python
lrwxrwxrwx 1 root root   16 9月   4 2017 /usr/bin/python-config -> python2.6-config
```
备份旧的python，将系统默认的python版本更新成2.7的

```
mv /usr/bin/python /usr/bin/python2.6.6
mv /usr/bin/python-config /usr/bin/python2.6.6-config

ln -s /usr/local/python2.7/bin/python2.7 /usr/bin/python
ln -s /usr/local/python2.7/bin/python-config /usr/bin/python-config
ln -s /usr/local/python2.7/bin/python2.7 /usr/bin/python2.7
```
查看新的python的版本

```
python --version

Python 2.7.14
```
修改yum,在使用了新的python之后原来的yum就不能用了，因为yum不支持python2.7，报了如下提示错误
![](http://p4sk87cgm.bkt.clouddn.com/15289796239885.jpg)

```
vim /usr/bin/yum

将头部
#!/usr/bin/python
改成
#!/usr/bin/python2.6.6
```
下载安装python的包管理器pip

```
1. wget https://bootstrap.pypa.io/ez_setup.py -O - | python

2. unzip setuptools-[版本号].zip && cd setuptools-[版本号]

3. python setup.py install

4. ln -sv /usr/local/python2.7/bin/easy_install /usr/bin/easy_install

5. wget --no-check-certificate https://bootstrap.pypa.io/get-pip.py

6. python get-pip.py

7. ln -sv /usr/local/python2.7/bin/pip /usr/bin/pip 
```

# 3.获取Let's Encrypt免费证书
利用脚本快速获取Let’s Encrypt SSL证书

```
wget https://raw.githubusercontent.com/xdtianyu/scripts/master/lets-encrypt/letsencrypt.conf
wget https://raw.githubusercontent.com/xdtianyu/scripts/master/lets-encrypt/letsencrypt.sh
chmod +x letsencrypt.sh
```

配置文件。只需要修改 DOMAIN_KEY DOMAIN_DIR DOMAINS 为你自己的信息

```
#账户密钥
ACCOUNT_KEY="letsencrypt-account.key"   

#域名私钥
DOMAIN_KEY="自定义的key"    #domain.key

#域名指向的目录
DOMAIN_DIR="网站的目录"

#DOMAINS是需要认证的域名列表
DOMAINS="DNS:dev.wxlets_zdself.greencampus.me,DNS:dev.wecahtlet.greencampus.me"

#ECC=TRUE
#LIGHTTPD=TRUE
```

**运行**

```
./letsencrypt.sh letsencrypt.conf
```

**注意**

需要已经绑定域名到"DOMAIN_DIR"目录，即通过 http://dev.wxlets_zdself.greencampus.me 可以访问到"DOMAIN_DIR"目录，用于域名的验证

**将会生成如下几个文件**

```
lets-encrypt-x1-cross-signed.pem
example.chained.crt          # 即网上搜索教程里常见的 fullchain.pem
example.com.key              # 即网上搜索教程里常见的 privkey.pem 
example.crt
example.csr
```

**nginx中的配置**

```
ssl_certificate     /path/to/cert/example.chained.crt;
ssl_certificate_key /path/to/cert/example.com.key;
```

**cron 定时任务**
每两个月自动更新一次证书，可以在脚本最后加入 service nginx reload等重新加载服务。

```
0 0 2 * * /usr/local/nginx/ssl_cert/lets-encrypt/letsencrypt.sh /usr/local/nginx/ssl_cert/lets-encrypt/letsencrypt.conf >> /home/wwwlogs/lets-encrypt.log 2>&1

lnmp nginx restart
```

