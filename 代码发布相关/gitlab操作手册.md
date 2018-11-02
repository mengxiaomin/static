# gitlab操作手册
[toc]

## git操作篇

### 1. 项目克隆
```
git clone git@gitlab.test.cn:pro/greencampus.git
```

### 2. 项目的提交
```
1. git add .    //添加所有文件，“.”表示所有的
2. git commit -m '所有的修改提交'  //提交时必须带上注释
```

> **注：如果要查看文件的状态可以用git status命令：**
![](http://p4sk87cgm.bkt.clouddn.com/15216082905288.jpg)
如上图所示，文件已经修改了。
 
### 3. 项目的推送
```
git push origin feature/test01
```
> **注：如果要查看远程的项目源地址可以如下命令：**
> **git remote -v**

### 4. 分支和gitflow流

- **master分支**

master分支是最终版本的分支，是正式发布使用的，是受保护的分支，在master分支上不能随意修改

-------

-  **develop分支**

develop分支从master分支拉取出来，作为功能分支的集成分支，这样也方便master分支上的所有提交分配一个版本号；如图所示：

![develop](http://p4sk87cgm.bkt.clouddn.com/develop.png)

```
1.如果在远程服务器上没有develop这个分支，那么在本地新建一个并上传
git branch develop
git push -u origin develop

2.如果远程已经存在，那么在本地直接远程check下来即可
git checkout -b develop origin/develop

3.如果功能分支需要合并进来
git pull origin //在合并进来之前最好先拉取一下，以免有冲突
git merge feature/feature-lisi
```
-------

-  **feature分支**

feature分支也叫功能分支，就是对一个项目组按人员划分来建立分支比如张三，就是feature/feature-zhangsan,李四，就是feature/feature-lisi。功能分支不是从master中去fork分支(切记)，而是将develop分支作为父分支。当功能开发完成后合并回develop分支。
这样子做的目的是每个人开发都相对独立，相互不受影响。其结构图所示：
![feature](http://p4sk87cgm.bkt.clouddn.com/feature.png)

```
如果是新的feature分支，在远程不存在的，那么从develop中创建出功能分支
git checkout -b feature/feature-lisi develop

将本地的feature分支提交到远程服务器上
git push origin feature/feature-lisi

如果远程featrue分支已经存在
git checkout -b feature/lisi origin feature/lisi


```
-------

- **release分支**

到了发布的时候，专门为发布准备了一个分支就是release分支，它从develop中fork出来，这么做的目的是一个团队可以在完善当前的发布版本的同时，另一个团队可以继续开发下一个版本。
并且这个版本只做上线前的bug修复用(即测试测出来的bug修改)，不能新增功能，一旦合并到master分支后，也同时要将所做的修改合并到develop分支中去。其结构图所示：
![release](http://p4sk87cgm.bkt.clouddn.com/release.png)

```
1. 从develop中fork一个分支
git checkout -b release-0.1 develop

2. 发布时的操作
git checkout master
git merge release-0.1
git push

3. 一定要合并回develop
git checkout develop
git merge release-0.1
git push

4. 删除发布分支
git branch -d release-0.1
```
-------

- **hotfix分支**

hotfix分支也叫维护分支或者热修复分支，用于快速给生产线上的产品打补丁用(比如客户在生产线上发现了紧急bug需要马上修复)，这是唯一从master分支中去fork出来的分支，修复完成后，将修改的要合并到develop分支，master分支应该用新的版本号打好tag。

这样做的目的是，让团队快速解决掉问题，而不用打断其他工作或等待下一个发布。可以理解成在master分支上处理的临时发布。结构图如图所示：
![hotfix](http://p4sk87cgm.bkt.clouddn.com/hotfix.png)

```
1. 从master中fork出一个分支
git checkout -b hotfix-001 master

2. 修改完bug，进行合并提交
git checkout master
git merge hotfix-001
git push

3. 切换到develop分支进行合并提交
git checkout develop
git merge hotfix-001
git push 

4. 删除热修复分支
git branch -d hotfix-001
```
> **注：在切换到某个分支的时候，必须需要对这个分支做一个拉取，以免出现冲突**

```
git pull origin [分支名]
```

### 5. 项目还原到历史版本

如果我们开发时候，发现错了想还原到具体某一个版本，git也很方便。

**工作区文件的还原**
如果还没有commit到版本库，发现改错了或者误删除了，那么就操作
    
```
git checkout -- <文件名>
```
    
将会回到文件最后一次 commit 或者 add 时候的状态。
    
**暂存区文件还原**
如果文件已经add到暂存区中区了，如何撤销

```
git reset HEAD <file>
```


**版本库文件的还原** 

**1. 先通过查找日志查找版本号**

```
git log [文件名]
```
![](http://p4sk87cgm.bkt.clouddn.com/15216088757735.jpg)
    每次，修改提交都有一个记录编号
![](http://p4sk87cgm.bkt.clouddn.com/15216089149821.jpg)

**2. 还原到某个版本**

可以从日志中找到某个日志编号进行还原,比我我要还原成2月份的一个版本

```
git reset --hard e957e52aa922b7b95b4d6bc85159fa41d466acd3
```
> **注：如果还原到上一个版本或者上上个版本**

```
git reset --hard HEAD^   //还原到上一个版本
git reset --hard HEAD^^  //还原到上上个版本
```

**从远程的tag中还原**

git checkout -B [本地分支名] [tag的版本号]
例如：

```
git checkout -B develop v1.0.1
```

### 5.合并之rebase和merge
**rebase:**

```
git checkout develop
git rebase -i [分支A]
```

rebase操作时，是从两个分支共同的commit节点开始，将当前的分支develop的commit都提取出来，追加到分支A上，有冲突就解决冲突，合并完成后会将develop原来提交的commit记录号删除掉，在最后重新生成新的commit记录号。

所以rebase不会产生多个commit，可以节省资源。
但同时比较坑的是，如果多次commit有冲突，需要解决多次冲突

**merge:**

```
git checkout develop
git merge [分支A]
```
merge操作时，两个分支共同的节点号，以及他们最新提交的节点，一起合并生成一个最新的节点。冲突只要解决一次就行，但同时也会产生多个commit。从公司多人协作项目考虑，建议用merge。


**总结**
我们在使用合并代码时，默认是使用fast-forword模式，这种模式不会保存commit记录，在合并和删除分支时会将分支信息删除掉。

```
git rebase --onto develop

提示：
First, rewinding head to replay your work on top of it...
Fast-forwarded master to develop.
```

```
git merge develop

提示：
Updating 5a8b732..85a33e2
Fast-forward
 2.txt | 1 -
 1 file changed, 1 deletion(-)
```

在使用git pull时其实是拉取远程文件 和 合并的一个组合

```
git pull = git fetch + git merge

git pull -r = git fetch + git rebase
```

### 6.冲突解决
比如有文件2.txt初始内容如下：

```
develop分支添加2.txt文件

develop分支合并了内容

3333333

111111
```

现在有两个分支masert，develop都不小心修改了同样的内容：

**develop:**

```
develop分支添加2.txt文件

develop分支合并了内容

develop分支修改了内容.
```
**master:**

```
develop分支添加2.txt文件.

develop分支合并了内容.

master分支修改了内容.
```

这个时候，在master分支下，将develop合并进去：

```
git checkout master
git merge develop

提示：
Auto-merging 2.txt
CONFLICT (content): Merge conflict in 2.txt
Automatic merge failed; fix conflicts and then commit the result.

```
提示在合并2.txt文件时发生冲突如图所示：
![](http://p4sk87cgm.bkt.clouddn.com/15240648391846.jpg)
<<<<< HEAD 和 ===== 之间的表示当前分支下所修改的内容，
======= 和 >>>>> develop之间的表示develop分支的内容。

接下来就来解决冲突,选择其中一行的内容，也可以两行都保留，很简单只需要<<<<< HEAD,======,>>>>>>> develop去掉，然后再提交

```
develop分支添加2.txt文件.

develop分支合并了内容.

develop分支修改了内容.
```

```
git add 2.txt
git commit -m "2.txt冲突解决"

提示：
[master 5a8b732] 2.txt冲突解决
```

## gitlab操作篇
> gitlab master分支第一次push代码的时候只有主程序员才能推送，其他角色推送不了会报错 

### 1.gitlab项目新建
* 1.1 进项目首页
![](http://p4sk87cgm.bkt.clouddn.com/15216127216906.jpg)

创建空白项目（比较常用）
![](http://p4sk87cgm.bkt.clouddn.com/15216129862932.jpg)

* 1.2 通过模板来进行创建（选择了模板之后，会自动生成框架，直接使用就行）
![](http://p4sk87cgm.bkt.clouddn.com/15216133225232.jpg)

* 1.3 还可以通过从其他git源导入进来
![](http://p4sk87cgm.bkt.clouddn.com/15216136686081.jpg)

### 2.sshkey设置
* 2.1 在本机生成sshkey
下面以mac下面为例进行演示，windows平台下的网上自己搜索。

```
1. 进入.ssh目录
cd ~/.ssh

2. 生成SSH密钥
ssh-keygen -t rsa -C "你的个人邮箱"
接下来直接回车下去，不用输入passphrase内容，不然每次操作都要输入passphrase

3. 获取SSH公钥信息
这时在.ssh目录下会生成两个文件，私钥id_rsa和公钥id_rsa.pub两个密钥文件。
```

* 2.2 在gitlab平台添加sshkey

可以将id_rsa.pub文件内容复制出来，然后黏贴到gitlab平台
![](http://p4sk87cgm.bkt.clouddn.com/15216151200073.jpg)
![](http://p4sk87cgm.bkt.clouddn.com/15216152864364.jpg)

添加成功之后看如图所示：
![](http://p4sk87cgm.bkt.clouddn.com/15216153694327.jpg)

* 2.3 如果有多个git源仓库，怎么办?

如果有多个git源库，比如既有gitlab，又有github版本库的时候，那么SSHkey需要做区分,需要在~/.ssh目录中添加一个config文件，文件内容如下：

```
# gitlab
Host 120.27.222.2
HostName 120.27.222.2
User allen.huang
IdentityFile ~/.ssh/id_rsa

# github
Host github.com
HostName github.com
User hjc1985
IdentityFile ~/.ssh/id_rsa_github

# golivecc
Host 120.26.106.212
HostName 120.26.106.212
User hjc
IdentityFile ~/.ssh/id_rsa_golivecc

# 对Host进行测试：
$ ssh -T git@120.26.106.212
Welcome to GitLab, 黄锦潮!     #如果输出如下结果表示成功

```

参考：
https://segmentfault.com/a/1190000002994742
http://blog.csdn.net/baidu_35738377/article/details/54580156

### 3.代码上传

> Git用户名和邮箱的配置
> 注：如果有多个git源,不能用 git config --global
> 
```
git config --global user.name "你注册的用户名"
git config --global user.email "你注册的邮箱"
```

- 创建新版本库

```
git clone git@120.26.106.212:qglschool/gc_demo.git

# 考虑到本地还有其他的git源仓库像github,coding等
git config user.name "你注册的用户名"
git config user.email "你注册的邮箱"

# 添加文件并提交到版本库
cd gc_demo
touch README.md
git add README.md
git commit -m "add README"

# 将代码发布到版本库
git push -u origin master
```

设置gitignore
> 在.gitignore文件中例如可以把缓存，日志类的文件忽略掉把.DS_Store (mac下有，windows下没有)，thumbs.db, data/logs, data/caches等，在项目发布前先建立好
![](http://p4sk87cgm.bkt.clouddn.com/15216260466498.jpg)


- 如果已存在的文件夹

```
cd existing_folder
git init    # 初始化git源码库

# 考虑到本地还有其他的git源仓库像github,coding等
git config user.name "你注册的用户名"
git config user.email "你注册的邮箱"

# 绑定远程源码库
git remote add origin git@120.26.106.212:qglschool/gc_demo.git

# 提交到版本库
git add .
git commit -m "Initial commit"

# 推送项目到远程
git push -u origin master
```

- 如果已存在的 Git 版本库

```
cd existing_repo

# 考虑到本地还有其他的git源仓库像github,coding等
git config user.name "你注册的用户名"
git config user.email "你注册的邮箱"

# 将旧的远程库重命名成新的远程库名
git remote rename origin old-origin

# 添加远程库
git remote add origin git@120.26.106.212:qglschool/gc_demo.git

# 推送所有代码
git push -u origin --all

#推送所有的标签
git push -u origin --tags
```

## gitlab分支管理规范

> 目前，为了提高开发效率，我们重新对项目分支来做一个流程:

### 1. develop上开发
以后的开发都用develop上进行开发，推送之后利用钩子自动合并到测试服务器上去。所有个人分支都提交合并到develop上去，合并完成并关闭。
![](http://p4sk87cgm.bkt.clouddn.com/15238632458217.jpg)

在线上合并完成后，在本地的其他分支都删除掉，包括master

* 切换到develop，并pull最新代码
切记一定要先从远程pull下来，以免有冲突
![](http://p4sk87cgm.bkt.clouddn.com/15238637549947.jpg)


* 删除本地的个人分支
![](http://p4sk87cgm.bkt.clouddn.com/15238636145014.jpg)

### 2. 在release分支进行测试
* 在进入测试阶段之后，就需要在develop上拉取一个release分支，所有测试的bug都在release分支上进行测试。

* 这样子做的好处是，develop分支可以继续开发，在release分支上进行修改bug。

* bug修复完成后将release分支合并到master分支和develop分支。并将release分支删除。

### 3. 预发布环境做为真实的测试

* 预发布环境和线上环境一样，来源于master分支。数据库也是用线上数据库，在预发布环境做了测试之后，通过没问题再推送到生产环境。

### 4. 真实环境遇到bug
* 从master分支上拉一个热修复分支，hotfix分支，修改完bug，合并到master分支和develop分支，并将代码先推送回预发布环境进行测试通过了，再推送到真实环境。


