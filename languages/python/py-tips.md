# Python Tips

## 快速启动一个http服务器
[参考链接][python-http-server]

如果需要一个http server来分享文件，可以通过python的SimpleHTTPServer模块来快速启动一个http服务器
```
cd /home/files
python -m SimpleHTTPServer
```
默认会在8000端口启动服务，如果存在端口冲突，可以运行如下命令改变默认端口。
`python -m SimpleHTTPServer 8080`

如果只想让http server服务于本地环境，那么可以做下定制：
```python
import sys
import BaseHTTPServer
from SimpleHTTPServer import SimpleHTTPRequestHandler
HandlerClass = SimpleHTTPRequestHandler
ServerClass  = BaseHTTPServer.HTTPServer
Protocol     = "HTTP/1.0"
 
if sys.argv[1:]:
    port = int(sys.argv[1])
else:
    port = 8000
server_address = ('127.0.0.1', port)
 
HandlerClass.protocol_version = Protocol
httpd = ServerClass(server_address, HandlerClass)
 
sa = httpd.socket.getsockname()
print "Serving HTTP on", sa[0], "port", sa[1], "..."
httpd.serve_forever()
```

>SimpleHTTPServer是python自带的一个模块，可以通过imp查找到该模块路径并查看源代码

```
>>> import imp
>>> imp.find_module('SimpleHTTPServer')
>>> (<open file '/usr/lib64/python2.7/SimpleHTTPServer.py', mode 'U' at 0x7f590e7cd6f0>, '/usr/lib64/python2.7/SimpleHTTPServer.py', ('.py', 'U', 1))
```
[python-http-server]: https://coolshell.cn/articles/1480.html
