# collectd

## 简介  
collectd是一个守护(daemon)进程，用来定期收集系统和应用程序的性能指标，同时提供了以不同的方式来存储这些指标值的机制。
collectd从各种来源收集指标，例如 操作系统，应用程序，日志文件和外部设备，并存储此信息或通过网络使其可用。 这些统计数据可用于监控系统、查找性能瓶颈（即性能分析）并预测未来的系统负载（即容量规划）等。

## 基本配置  
配置文件默认位于/opt/collectd/etc/collectd.conf，具体的文件路径可以通过手动安装时设置--prefix选项来指定，那么路径将是<prefix>/etc/collectd.conf。collectd拥有大量插件，每项插件具体的配置可以参考官方[man page][collectd-conf-man]

## 启动  
* `sudo /etc/init.d/collectd start`
* `systemctl start collectd`
* 设置开机启动systemctl enable collectd

## 控制工具collectedctl  
collectdctl为collectd提供了一个控制接口，能够和"unixsock plugin"插件通信交互。更多信息可以参考[官方文档][collectdctl-man-page]，下面仅介绍常用功能。
安装：
```
add-apt-repository universe
apt-get update
apt-get install collectd-utils
```
or `wget http://launchpadlibrarian.net/251829575/collectd-utils_5.5.1-1build2_amd64.deb`
其支持的选项有：  
  * -s socket，由插件"unixsock plugin"打开的UNIX socket路径，默认为 /var/run/collectd-unixsock
  * -h  打印使用帮助并退出  

可用命令：  
  * getval <identifier>
    查询collectd里给定<identifier>的最新值.返回的数据集是一个k-v对的列表
  * flush [timeout=<seconds>] [plugin=<name>] [identifier=<id>]
    flush deamon中的数据，保证最新的数据都写入collectd而不是在缓存中。flush命令支持以下选项：
      * timeout=<seconds>，将比timeout更老的数据写入磁盘。
      * plugin=<name>，将指定插件的缓存数据写入磁盘。需要插件支持此功能
      * identifier=<id>，将指定id的数据写入磁盘，注意并不是所有插件都支持，例如"network"插件
    *plugin*和*identifier*选项可以被指定多次，这种情况下所有满足组合条件的都会被写入磁盘
  * listval, 返回所有能从"unixsock"插件得到的identifier数据
  * putval <identifier> [interval=<seconds>] <value-list(s)>
    将根据identifier将一个或多个数据提交给collectd守护进程

标识符：
  格式为[hostname/]plugin[-plugin_instance]/type[-type_instance]
  例如：
    somehost/cpu-0/cpu-idle
    uptime/uptime
    otherhost/memory/memory-used

示例：  
  * `collectdctl flush plugin=rrdtool identifier=somehost/cpu-0/cpu-wait`  
    将所有第一个localhost cpu的CPU等待RRD值写入磁盘。
  * "for ident in `collectdctl listval | grep users/users`; do collectdctl getval $ident done"  
    查询所有对本地collectd收集已记录的users最新数据。

## 常用插件

* [collectd-unixsock plugin](https://collectd.org/documentation/manpages/collectd-unixsock.5.shtml)  
* [syslog](https://collectd.org/wiki/index.php/Plugin:LogFile)  
    配置文件： /etc/rsyslog.conf
* [collectd corefile](https://collectd.org/wiki/index.php/Core_file)  

[collectd-conf-man]: https://collectd.org/documentation/manpages/collectd.conf.5.shtml
[collectdctl-man-page]: http://manpages.ubuntu.com/manpages/xenial/man1/collectdctl.1.html
