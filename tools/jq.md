# jq cookbook

sample.json
```json
{
  "apiVersion": "v1",
  "data": {
    ".secret": "aslkjdasjdf="
  },
  "kind": "Secret",
  "type": "Opaque",
  "groups": [
      "sample",
      "poc"
  ],
  "roles": [
      {
          "Name": "tester"
      },
      {
          "Name": "developer"
      },
      {
          "Name": "operator"
      }
  ],
  "rolling": 1
}
```

## 获取数组的部分元素
```bash
jq '.roles[1:3]' sample.json
[
  "role2",
  "role3"
]
```

## 传shell变量给jq  
```bash
role="tester"
jq --arg role "$role" '.roles[] | select(.Name | contains ($role))' sample.json
{
  "Name": "tester"
}
```


## 获取key名称带'.'的值  
```bash
jq -r '.data[".secret"]' sample.json
aslkjdasjdf=
```

## 利用jq转换数据格式  
```bash
#抽取数据转为shell数组：
list=(`jq '.kind,.groups[]' sample.json`)
for i in ${list[@]};do echo "hi"$i;done
```

## 基本计算  
```bash
jq '.rolling + 1' sample.json
2
```

## 删除元素
```bash
jq 'del(.roles)' sample.json
```

## 迭代操作  
```bash
echo '[12,14,15]' | jq 'map(.-2)'
[
  10,
  12,
  13
]
```

## 根据值过滤对象  
```bash
jq '.roles[] | select(.Name | contains ("develop"))' sample.json
{
  "Name": "developer"
}
```