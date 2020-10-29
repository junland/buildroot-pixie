FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive

ENV BR_URL https://buildroot.org/downloads/buildroot-2020.02.7.tar.gz

RUN dpkg --add-architecture i386

RUN apt-get update && apt-get dist-upgrade -y
 
RUN apt-get install -y wget file curl git bzr cvs mercurial subversion libncurses-dev libncurses5-dev libc6:i386 cpio bc unzip locales texinfo libelf-dev rsync build-essential expect pkg-config libarchive-tools m4 gawk bc bison flex python3 perl libtool autoconf automake autopoint autoconf-archive mtools liblzma-dev zlib1g-dev zlib1g xz-utils lzip gettext

RUN apt-get autoremove -y && rm -rf /var/lib/apt/lists/* && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

RUN update-locale LC_ALL=C

RUN adduser --disabled-password --uid 1000 --gecos "Docker Builder" builder

WORKDIR /home/builder

USER builder

ENV LANG en_US.utf8

ENV LC_ALL C

RUN mkdir -vp /home/builder/buildroot

RUN wget $BR_URL && tar -xvf ./buildroot-*.tar.gz --strip 1 -C /home/builder/buildroot

RUN mkdir -p /home/builder/src

COPY . /home/builder/src

WORKDIR /home/builder/buildroot

RUN cp -vR /home/builder/src/rootfs_overlay /home/builder/buildroot

RUN cat /home/builder/src/pixieos_x86_64.config > /home/builder/buildroot/.config

RUN cat /home/builder/src/pixieos_x86_64.defconfig > /home/builder/buildroot/.defconfig

ENTRYPOINT make
