# Nexus API信息
Nexus提供两种API，一种是Rest API，另一种是Integration API(scripting API)，官方介绍在[这里](https://help.sonatype.com/display/NXRM3/REST+and+Integration+API)  
[Nexus API 示例代码库](https://github.com/sonatype/nexus-book-examples/tree/nexus-3.x/scripting)  
[官方core API文档][nexus-core-api]

# 使用Scripting API的前提

## 安装Groovy
执行下面的命令即可，具体描述可参考[官方安装文档](http://groovy-lang.org/install.html#SDKMAN)
```
curl -s get.sdkman.io | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install groovy
```
执行`groovy -version`来验证安装是否成功

## 添加服务器SSL证书 
这一部分根据需要执行，如果nexus没有配置ssl，则可跳过
```bash
openssl s_client -connect $hostname:443 < /dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > public.crt
$JAVA_HOME/bin/keytool -import -alias $hostname -keystore $JAVA_HOME/jre/lib/security/cacerts -file public.crt
#it will prompt for cacerts file's password, the default password is "changeit"
```

# 示例

示例基于官方的API示例库，请通过`git clone -b nexus-3.x git@github.com:sonatype/nexus-book-examples.git`获得源代码。
> 添加LDAP用户权限  
以下均在目录nexus-book-examples-nexus-3.x/scripting/complex-script/下操作
* 创建负责更新用户权限的user.groovy文件，内容如下：
```groovy
import groovy.json.JsonOutput
import groovy.json.JsonSlurper
import org.sonatype.nexus.security.role.RoleIdentifier

def roleParam = new JsonSlurper().parseText(args)
RoleIdentifier role = new RoleIdentifier(roleParam.sourceId, roleParam.roleId)
def roleSet = [ role ] as Set
security.securitySystem.setUsersRoles(roleParam.userId,'LDAP',roleSet)
```
* 创建示例用的用户信息文件，例如user.json
```json
{
 "roleId": "developer",
 "sourceId": "default",
 "userId": "xyz@qq.com"
}
```
* 创建scripting API
```bash
groovy -Dgroovy.grape.report.downloads=true -Dgrape.config=grapeConfig.xml addUpdateScript.groovy -u "admin" -p "admin123" -n "grantuser" -f "user.groovy" -h "https://$hostname"
```

* 执行scripting API
命令调用新创建的名为grantuser的scripting API,传入user.json文件，user.groovy根据json文件解析roleId,sourceId和userId，给$userId赋予$roleId权限。
```bash
curl --insecure -v -X POST -u admin:admin123 --header "Content-Type: text/plain" "https://$hostname/service/siesta/rest/v1/script/grantuser/run" --data-binary "@user.json"
```
[nexus-core-api]: https://repository.sonatype.org/nexus-restlet1x-plugin/default/docs/index.html
