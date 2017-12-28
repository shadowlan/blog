# 介绍

本文主要介绍在Mac OS系统上如何安装和使用Go的基础内容  
其他系统安装可以参考[官方文档](https://go-zh.org/doc/install)  

## 安装Go环境
Max OS安装Go工具集只需要下载pkg包然后双击执行即可  
[go1.9.2.darwin-amd64](https://golang.org/doc/install?download=go1.9.2.darwin-amd64.pkg)
其他版本下载地址[Download](https://golang.org/dl/)

## Go指南
Go官方中文指南可以直接访问[Go指南](https://tour.go-zh.org/welcome/1)  
如果想本地访问Go指南，可以用go get命令安装
```
go get github.com/Go-zh/tour/gotour
```

然后运行
```
cd $GOPATH/bin
./gotour
```

## Go常用环境变量
* $GOROOT
  GOROOT是go的安装路径,MacOS和Linux上默认的安装路径为"/usr/local/go". 用户可以在~/.bash_profile中添加如下内容，为系统指定默认的GOROOT后执行`source ~/.bash_profile`.
  ```
  GOROOT=/usr/local/go
  export GOROOT
  export $PATH:$GOROOT/bin
  ```

* $GOPATH
  GOPATH是作为编译后二进制的存放目的地和import包时的搜索路径,一般指向你的Worksapce工作目录,如果GOPATH没有设置，Unix系统默认会是$HOME/go,windows系统默认是%USERPROFILE%\go. 通过运行`go help gopath`可以获得更多细节。 
  go install/go get和go的工具等会用到GOPATH环境变量.  
  可以在~/.bash_profile中添加如下语句后执行`source ~/.bash_profile`
  ```
  GOPATH=/Users/username/gopath
  ```

* $GOBIN
  执行`go install`的时候，安装命令的目标目录。编译后的执行文件会移到GOBIN定义的目录。注意GOBIN必须是绝对路径。 

* 其他
  其他常用变量可以通过`go env`获得变量列表和值,也可参考官方文档介绍的[环境变量](https://golang.org/cmd/go/#hdr-Environment_variables)

## 常用Go命令
* `go build [-o output] [-i] [build flags] [packages]`  
编译包和依赖，但是不安装编译结果。

* `go install [build flags] [packages]`
安装编译的包和依赖，具体可参考`go help install`

* 更多命令参考[官方文档](https://golang.org/cmd/go/)

## 配置Sublime Text 3开发Go
安装sublime-build以编译Go项目，下面介绍安装步骤和简单使用，细节可以参考官方[sublime-build github](https://github.com/golang/sublime-build)
* 安装步骤
  * 打开Sublime Text 3,快捷键方式Shift+Command+P打开Package Control面板
  * 输入并选择Package Control: Install Package
  * 输入并选择要安装的"Golang Build"以执行安装

* 简单使用
  * 快捷键Shift+Command+B调出选择面板，选择需要执行的命令例如"Go - Run"/"Go - Install"等

## 学习资源
[Go入门指南](https://github.com/Unknwon/the-way-to-go_ZH_CN/blob/master/eBook/directory.md)

