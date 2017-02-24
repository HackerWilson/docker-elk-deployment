## 项目简介

部署`Elastic Stack` 5.2.0+ 至`swarm mode`的集群，收集`swarm mode`集群中所有容器的日志

```
+------------+            +------------+            +------------+
|  Dockerd   |            |  Dockerd   |            |  Dockerd   |
|  GELF UDP  |            |  GELF UDP  |            |  GELF UDP  |
+------------+            +------------+            +------------+
      |                         |                         |
+------------+            +------------+            +------------+
|  Logstash  |            |  Logstash  |            |  Logstash  |
|  Shipper   |            |  Shipper   |            |  Shipper   |
+------------+            +------------+            +------------+
      |                         |                         |
      |                   +------------+                  |
      |___________________|   Redis    |__________________|
                          |   Broker   |
                          +------------+
                                |
                          +------------+
                          |  Logstash  |
                          |  Indexer   |
                          +------------+
                                |
                        +----------------+
                        |  Elasticsearch |
                        +----------------+
                                |
                          +------------+
                          |   Kibana   |
                          +------------+
```

## 部署依赖

- [Docker](https://github.com/docker/docker) 1.13.0+
- [Compose](https://github.com/docker/compose) 1.10.0+
- 以下依赖项为部署项目附带的`test`环境所需
  - [Netshare plugin](https://github.com/ContainX/docker-volume-netshare) 0.32

## 部署说明

- 新增部署环境配置，以下以`env_files/test`部署环境为例

> 部署项目附带的`test`环境仅需要修改`env_files/test/common.env`文件中的`ELASTICSEARCH_DATA_PATH`和`REDIS_DATA_PATH`这两个变量

- 根据部署环境导入环境变量，如`test`环境
```
./env.sh test
```

### 部署elk stack

- 使用`docker-compose`生成部署`elk stack`需要的`compose file`
```
docker-compose config > elk-stack.yml
```

- 部署`elk stack`至`swarm mode`集群
```
docker stack deploy -c elk-stack.yml $COMPOSE_PROJECT_NAME
```

### 部署logstash shipper

- 使用`docker-compose`生成部署`logstash shipper`需要的`compose file`
```
docker-compose -f logstash-shipper.yml config > elk-logstash-shipper.yml
```

- 部署`logstash shipper`至`swarm mode`集群中的每个节点
```
docker stack deploy -c elk-logstash-shipper.yml elk-logstash
```

## 验证部署

- 将容器日志通过`gelf`发送至`logstash shipper`
```
docker run --rm --log-driver gelf --log-opt gelf-address=udp://127.0.0.1:9500 -d alpine echo hello world
```

- 浏览器访问`Kibana`
```
http://swarm-node-host:5601
```

- `Kibana`入口创建index后，选择左上角Discover，然后右上角选择Today的数据查看

## 注意事项

- 需要调整操作系统[vm.max_map_count值](https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html)
```
sudo sysctl -w vm.max_map_count=262144
```

- 可以使用其它`volume plugins`来替代`nfs`的存储方式

## 参考

- [docker-elk](https://github.com/deviantony/docker-elk)
- [Adventures in GELF](https://blog.docker.com/2017/02/adventures-in-gelf/)

## 版权

- [MIT LICENSE](LICENSE)
