# 使用基础镜像
FROM ubuntu:noble

COPY . /app

WORKDIR /app

# 安装依赖
RUN apt-get update && apt-get install -y libpcre3-dev libnftables-dev pkg-config git; \
	bash ./update_submodule.sh; \
	make; \
	mv ./dnsmasq/src/dnsmasq /usr/sbin/dnsmasq; \

# 运行 dnsmasq 服务
CMD ["dnsmasq", "-k"]