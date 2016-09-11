# docker build -tclang38 clang38
# docker run -ti -v /home/baplepil/dev:/work clang38 /sbin/my_init bash

# Use phusion/baseimage as base image. 
# See https://github.com/phusion/baseimage-docker for more details
#FROM cmake3:latest
FROM blep/docker-baseimage-cmake3:0.2.0

RUN apt-get update
# clang-3.8
# /usr/bin/clang-3.8: 338.5 MB -> 602.5 MB
RUN /sbin/my_init -- apt-get install -y --no-install-recommends clang-3.8 llvm-3.8 llvm-3.8-dev

ENV CXX="clang++-3.8"
ENV CC="clang-3.8"

RUN mkdir /work && chmod 777 /work
RUN update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.8 100
RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-3.8 100
RUN update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100
RUN update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++ 100
RUN update-alternatives --install /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-3.8 100

COPY afl /home/afl
RUN cd /home/afl && make && (cd llvm_mode && make) && make install && make clean  &&  chmod 777 /home/afl

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /work
