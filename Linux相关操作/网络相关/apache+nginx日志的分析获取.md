> 如何从apache、nginx请求日志中拉取1分钟的日志内容

## 提取后的日志存储位置

```
/mnt/abnormalLogs
```

## 提取操作

```
# 进入web服务的日志路径
cd /mnt/lost+found/httpd_log

# 提取操作,根据日志内容的结构，提取出某个时间点的日志，这里暂定是20181030 11:00的日志
cat access_log2018_10_30.log | grep "2018:11:00" > /mnt/abnormalLogs/1030_1100.log
```


