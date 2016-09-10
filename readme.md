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

In my experience, those actions could not be applied inside the container (let's me know if you know how, was running Ubuntu 14: core_pattern may reference Apport binary that don't even exist in the container).
You need to execute them as root on the HOST that is running the container.

# Using Clang & CMake

As environment variable CXX & CC are automatically set in the container, building a project with cmake is just the usual:

```
mkdir build-make && cd build-make && cmake -G "Unix Makefiles" ..
```

# Using this image

The image has an empty directory /work that can be used as a mounting point.

A simple usage is to mount a local host directory into the container and run the container with an interactive bash:

```
docker run -ti -v /home/baplepil/dev:/work clang38 /sbin/my_init bash
```

or on Windows if you mounted a share to /e in the docker-machine VM (by default you only have /c/Users, see section Docker on Windows to add a share):

```
docker run -ti -v /e/prg/prj/infracpp/NativeJIT:/work clang38 /sbin/my_init bash
```

This allow editing files on your HOST machine while compiling with clang inside the container or AFL.

```
docker run -v /home/baplepil/dev:/work clang38 /sbin/my_init /work/build.sh
```

Will run the script /home/baplepil/dev/build.sh in the container.

# Docker on Windows

```
docker-machine create --driver virtualbox default
```

## Mounting drive not within C:\Users

Below commands that adds a VirtualBox share named "drive_e" for host path "E:\" and mount it to /e inside the VM.

```
VBoxManage sharedfolder add default --name "drive_e" --hostpath "E:\"
docker-machine ssh default
sudo -s
echo "mkdir -p /e" >> /mnt/sda1/var/lib/boot2docker/profile
echo "mount -t vboxsf -o uid=1000,gid=50 drive_e /e" >> /mnt/sda1/var/lib/boot2docker/profile
exit
docker-machine restart default
```

For more info:
- https://blog.pavelsklenar.com/5-useful-docker-tip-and-tricks-on-windows/
- http://stackoverflow.com/questions/33245036/docker-toolbox-is-there-a-way-to-mount-other-folders-than-from-c-users-windows

