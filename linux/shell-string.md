* 大小写切换
```bash
echo "$var" | tr '[:lower:]' '[:upper:]'
tr '[A-Z]' '[a-z]' < $filename
y="this is a test"; echo "${y^^}"
y="THIS IS A TEST"; echo "${y,,}"
```
* 分割字符串
shell特殊变量$IFS（internal field separator），默认分割符为空格<space>／制表符<tab>／换行符<newline>
打印IFS: cat -etv <<< "$IFS"
```bash
str="this is a string"
array=($string)
```
指定分割符
```bash
#保存为字符串
IFS=';';arr=($IN);unset IFS
IFS=$'\n'; arrIN=($IN); unset IFS;
#立即处理
IFS=';' read -ra STR <<< "$input"
for i in "${STR[@]}";do
  #your shell code
done
```
* 读取文件
```bash
content=`cat $file`
content=$(<$file)
```
* 字符串操作
| 表达式  | 含义  |
|---------|-------|
|${#string} |$string的长度|
|${string:position}|在position开始提取子串|
|${string:position:length}|在position开始提取长度为length的子串|
|${string#substring}|从变量$string的开头，删除最短匹配$substring的子串|
|${string##substring}|从变量$string的开头，删除最长匹配$substring的子串|
|${string%substring}|从变量$string的结尾，删除最短匹配$substring的子串|
|${string%%substring}|从变量$string的结尾，删除最长匹配$substring的子串|
|${string/substring/replacement}|使用$replacement来代替第一个匹配的$substring|
|${string//substring/replacement}|使用$replacement来代替所有匹配的$substring|
|${string/#substring/replacement}|如果$string的前缀匹配$substring,那么就用$replacement来代替匹配到的$substring   |
|${string/%substring/replacement}|如果$string的后缀匹配$substring,那么就用$replacement来代替匹配到的$substring   |
说明: "$substring"可以是一个正则表达式
使用实例：
1. 字符串删除
```bash
$test='/var/log/boot.log'
$echo ${test##*/}
boot.log
$echo ${test%/*}
/var/log
```
2. 字符串替换
```bash
$test=
$echo ${test/\//\\}
\var/log/boot.log
$echo ${test//\//\\}
\var\log\boot.log
```
* 参数替换
| 表达式 |含义|
|--------|----|
| ${var}|变量var的值，于$var相同   |
| ${var-DEFAULT}|如果var没有被声明，那么就以$DEFAULT作为其值|
| ${var:DEFAULT}|如果var没有被声明，或者其值为空，那么就以$DEFAULT作为其值|
| ${var=DEFAULT}|如果var没有被声明，那么就以$DEFAULT作为其值|
| ${var:=DEFAULT}|如果var没有被声明，或者其值为空，那么就以$DEFAULT作为其值|
| ${var+OTHER}|如果var被声明了，那么其值就是$OTHER,否则就为null字符串|
| ${var:+OTHER}|如果var被设置了，那么其值就是$OTHER,否则就为null字符串|
| ${var?ERR_MSG}|如果var没被声明，那么就打印$ERR_MSG|
| ${var:?ERR_MSG}|如果var没被设置，那么就打印$ERR_MSG|
| ${!varprefix*}|匹配之前所有以varprefix开头进行声明的变量|
| ${!varprefix@}|匹配之前所有以varprefix开头进行声明的变量|
