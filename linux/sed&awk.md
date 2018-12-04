本文内容整理自<Sed and Awk 101 hacks>
# sed  
## sed命令语法和基本命令  
示例中用到的exployee.text 文件内容如下：
```
101,John Doe,CEO
102,Jason Smith,IT Manager
103,Raj Reddy,Sysadmin
104,Anand Ram,Developer
105,Jane Miller,Sales Manager
```

### 基本语法
1. sed [options] {sed-commands} {input-file}
`sed -n 'p' /etc/passwd`
2. 通过sed文件： sed [options] –f {sed-commands-in-a-file} {input-file}
`sed –n –f test-script.sed /etc/passwd`
3. 通过-e 执行多个sed命令
`sed –n –e ‘/^root/ p’ –e ‘/^nobody/ p’ /etc/passwd`

### 打印行：p命令
结合-n使用，屏蔽默认输出 `sed –n ‘p’ employee.txt`

* 指定地址范围
a. 打印某行： `sed -n '2p' employee.txt`
b. 打印n到m行：`sed -n '2,4p' exployee.txt`
c. 打印n到最后一行： `sed -n '1,$p' exmployee.txt`

* 修改地址范围
a. +号配合逗号使用指定从n行开始的m行：`sed -n '2,+4p' employee.txt`
b. ～波浪号制定每次要跳过的行数,例如2~2 匹配 2,4,6,8,......： `sed -n '1~2p' employee.txt`

* 模式匹配

  可以用数字来指定地址范围，也可以使用模式来匹配指定的范围，例如： 打印自匹配 Raj 的行开始到匹配 Jane 的行之间的所有内容 `sed -n '/Raj/,/Jane/ p' employee.txt`

  地址范围可以和模式匹配结合起来使用，例如：打印从第一次匹配 Raj 的行到最后的所有行
`sed -n '/Raj/,$ p' employee.txt`

### 删除行：d命令

删除行可以结合上面提到的地址范围和模式匹配来删除行,例如:

  a. 删除第2行：`sed '2d' employee.txt`  
  b. 删除2到最后一行： `sed '2,$d' employee.txt`  
  c. 删除奇数行： `sed '1~2 d' employee.txt`  
  d. 删除所有空行： `sed ‘/^$/ d’ employee.txt`  

### 写文件：w命令

写文件命令同样可以结合上面提到的地址范围和模式匹配来写入,例如

a. 不打印到stdout，直接写入文件 `sed -n 'w output.txt' employee.txt`  
b. 保存第 1 至第 4 行:`sed -n '1,4 w output.txt' employee.txt`  

## sed替换命令  
### 基本语法

sed '[address-range|pattern-range] s/original-string/replacement-string/[substitute-flags]' input file  
  * address-range 或 pattern-range(即地址范围和模式范围)是可选的。如果没有指
定，那么 sed 将在所有行上进行替换。

### 替换标志

* 全局标志 g (global)  
g 代表全局(global) 默认情况下，sed 至会替换每行中第一次出现的 original-string。如果你要替换每行中出现的所有 original-string,就需要使用 g

* 数字标志(1,2,3...)  
使用数字可以指定 original-string 出现的次序。只有第 n 次出现的 original-string 才会触发替换。每行的数字从 1 开始，最大为 512.
例如： 把第二次出现的小写字母 a 替换为大写字母 A:
`sed 's/a/A/2' employee.txt`

* 打印标志p (print)  
命令 p 代表 print。当替换操作完成后，打印替换后的行。与其他打印命令类似，sed 中比较有用的方法是和-n 一起使用以抑制默认的打印操作。例如：把每行中第二次出现的 locate 替换为 find 并打印出来,`sed -n 's/locate/find/2p' substitute-locate.txt`

* 写标志 w (write)  
标志 w 代表 write。当替换操作执行成功后，它把替换后的结果保存的文件中。多数人更倾 向于使用 p 打印内容，然后重定向到文件中。例如只把替换后的内容写到 output.txt 中:
`sed -n 's/John/Johnny/w output.txt' employee.txt`

* 忽略大小写标志 i (ignore)  
替换标志 i 代表忽略大小写。可以使用 i 来以小写字符的模式匹配 original-string。该标志只有 GNU Sed 中才可使用。

