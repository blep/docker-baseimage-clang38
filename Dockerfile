# docker build -tclang38 clang38
# docker run -ti -v /home/baplepil/dev:/work clang38 /sbin/my_init bash

# Use phusion/baseimage as base image. 
# See https://github.com/phusion/baseimage-docker for more details
FROM cmake3:latest

RUN apt-get update
# clang-3.8
# /usr/bin/clang-3.8: 432MB -> 795.9MB
RUN /sbin/my_init -- apt-get install -y clang-3.8

ENV CXX="clang++-3.8"
ENV CC="clang-3.8"

RUN mkdir /work
RUN update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.8 100
RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-3.8 100
RUN update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100
RUN update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++ 100

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
