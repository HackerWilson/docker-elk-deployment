## 项目简介
```
+------------+            +------------+            +------------+
|  Shipper   |            |  Shipper   |            |  Shipper   |
|  LogStash  |            |  LogStash  |            |  LogStash  |
+------------+            +------------+            +------------+
      |                         |                         |
      |                   +------------+                  |
      |___________________|   Broker   |__________________|
                          |   Redis    |
                          +------------+
                                |
                          +------------+
                          |  Indexer   |
                          |  LogStash  |
                          +------------+
                                |
                        +----------------+
                        |  ElasticSearch |
                        +----------------+
                                |
                          +------------+
                          |   Kibana   |
                          +------------+
```
## 部署说明

- 修改`env_files`文件夹内部署配置

- 根据部署的环境导入环境变量，如staging
```
source env.rc staging
```

- 修改`logstash`文件夹内的logstash启动配置

- 运行如下命令部署`kibana <- elasticsearch <- logstash`及`redis`：
```
docker-compose up -d
```

- 运行如下命令部署`logstash-shipper`
```
docker-compose -f logstash-shipper.yml up
```

- 运行如下命令停止运行中的容器
```
docker-compose stop
docker-compose -f logstash-shipper.yml stop
```

## 验证部署

- 导入日志数据至`logstash-shipper`
```
$ nc localhost 9500 < /path/to/logfile.log
```

- 浏览器访问`Kibana`
```
http://localhost:5601
```

- `Kibana`入口创建index后，选择右上角菜单Discover，选择Today的数据查看

## 注意事项

- `logstash shipper`配置文件中`input`使用到的端口需要同时添加到`logstash-shipper.yml`

- `shell.env`中的环境变量`KIBANA_ELASTICSEARCH_ADDRESS`需和`logstash indexer`配置的`output -> elasticsearch`的`hosts`相同

- 运行如下命令可添加`elasticsearch node`

```
docker-compose -f elasticsearch-node.yml up
```

- 其它导入日志数据至`logstash-shipper`的方法请自行探索

## 参考

- [docker-elk项目](https://github.com/deviantony/docker-elk)

## 版权
 - [MIT LICENSE](LICENSE)
