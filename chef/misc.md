## 查看chef server 版本
head -n1 /opt/opscode/version-manifest.txt

## databag 转换为json文件
```ruby
data_bag_item('servers', 'backup')['host'].to_json
file "/etc/script.json" do
  owner "root"
  group "root"
  mode 0644
  content node[:whatever].to_json
 end
```

## 远程调用chef-client
knife ssh name:$fqdn 'echo {\"attributes\":{\"user\":\"iamapassword\"}} |chef-client -j /dev/stdin -o 

## 运行本地cookbook
chef-client -z -o $cookbook

## metadata.rb 中的操作系统支持信息
```ruby
%w(debian ubuntu redhat centos fedora scientific amazon oracle).each
   do |os|
     supports os
   end
```