* 执行命令标志 e (excuate)  
替换标志 e 代表执行(execute)。该标志可以将模式空间中的任何内容当做 shell 命令执行，并把命令执行的结果返回到模式空间。该标志只有 GNU Sed 中才可使用。例如在 files.txt 文件中的每行前面添加 ls –l 并把结果作为命令执行:  
  ```
  $cat files.txt
  /etc/passwd
  /etc/group
  $sed 's/^/ls -l /e' files.txt
  -rw-r--r-- 1 root root 1533 Dec 13 20:21 /etc/passwd
  -rw-r--r-- 1 root root 682 Dec 13 20:21 /etc/group
  ```

* 使用替换标志组合  
以上提到的各种标志可以结合起来使用，例如：`sed -n 's/manager/Director/igpw output.txt' employee.txt`

* sed替换命令分界符  
sed默认的分界符为`/`,如果要替换的字符串中包含`/`就需要用`\`作为转译字符，这在字符串中包含很多`/`时会非常不便，sed允许使用其他字符如 | 或 ^ 或 @ 或者 !来作为分界符。

* &的作用-获取匹配到的模式  
当在 replacement-string 中使用&时，它会被替换成匹配到的 original-string 或正则表达式
例如：给雇员 ID(即第一列的 3 个数字)加上[ ],如 101 改成[101]
 `sed 's/^[0-9][0-9][0-9]/[&]/g' employee.txt`

 * 分组替换(单个分组)  
跟正则表达式中一样，sed中也可以使用分组。分组以\(开始，以\)结束。分组可以用在
回溯引用中,例如：
  * `sed 's/\([^,]*\).*/\1/g' employee.txt`
    * 正则表达式\([^,]*\)匹配字符串从开头到第一个逗号之间的所有字符(并将其放入第一个分组中)
    * replacement-string 中的\1 将替代匹配到的分组
    * g 即是全局标志
  * 如果单词第一个字符为大写，那么会给这个大写字符加上()
    ```
     $echo "The Geek Stuff"|sed 's/\(\b[A-Z]\)/\(\1\)/g'
     (T)he (G)eek (S)tuff  
    ```

* 分组替换（多个分组）  
注意:sed 最多能处理 9 个分组，分别用\1 至\9 表示。   
例如只打印第一列(雇员 ID)和第三列(雇员职位):`sed 's/^\([^,]*\),\([^,]*\),\([^,]*\)/\1,\3/' employee.txt`

* GNU Sed 专有的替换标志  
这些替换标志适合在不知道具体的字符串内容，比如结合分组替换时配合使用
  * \I 标志：把紧跟在其后面的字符当做小写字符来处理
  * \L 标志：把后面所有的字符都当做小写字符来处理。
  * \u 标志：把紧跟在其后面的字符当做大写字符来处理
  * \U 标志：把后面所有的字符都当做大写字符来处理
  * \E 标志：需要和\U 或\L 一起使用，它将关闭\U或\L的功能。

  例如将雇员 ID 都显示为大写，职位都显示为小写 `sed 's/\([^,]*\),\([^,]*\),\([^,]*\)/\U\2\E,\1,\L\3/' employee.txt`

## 正则表达式  
### 正则表达式基础  
示例中使用到的log.txt文件内容  
```
log: input.txt
log:
log: testing resumed
log:
log:output created
```

* 行开头 `^`
* 行结尾 `$`
* 单个字符`.`:元字符点 . 匹配除换行符之外的任意单个字符。
  * `.` 匹配单个字符
  * `..` 匹配两个字符
  * `...` 匹配三个字符
  * ......以此类推
* 匹配0次或多次`*`: 例如`sed -n '/log: *./p' log.txt`
* 匹配一次或多次 `\+`
* 零次或一次匹配 `\?`
* 转义字符`\`
* 字符集 ([0-9]) 字符集匹配方括号中出现的任意一个字符。以下两种方式等效：
  ```
  sed -n '/[234]/ p' employee.txt
  sed -n '/[2-4]/ p' employee.txt
  ```

### 其他正则表达式  
* 或操作符 `|`: 管道符号|用来匹配两边任意一个子表达式. 例如`sed -n '/[2-3]\|105/ p' employee.txt`
* 精确匹配m次 `{m}`: 正则表达式后面跟上{m}标明精确匹配该正则 m 次。
* 匹配m至n次 `{m,n}`: 表明精确匹配该正则至少 m，最多 n 次。m 和 n 不能是负数，并 且要小于 255.`{m,}`表明精确匹配该正则至少 m，最多不限。(同样，如果是`{,n}`表明最 多匹配 n 次，最少一次)。
* 字符边界`\b` \b用来匹配单词开头(\bxx)或结尾(xx\b)的任意字符，因此\bthe\b 将匹配the,但不匹配 they. \bthe 将匹配 the 或 they.
* 回溯引用 `\n`:使用回溯引用，可以给正则表达式分组，以便在后面引用它们, 例如只匹配重复the两次的行:
  ```
  sed -n '/\(the\)\1/ p' words.txt
  word matching using: thethe
  ```
  同理，”\([0-9]\)\1” 匹配连续两个相同的数字，如 11,22,33 .....

### 在sed替换中使用正则表达式  
* 把 employee.txt 中每行最后两个字符替换为”,Not Defined”:`sed -n 's/..$/,Not Defined/ p' employee.txt`
* 清除 test.html 文件中的所有 HTML 标签: `sed 's/<[^>]*>//g' test.html`
* 删除所有注释行和空行:`sed -e 's/#.*// ; /^$/ d' /etc/profile`
* 使用 sed 把 DOS 格式的文件转换为 Unix 格式: `sed ‘s/.$//’ filename`

