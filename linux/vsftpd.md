# Centos7 上配置FTP

* 确认vsftpd是否已安装
```
rpm -qa vsftpd*
```

* 配置vsftpd为启动时服务 
```
chkconfig vsftpd on
```

* 允许root用户登陆
  * 检查/etc/vsftpd/vsftpd.conf配置 
  ```
  local_enable=YES  
  pam_service_name=vsftpd
  userlist_enable=YES
  ```
  * 修改/etc/vsftpd/ftpusers
  ```
  #vim /etc/pam.d/vsftpd
  auth       required     pam_listfile.so item=user sense=deny file=/etc/vsftpd/ftpusers onerr=succeed
  ```
  ftpusers里面是ftp默认拒绝的用户，如果要想系统用户，就把这个用户从ftpusers文件中删除。为了允许root用户能够登陆ftp，我们需要将root所在行删除  
  注意：如果在/etc/vsftpd/vsftpd.conf配置的是`userlist_deny=YES`,那么需要检查文件/etc/vsftpd/user_list，将其中的root行删除
* 重启vsftpd服务
```
service vsftpd restart
```
