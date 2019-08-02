# 存储结构
[kafka在zookeeper中的存储结构](http://www.cnblogs.com/yinchengzhe/p/5127405.html)
[Confluence Kafka in zookeeper](https://cwiki.apache.org/confluence/display/KAFKA/Kafka+data+structures+in+Zookeeper)

# 常用命令

* 修改topic偏移量  
  topic的偏移量一般都是存储在Zookeeper中，具体的路径为/consumers/[groupId]/offsets/[topic]/[partitionId],我们可以通过set命令来设置某个分区的偏移量  
  ```bash
  ./bin/zookeeper-shell.sh localhost:2181 <<< "set /consumers/[groupId]/offsets/[topic]/[partitionId] $newoffset"
  ```
  由于新版本consumer不依赖于zookeeper,kafka提供了kafka-consumer-groups.sh,可以用来检查新／旧消费者的状态,下面是示例脚本代码  
  ```bash
  bin/kafka-consumer-gro22ups.sh --zookeeper localhost:2181 --list
  #该命令输出仅包含使用ZooKeeper的消费者，不包含用Jave consumer API的消费者。
  ```
* 计算coordinator所在broker:
  http://www.browxy.com/ (online java)
  ```java
  String groupId="bdd-test-group";
  System.out.println(Math.abs(groupId.hashCode() % 50));
  ```
  kafka-simple-consumer-shell.sh --topic __consumer_offsets --partition 11 --broker-list localhost:9092,localhost:9093,localhost:9094 --formatter "kafka.coordinator.GroupMetadataManager\$OffsetsMessageFormatter"
* 检查zookeeper角色 `echo stat | nc localhost 2181`

# 其他参考
  [手动安装zookeeper](http://vinc.top/2016/09/20/zookeeper%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9C%A8kafka%E4%B8%AD%E7%9A%84%E5%BA%94%E7%94%A8/)

# CLI
> zkCli.sh
> rmr /brokers/topics/__ibm_dnwe2
> sync
> exit