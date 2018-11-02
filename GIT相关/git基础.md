[TOC]

> ssh协议：git@120.27.222.2:smc/test.git
> 
> http协议：http://120.27.222.2:8000/smc/test.git
> 
> Gitlab两种连接方式:ssh和http对比
> 
> 简单对比：
> 
> 相同点：
> 
> - 都可拉代码、推代码
> 
> 不同点：
> 
> - http协议需要进行账号密码验证，ssh协议需要生成密钥并添加至gitlab平台
> - ssh相对拉取代码速度快


## 日常开发
### 第一步：
克隆代码到本地

命令： git clone {Git地址} [克隆至目标目录]

示例： git clone git@120.27.222.2:smc/test.git

### 第二步：
> 编写代码

第一阶段功能编写完毕(提交版本)：

命令：

```
git status (查看状态)
git add .|**.php **.css **.js (添加至等待区)(使用 点 表示把所有修改的文件都添加至等待区)
git commit -m “注释是必须的,描述此版本做了什么事情” (把等待区的文件生成一个版本)

```

示例：

```
git status
git add .
git commit -m “首页展示完成”
```

第二阶段功能编写完毕(提交版本)：

命令：

```
git status (查看状态)
git add .|**.php **.css **.js (添加至等待区)(使用 点 表示把所有修改的文件都添加至等待区)
git commit -m “注释是必须的,描述此版本做了什么事情” (把等待区的文件生成一个版本)
```


示例：

```
git status
git add .
git commit -m “内容页展示完成”
```
......

### 第三步：
提交代码（先拉后提交）

命令： 

```
git pull [origin develop] (拉代码)
git push [origin develop] (推代码)
```

示例： 

```
git pull origin develop
git push origin develop
```

## 附录：
### 附录一：安装
下载地址： https://git-scm.com/downloads

Windows ： 下载.exe文件，双击之后next到底即可

Linux：

```
yum intall git | apt-get install git
```

### 附录二：生成ssh密钥

git命令：ssh-keygen

随后三个回车

Windows保存目录： C:\Users\Administrator\\.ssh

Linux保存目录： ~/.ssh (注意生成的哪个用户的密钥)

公钥文件： id_rsa.pub (public)

私钥文件： id_rsa

### 附录三：本地测试分支

> Tips：测试只需切换至测试分支随后合并一下最新的develop代码即可开始测试，测试完毕后切换分支回develop，保证develop分支不受测试代码干扰。

#### 第一步：
切换分支
命令：

```
git checkout [-b] 分支名称 (如果分支已经存在不必带参数-b 如果分支不存在需要带上-b会自动创建分支)
```

示例：

```
git checkout [-b] test
```


#### 第二步：
编写仅需本地调试的代码
编写完成提交版本：
命令： 
```
git status (查看状态)
git add .|**.php **.css **.js (添加至等待区)(使用 点 表示把所有修改的文件都添加至等待区)
git commit -m “注释是必须的,描述此版本做了什么事情” (把等待区的文件生成一个版本)
```


#### 第三步：
合并develop分支 | 拉远程develop 分支

命令：

```
git merge develop | git pull origin develop
```

示例：

```
git merge develop | git pull origin develop
```


#### 第四步：
测试本地代码或者切换分支至develop 继续开发

切换分支

命令：

```
git checkout develop
```

示例：

```
git checkout develop
```


### 附录四：冲突解决
冲突出现情况：使用git merge 合并分支时 或 git pull 拉取远程分支代码合并时
#### 第一步：
使用git status 查看目前冲突文件有哪些

命令：

```
git status
```

示例：

```
git status
```

![image](http://img.greencampus.cc/zd_self_shop/%E5%9B%BE%E7%89%871.png)


#### 第二步：
修改冲突文件

![image](http://img.greencampus.cc/zd_self_shop/%E5%9B%BE%E7%89%872.png)


跟发送冲突的修改内容的负责人商定后进行代码修改并保存如下


![image](http://img.greencampus.cc/zd_self_shop/%E5%9B%BE%E7%89%873.png)

#### 第三步：
提交解决冲突版本：
命令： 

```
git status (查看状态)
git add .|**.php **.css **.js (添加至等待区)(使用 点 表示把所有修改的文件都添加至等待区)
git commit -m “注释是必须的,描述此版本做了什么事情” (把等待区的文件生成一个版本)
```

示例： 

```
git status
git add .
git commit -m “与***冲突解决”
```





### GIT相关命令附录

```
git branch -a 查看所有分支
git log 查看commit的日志（版本库）
git checkout -- [文件名] 撤销修改
```

相关网站：https://blog.csdn.net/halaoda/article/details/78661334


