## Docs

- [中文](docs/zh/README.md)

## Introduction

Deploy `Elastic Stack` 5.2.0+ on `swarm mode` cluster, access container logs in elk.

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

## Requirements

- [Docker](https://github.com/docker/docker) 1.13.0+
- [Compose](https://github.com/docker/compose) 1.10.0+
- Optional when deploy test example within this project
  - [Netshare plugin](https://github.com/ContainX/docker-volume-netshare) 0.32

## Usage

- Add new environment files, eg. `env_files/test`

> When deploy test example within this project, you only need to modify `ELASTICSEARCH_DATA_PATH` and `REDIS_DATA_PATH` these two variables in `env_files/test/common.env` file.

- Create the `.env` file used by `docker-compose`
```
./env.sh test
```

### Deploy elk stack

- Create the `elk stack` compose file
```
docker-compose config > elk-stack.yml
```

- Deploy `elk stack` to `swarm mode` cluster
```
docker stack deploy -c elk-stack.yml $COMPOSE_PROJECT_NAME
```

### Deploy logstash shipper

- Create the `logstash shipper` compose file
```
docker-compose -f logstash-shipper.yml config > elk-logstash-shipper.yml
```

- Deploy `logstash shipper` to every node in `swarm mode` cluster
```
docker stack deploy -c elk-logstash-shipper.yml elk-logstash
```

## Deployment test

- Send some container logs to `logstash shipper` by `gelf` logging drivers
```
docker run --rm --log-driver gelf --log-opt gelf-address=udp://127.0.0.1:9500 -d alpine echo hello world
```

- Browser to `Kibana` pages
```
http://swarm-node-host:5601
```

- Configure an index pattern with `logstash-*` in `Kibana`, then select the time range of today

## Tips

- Increase the default operating system [vm.max_map_count](https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html) limits
```
sudo sysctl -w vm.max_map_count=262144
```

- You can use other volume plugins by fork this project then modify the `driver` and `driver_opts` under the top-level `volumes` key

## References

- [docker-elk](https://github.com/deviantony/docker-elk)
- [Adventures in GELF](https://blog.docker.com/2017/02/adventures-in-gelf/)

## License

- [MIT LICENSE](LICENSE)
