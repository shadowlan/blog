* 初始化数组
```bash
#option 1
array=(a b c)
#option 2
array[0]="anna"
array[1]="sara"
```

* 引用数组
```bash
$array=(a b c)
$echo array[0]
a

#数组的所有值
$echo ${array[*]}
a b c
$echo ${array[@]}
a b c
```
* 其他操作
    * 数组的长度： ${#array[@]}
    * 某个元素的字符串长度：${#array[n]}
    * 取子数组，从第n位开始的m个元素：${array[@]:n:m}
    * 从数组第x个元素的第n位开始取m个数组： ${array[x]:n:m}
    * 搜索并替换元素：${array[@]/strA/strB}
    * 将元素附加到原数组： Unix=("${Unix[@]}" "AIX" "HP-UX")
    * 拷贝一个数组： arrayb=("${arraya[@]}")
    * 将文件赋值给数组： filecontent=( `cat "logfile" `)
    * 迭代：for i in ${stra[@]}; do echo -e "$i\n";done;

* 字典操作
```bash
declare -A dic
dic=([key1]="value1" [key2]="value2" [key3]="value3")
#打印指定key的值
echo ${dic["key1"]}
#打印所有key值
echo ${!dic[*]}
#打印所有value
echo ${dic[*]}
#遍历
for key in $(echo ${!dic[*]})
do
   echo "$key : ${dic[$key]}"
done
```
