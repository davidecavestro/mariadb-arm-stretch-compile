FROM arm32v7/debian:stretch-slim AS builder

COPY qemu-arm-static /usr/bin

ARG DEBIAN_FRONTEND=noninteractive

RUN \
  echo "deb-src http://deb.debian.org/debian stretch main" >> /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y --no-install-recommends install apt-utils git ca-certificates libneon27-gnutls-dev ninja-build && \
  apt-get -y --no-install-recommends build-dep mariadb-server

ARG MARIADB_VERSION=10.3
RUN git clone --branch $MARIADB_VERSION --single-branch --depth=1 https://github.com/MariaDB/server.git /src

WORKDIR /src

#RUN cmake . -DBUILD_CONFIG=mysql_release && make
RUN cmake . \
  -DENABLE_DEBUG_SYNC=OFF \
  -DINSTALL_MYSQLTESTDIR= \
  -DCONC_WITH_{UNITTEST,SSL}=OFF \
  -DWITH_EMBEDDED_SERVER=OFF \
  -DWITH_MARIABACKUP=OFF \
  -DWITH_UNIT_TESTS=OFF \
  -DPLUGIN_ARCHIVE=NO \
  -DPLUGIN_BLACKHOLE=NO \
  -DPLUGIN_CASSANDRA=NO \
  -DPLUGIN_MROONGA=NO \
  -DPLUGIN_OQGRAPH=NO \
  -DPLUGIN_PERFSCHEMA=NO \
  -DPLUGIN_SPHINX=NO \
  -DPLUGIN_SPIDER=NO \
  -DENABLED_PROFILING=OFF \
  -DENABLE_DTRACE=OFF \
  -DENABLE_DEBUG_SYNC=OFF \
  -DWITHOUT_TOKUDB=ON \
  -DWITH_NDB_STORAGE_ENGINE=0 \
  -DWITH_PARTITION_STORAGE_ENGINE=0 \
  -DWITH_OQGRAPH_STORAGE_ENGINE=0 \
  -DWITHOUT_MROONGA_STORAGE_ENGINE=1 \
  -DWITHOUT_ROCKSDB_STORAGE_ENGINE=1 \
  -DWITH_SAFEMALLOC=OFF \
  -DWITH_SSL=bundled \
  -G Ninja
