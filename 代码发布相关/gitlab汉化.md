## 1.下载和当前gitlab版本的汉化包
汉化包的版本号必须要和当前的gitlab的版本号一致。
![](http://p4sk87cgm.bkt.clouddn.com/15344924087523.jpg)

从上图中看出来，版本号是11.1.4，那么我们要找的汉化包是：
![](http://p4sk87cgm.bkt.clouddn.com/15344925186996.jpg)

```
git clone https://gitlab.com/xhang/gitlab.git -b v11.1.4-zh
```

下载后确认版本号

```
# 进到汉化包目录
cat VERSION
```

## 停止gitlab服务

```
gitlab-ctl stop
```

## 将汉化包拷贝到gitlab核心文件夹下

```
#删除汉化包下面的tmp和log
cd gitlab
rm -rf tmp
rm -rf log

#将汉化包覆盖掉
\cp -r gitlab/* /opt/gitlab/embedded/service/gitlab-rails/
```

## 启动gitlab，重新配置gitlab

```
gitlab-ctl start

gitlab-ctl reconfigure
```

