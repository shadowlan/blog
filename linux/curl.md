# 获得curl的返回http code
```
curl -s -w "%{http_code}" http://baidu.com -o /dev/null
```
如果curl能够正常发送请求并获得响应，那么curl命令的linux输出结果将会是0，如果需要根据http返回code来定义curl执行后的退出码,可以参考如下方式：  
```bash
result=`curl -s -w "%{http_code}" http://baidu.com -o /dev/null`
if [ "$result" != "200" ];then
  exit $result
fi
```
其他http返回内容的定制输出可以参考[这里](http://beerpla.net/2010/06/10/how-to-display-just-the-http-response-code-in-cli-curl/)
