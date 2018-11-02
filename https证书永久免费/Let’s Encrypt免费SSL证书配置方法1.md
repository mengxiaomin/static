> 采用certbot方式来安装

[toc]

# 1.下载安装certbot
```
cd /usr/local/src

wget https://dl.eff.org/certbot-auto --no-check-certificate

chmod a+x certbot-auto

./certbot-auto -n  #安装一些依赖库
```

# 2.生成域名证书

**单域名**

```
格式：
./certbot-auto certonly --email [邮箱] --agree-tos --no-eff-email --webroot -w [网站项目的目录] -d [域名]

例子：
./certbot-auto certonly --email hjc@golive.cc --agree-tos --no-eff-email --webroot -w /home/wwwroot/zd_self_shop -d devwxletszdselfshop.greencampus.me
```

**多域名**

```
格式：
./certbot-auto centonly --email [邮箱] --agree-tos --no-eff-email --webroot -w [网站项目的目录1] -d [域名1] -d [域名2] ... -d [域名N] -w [网站项目的目录2] -d [域名3] -d [域名4]

例子：
./certbot-auto centonly --email hjc@golive.cc --agree-tos --no-eff-email --webroot -w /home/wwwroot/test1 -d www.certdev.com -d certdev.com -w /home/wwwroot/test2 -d www.letsencrypt.test -d letsencrypt.test
```
证书生成后会存在 `/etc/letsencrypt/live/[域名]`
![](http://p4sk87cgm.bkt.clouddn.com/15300858311058.jpg)

# 3.nginx证书配置

```
server {
    listen 443;
    ssl on;
    
    server_name testwxletszdselfshop.greencampus.me;
    index  index.htm index.html index.php;
    root /home/wwwroot/zd_self_shop;
    
    ssl_certificate /etc/letsencrypt/live/testwxletszdselfshop.greencampus.me/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/testwxletszdselfshop.greencampus.me/privkey.pem;
    ssl_trusted_certificate /etc/letsencrypt/live/testwxletszdselfshop.greencampus.me/chain.pem;
	ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;   #加密方式
	ssl_protocols TLSv1 TLSv1.1 TLSv1.2;   #指定密码为openssl支持的格式
ssl_prefer_server_ciphers on;  #依赖SSLv3和TLSv1协议的服务器密码将优先于客户端密码

    location /
    {
      if (!-e $request_filename){
        rewrite ^/index.php/(.*)$ /index.php?s=$1 last;
        rewrite ^/(.*)$ /index.php?s=$1 last;
      }
    }
    
    location ~ .*\.(php|php5)?$
    {
        set $script    $uri;
        set $path_info  "/";
        if ($uri ~ "^(.+\.php)(/.+)") {
            set $script     $1;
            set $path_info  $2;
        }
    
        try_files $uri =404;
        fastcgi_pass  unix:/tmp/php-cgi.sock;
        fastcgi_index  index.php?IF_REWRITE=1;
    
        include fastcgi.conf;
    }
    
    location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$
    {
            expires      30d;
    }
    
    location ~ .*\.(js|css)?$
    {
            expires      12h;
    }
    access_log  /home/wwwlogs/zd_self_shop.log;
}
```

# 4.通过计划任务更新证书信息
```

#每周三晚上2点执行生成新的letsencrypt
0 2 * * 3 bash /shellcode/autocreate_ssl.sh

```

autocreate_ssl.sh脚本代码

```
#!/bin/bash

/usr/local/src/certbot-auto renew --disable-hook-validation --renew-hook "lnmp nginx reload" >> /mnt/data/certbot-auto.log 2>&1
```

