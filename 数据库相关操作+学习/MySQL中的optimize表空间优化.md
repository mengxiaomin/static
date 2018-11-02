## 为什么要用optimize
当对表有大量的增删查改的时候，需要用optimize对表进行优化。可以减少空间与提高磁盘I/O性能。

## 使用注意
innodb引擎如果要使用optimize,那么数据库必须要开启innodb_file_per_table,表示数据库采用独立表空间

```
mysql > show variables like '%innodb_file_per_table%';
```
![](http://p4sk87cgm.bkt.clouddn.com/15324245743315.jpg)