## 执行sed  
### 单行内执行多个sed命令  
* 使用多命令选项 `-e`: `sed –e ‘command1’ –e ‘command2’ –e ‘command3’`
* 使用`\` 折行:遇到很长的命令时适合使用折行
  ```
  sed -n -e '/^root/p' \
  -e '/^nobody/p' \
  - e '/^mail/p' \
  /etc/passwd
  ```
* 使用`{}`把多个命令组合，例如：sed -n '{/^root/p /^nobody/p /^mail/p}' /etc/passwd

### sed 注释  
sed注释以#开头

###  sed 当做命令解释器使用  
你可以把命令放进一个 shell 脚本中，然后调用脚本名称来执行它们一样，你也可以把 sed 用作命令解释器。要实现这个功能，需要在 sed 脚本最开始加入”#!/bin/sed –f”，例如：
```
 #!/bin/sed -f
 #交换第一列和第二列
 s/\([^,]*\),\([^,]*\),\(.*\).*/\2,\1, \3/g
 #把整行内容放入<>中
 s/^.*/<&>/
 #把 Developer 替换为 IT Manager
 s/Developer/IT Manager/
 #把 Manager 替换为 Director
```
这个脚本加上可执行权限`chmod u+x myscript.sed`,然后直接在命令行调用它:`./myscript.sed employee.txt`  
也可以制定-n选项来屏蔽默认输出 `#!/bin/sed -nf`,注意必须是`-nf`而不是`-fn`.

### 直接修改输入文件  
使用选项`-i` 可以直接修改sed的输入文件，另一保护性措施是加上备份扩展，例如：在原始文件 employee.txt 中，把 John 替换为 Johnny，但在替换前备份employee.txt: `sed -i'.bak' 's/John/Johnny/' employee.txt`,这与`sed –in-place=.bak ‘s/John/Johnny/’ employee.txt`

## sed附加命令  

* 命令 `a`可以在指定位置的后面插入新行，语法：`sed ‘[address] a the-line-to-append’ input-file`  
  * 在第 2 行后面追加一行：`sed '2 a 203,Jack Johnson,Engineer' employee.txt`
  * 在匹配 Jason 的行的后面追加两行: 
    ```
    sed '/Jason/a\ 
    203,Jack Johnson,Engineer\
    204,Mark Smith,Sales Engineer' employee.txt
   ```
   追加多行之间也可以用\n来换行而不是折行


# awk  


## 其他

* 使用shell变量  
```
declare -a params=("CLUSTER_NAME" "NUM_BROKERS" "BROKER_PATTERN" "API_KEY" "PREFIX_FILTER")
for p in "${params[@]}"
do
sed -i "s/%$p%/${!p}/g" jobs/topic-restore-job.yaml
done
```

* 每行插入空行 `sed G file.txt`, 插入多个空行可以用`sed 'G;G' file.txt`  
* dos2unix转换 `sed -i 's/\r//' file.txt`
* 处理json文件：
  
  