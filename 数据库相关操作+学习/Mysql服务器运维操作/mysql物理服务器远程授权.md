## 一、为mysql数据库开账号、并授权

**语法：**

```
grant [权限1，权限2...] on 某库.某表 to 新用户名@'主机名/IP地址' identified by '密码';  

例子：

grant select,insert on 数据库.数据表 to 数据库用户@'%'  identified by '密码';

```

**1. 为mysql服务器添加一个用户和设置密码，并允许远程访问拥有所有权限**

```
GRANT ALL PRIVILEGES ON doorctrl_bjhq.* TO 'hjc_042043' @"%" IDENTIFIED BY 'hjc1985';

FLUSH PRIVILEGES;
```

**2. 指定将一个库授权给某个用户**

```
// 此用户已经在数据库中存在了的,所有后面就不用跟上'IDENTIFIED BY'，数据库密码已经存在了。

GRANT ALL PRIVILEGES ON doorctrl_bjhq.* TO ‘hjc_042043’@“%”;
FLUSH PRIVILEGES;
```

**3. 通过SQL语句来添加普通用户的和密码**

```
mysql> insert into mysql.user(Host,User,Password)
values("%","demodb",password("Q1@W2#E3$R4"));

FLUSH PRIVILEGES;
```

## 二、更新数据库密码

**5.7之前的版本**

```
UPDATE user SET password=PASSWORD('123456') WHERE user='root';
FLUSH PRIVILEGES;
```

**5.7之后的版本**

```
UPDATE user SET authentication_string=PASSWORD('123456') WHERE user='root';
FLUSH PRIVILEGES;
```

