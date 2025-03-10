FROM debian:12.9

RUN apt update && apt install -y git make libmariadb-dev libmariadbclient-dev-compat gcc g++ zlib1g-dev libpcre3-dev

COPY . /rathena/

WORKDIR /rathena

RUN ./configure && make clean && make server

RUN chmod +x /rathena/docker-entrypoint.sh

ENTRYPOINT ["/rathena/docker-entrypoint.sh"]