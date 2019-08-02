# Redis 

# Redis on docker

* Redis Docker Image:bitnami-docker-redis [bitnami-docker](https://github.com/bitnami/bitnami-docker-redis)

> Basic Usage

```bash
# create a dedicated network
docker network create app-tier --driver bridge

# create a redis server with auth
docker run --name redis \
    -e REDIS_PASSWORD=1234qwer -p 6379:6379 \
    -v /tmp/redis-persistence:/bitnami \
    --network app-tier \
    bitnami/redis:latest

# create a redis-cli to interact with redis server
docker run -it --rm \
    --network app-tier \
    bitnami/redis:latest redis-cli -a 1234qwer -h redis

# create a redis-sample container
docker run -it --rm \
    --network app-tier \
    redis-sample:latest
```

* connect to redis server： redis-cli -h 127.0.0.1 -p 6379 -a $password
* get config info：`CONFIG GET *` ; eg:`CONFIG GET loglevel`

# Redis on K8S

* [Redis Helm Chart](https://github.com/kubernetes/charts/tree/master/stable/redis)

> Basic Usage
* deploy redis chart through parameters:

```bash
helm install --name test-release \
  --set redisPassword=secretpassword,persistence.enabled=false\
    stable/redis
```

* deploy redis chart through yaml file

```bash
helm install --name test-release -f values.yaml stable/redis
```

```yaml
#content of value.yaml:
persistence:
  enabled: false
redisPassword: 1234qwer
```

# Redis Client on Golang

Most popular redis go client:

* [Go-Redis](https://github.com/go-redis/redis)
* [Redigo](https://github.com/gomodule/redigo)


