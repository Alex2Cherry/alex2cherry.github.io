---
layout: post
title: "记录一些使用git过程的问题"
date: 2015-08-08 18:30:55 +0800
comments: true
categories: git
---

### 1. 配置了github的sshkey，git push提交代码到远程库的时候，仍然提示输入用户名口令，为何？  
> 将 HTTPS 协议的 remote 地址，改成 SSH(git@github.com:name/code.git) 的就行了。
版本库的SSH方式和HTTPS方式是不同的，表面上是url信息的不同，但是，实际的认证机制也是不同的。当建立了本机密钥之后，使用ssh方式实际上是不需要再次认证的，而https则每次需要输入密码。  

<!--more-->

**解决办法**  
编辑项目目录下的`.git/config`文件，找到:

```
[remote "origin"]  
    url =https://github.com/hit9/hit9.github.com.git  
    fetch = +refs/heads/*:refs/remotes/origin/*  
```

把url处改成ssh地址:

```
[remote "origin"]  
    url =git@github.com:hit9/hit9.github.com.git  
    fetch = +refs/heads/*:refs/remotes/origin/*  
```

### 2. 不小心将一个目录下所以文件都用git add添加到本地git库中了，需要删除，如何操作？  

**解决办法**
直接将该目标的本地仓库文件(.git目录)删除：  

```bash
rm -rf .git
```
