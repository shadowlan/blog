#chef-solo&chef-client --local-mode的使用
##chef-solo
chef-solo命令以不需要chef server的方式执行chef-client，chef-solo使用chef-client的本地模式，在chef官方文档上提示chef-client的本地模式在11.8版本中开始加入，如果是运行chef-client 11.8或者更新版本，应该考虑使用chef-client的本地模式而不是chef-solo。这里简单介绍chef-solo的使用，具体可以参考[官方链接][chef-solo].

chef-solo支持两种方式的cookbook路径：

* 本地文件夹
* *.tar.gz压缩文件的URL

*.tar.gz压缩文件的方式更常见，但需要将所有依赖的cookbooks都加入到压缩包中,例如`$tar zcvf chef-solo.tar.gz ./cookbooks ./site-cookbooks`
参考命令行：
```
$chef-solo -c ~/solo.rb -j ~/node.json -r http://www.example.com/chef-solo.tar.gz
#The tar.gz is archived into the file_cache_path, and then extracted to cookbooks_path.
```

###solo.rb

solo.rb文件用来设置chef-solo的具体配置信息。默认路径为/etc/chef/solo.rb，如果需要覆盖可以使用--config命令行参数来改变。常用参数示例如下：
```
cookbook_path [
               '/var/chef/cookbooks',
               '/var/chef/site-cookbooks'
              ]
data_bag_path '/var/chef/data_bags'
log_level :info
node_name 'mynode.example.com'
recipe_url 'http://path/to/remote/cookbook'
```

更多配置信息请参考[这里][solo.rb]

##chef-client --local-mode
本地模式是chef-client根据本地chef-repo运行，就像是以chef server方式运行一样。本地模式依赖于chef-zero，一个轻量版的chefserver，chef-zero读和写都发生在`chef_repo_path`. 本地模式不需要配置文件，它会找一个名为/cookbooks的文件夹，并将其父目录设置为`chef_repo_path`.如果client.rb没有被找到且没有指定配置文件，本地模式将会搜索knife.rb文件。

根据chef-client -z的输出“WARN: No cookbooks directory found at or above current directory.  Assuming /root.”，默认应该会在当前或者父目录查找是否存在cookbooks文件夹，如果没有，则将当前目录作为cookbooks目录来查找目标cookbook。

根据官方文档介绍，本地模式默认会在`chef_repo_path/.cache`存放临时和缓存文件。这使得一个普通用户也可以在没有root权限的情况下执行chef-client本地模式。不过我在尝试运行本地模式时，并没有在`chef_repo_path`路径下找到.cache文件夹，倒是看到一个名为`nodes`的文件夹，存放了名为${host_fqdn}.json的文件，里面存放的是当前执行chef-client的节点信息。猜测.cache是在需要下载外部cookbook或者其他文件依赖时产生。

参考示例命令行：
```
chef-client -z -j /root/sample.json -c /root/client.rb
```
更多chef-client命令请参考[官方文档][chef-client]

##Troubleshooting
>“FATAL: Cannot load configuration” 

当执行chef-client -z -j ../sample.json时出现无法加载配置文件的错误，原因是-j参数后的配置文件需要是绝对路径，而不是相对路径。解决方法是提供sample.json文件的全路径例如`chef-client -z -j /root/sample.json`


##参考链接
* [Migrate chef-solo to chef-client local mode][chef-solo-migrate-to-chef-client]

[chef-solo-migrate-to-chef-client]: https://blog.chef.io/2014/06/24/from-solo-to-zero-migrating-to-chef-client-local-mode/
[chef-solo]: https://docs.chef.io/chef_solo.html
[solo.rb]: https://docs.chef.io/config_rb_solo.html
[chef-client]: https://docs.chef.io/ctl_chef_client.html#run-in-local-mode
