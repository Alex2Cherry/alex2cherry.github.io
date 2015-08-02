---
layout: post
title: "在Ubuntu 14.04上搭建github pages博客"
date: 2015-08-02 11:26:22 +0800
comments: true
categories: 搭建环境
---
## 1. 背景 ##

> github是一个全球性的代码托管平台，支持github Pages服务。这个服务可以为个人、组织或项目建立静态主页。github为用户提供项目托管、git、pages等用于项目开发的功能。我们使用的就是其pages服务。相对于其他提供免费博客的网站，github的最大优点是无任何广告且提供git版本管理工具对博客进行管理。但劣势是需要一定的命令行操作，对于普通用户有一定门槛。也因此，octopress+github被成为最适合hack的建博方式。

> Octopress是一款优秀的静态化博客系统，官方将它简称为：“A blogging framework for hackers.”，也就是Octopress只适合那些经常玩Linux、写代码的朋友用的博客系统。

    本地环境：Ubuntu 14.04。

----------

## 2. 部署Octopress博客系统 ##

* 1) 安装ruby。Octopress是基于jekyll的，而jekyll是用ruby开发的，ubuntu14.04 LTS上默认是没有安装ruby环境的，需要自己安装。
     命令： `sudo apt-get install ruby ruby1.9.1-dev`

* 2) 安装bundler。Bundler使用Ruby语言写的，通过跟踪和安装运行Ruby项目所需要的确切的gem和版本,为Ruby项目提供了完整的可运行环境。安装bundler的目的是为了自动安装Octopress所依赖的软件包，它通过安装应用程序的Gemfile中的所有gem来做到这一点。
     由于GFW的原因，会出现无法链接gem源的情况，建议将gem源切换为taobao的源。操作命令如下：
     ``` 
     gem source -r https://rubygems.org/ #删除官方源
     gem source -a http://ruby.taobao.org/ #添加淘宝源
     gem install bundler
     ```

* 3) 安装Octopress。先从github上下载源码，源码中有Gemfile文件来指示所有依赖，使用bundle便可安装所有依赖了。操作命令如下：
     ```
     #下载源码
     git clone git://github.com/imathis/octopress.git octopress
     cd octopress
     #安装依赖
     bundle install
     ```

* 4) 安装octopress默认主题，使用octopress默认的主题作为博客的主题样式。
     命令：`rake install`
     在我的环境中，执行`rake install`后报错：
    ```
    var/lib/gems/1.9.1/gems/execjs-2.5.2/lib/execjs/runtimes.rb:48:in `autodetect': Could not find a JavaScript runtime. See https://github.com/rails/execjs for a list of available runtimes. (ExecJS::RuntimeUnavailable) 
    ```
     拿错误信息在网上搜了一下，说是缺少运行JavaScript的环境，尝试了多种方案，最终安装nodejs解决的。命令：`sudo apt-get install nodejs`

* 5) 配置octopress参数。包括配置Main config，设置博客的标题，描述等参数；默认的主题中，需要加载twitter和google的链接，由于GFW的原因，会造成页面load很慢，为提升博客的访问速度，可以关闭twitter的链接，将google的CSS和字体换成国内的链接（360提供的useso.com）。
     Main config参数位于octopress根目录下的_config.yml文件中，配置样例：
     ```
     url: http://alex2cherry.github.io
     title: Water Drop
     subtitle: 有才而性缓定属大才,有智而气和斯为大智.
     author: alexliu1354@gmail.com
     simple_search: https://www.google.com/search
     description: Alex Liu's personal blog.
     ```
     另外，将文件中twitter相关的配置删除。

     google字体和CSS涉及到的配置文件为：`source/_includes/head.html`，`source/_includes/custom/head.html`。具体做法是把`fonts.googleapis.com`替换为`fonts.useso.com`；将类似`ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js`替换为`ajax.useso.com/ajax/libs/jquery/1.7.2/jquery.min.js`。

* 6) 将博客部署到github
    - 在[www.github.com](www.github.com)注册一个帐号;
    - 新建一个仓库，名为`your_user_name.github.io`;
    - 在octopress根目录执行`rake setup_github_pages`。按照要求输入仓库地址等，这个命令会在跟目录下新建_deploy目录，这个会push到仓库的master分支，也就是访问博客的文件。
    - 生成博客并部署到github。命令如下：
      ```
      rake generate
      rake deploy
      ``` 

* 7) 将全部源码提交到github，便于在其它设备上也可以发布博客。前面提到的deploy只是部署博客代码到github上面，整个octopress并没有提交，为了保证在任何地方随时发布博客，而无需再次详细配置以保证跟github上的最新代码一致，可以将当前octopress的源码存放到github的source分支下：
     ```
     git add .
     git commit -m 'Initial source commit'
     git push origin source
     ```

----------

## 3. 发布博客 ##
   通过下面的步骤可以新建一篇博客，编写内容，发布到github pages上。

* 1) 新建一篇博文。命令：`rake new_post["title"]`,样例：
     ```
     rake new_post["Zombie Ninjas Attack: A survivor's retrospective"]
     # 这条命令会创建 source/_posts/2011-07-03-zombie-ninjas-attack-a-survivors-retrospective.markdown文件
     ```
     新建的文章被放在source/_posts目录下，并按照Jekyll的命名规则命名：YYYY-MM-DD-post-title.markdown。这个名字会被用于生成url且日期会被用于为文章按时间排序。文件内容如下：

     ```
     ---
     layout: post
     title: "Zombie Ninjas Attack: A survivor's retrospective"
     date: 2011-07-03 5:59
     comments: true
     external-url:
     categories:
     ---
     ```
     
   你可以在这里设置评论功能开关，设置分类。如果你的博客有多个作者共用，你可以在文件中添加【author:Your Name】。如果你在编辑一个草稿，你可以添加【published： false】以使其在生成博客内容时被自动忽略。
   直接编辑markdown文件，编写博客内容。

* 2) 本地生成 & 预览
    ```
    rake generate   # 在公开目录中生成博文和页面
    rake preview    # 在浏览器中输入 http://localhost:4000 即可预览。
    ```

* 3) 部署到github，同时上传源码
    ```
    git add .
    git commit -am "Some comment here." 
    git push origin source
    rake deploy
    ```

## 4. 参考链接 ##

 1. [Ubuntu上使用octopress+github建立个人博客](http://fzyz999.github.io/blog/2013/04/10/ubuntushang-shi-yong-octopressjian-li-bo-ke/)
 2. [利用octopress部署博客到github](http://ju.outofmemory.cn/entry/98762)
 3. [谷歌被墙导致WordPress网站变慢的解决办法](http://www.chinaz.com/web/2014/0610/354852.shtml)
 4. [Ubuntu14.04+Jekyll+Github Pages搭建静态博客](http://www.open-open.com/lib/view/open1433493880510.html)
 5. [如何搭建一个独立博客——简明Github Pages与Hexo教程](http://cnfeat.com/2014/05/10/2014-05-11-how-to-build-a-blog/)


