# phusion/baseimage with python 3.5 pip/pytest, cmake3, clang 3.8 & American Fuzzy Lop (AFL)

This image is based on phusion/baseimage.

It provides:
- Python pip
- Python pytest
- clang 3.8 c++ compiler
- American Fuzzy Lop fuzzer (http://lcamtuf.coredump.cx/afl/)

# Building this image

Make sure to fetch sub-modules with git.

```
git submodule update --init --recursive 
```

This is used to fetch American Fuzzy Lop source code from the unofficial github repo: https://github.com/mcarpenter/afl (which has proper version tags).

docker build -tclang38 clang38

# Using American Fuzzy Lop (AFL)

Makes sure to read the official document http://lcamtuf.coredump.cx/afl/, and its link to the online readme.

## Docker specific

When you run afl-fuzz for the first time, it may complain that the kernel is incorrectly configured and provide corrective actions:

```
echo core >/proc/sys/kernel/core_pattern

cd /sys/devices/system/cpu
echo performance | tee cpu*/cpufreq/scaling_governor
```

In my experience, those actions could not be applied inside the container (let's me know if you know how, was running Ubuntu 14: core_pattern may reference appstart binary that don't even exist in the container).
You need to execute them as root on the HOST that is running the container.

# Using Clang & CMake

As environment variable CXX & CC are automatically set in the container, building a project with cmake is just the usual:

```
mkdir build-make && cd build-make && cmake -G "Unix Makefiles" ..
```

# Using this image

A simple usage is to mount a local host directory into the container and run the container with an interactive bash:

```
docker run -ti -v /home/baplepil/dev:/work clang38 /sbin/my_init bash
```

This allow editing files on your HOST machine while compiling with clang inside the container or AFL.

```
docker run -v /home/baplepil/dev:/work clang38 /sbin/my_init /work/build.sh
```

Will run the script /home/baplepil/dev/build.sh in the container.
