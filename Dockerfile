FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive

ENV BR_URL https://buildroot.org/downloads/buildroot-2020.02.7.tar.gz

RUN apt-get update && apt-get dist-upgrade -y
 
RUN apt-get install -y wget curl git libncurses-dev cpio bc unzip locales texinfo libelf-dev

RUN apt-get install -y rsync build-essential expect pkg-config libarchive-tools m4 gawk bc bison flex texinfo python3 perl libtool autoconf automake autopoint autoconf-archive mtools liblzma-dev libelf-dev libssl-dev zlib1g-dev zlib1g xz-utils lzip file curl wget gettext

RUN apt autoremove -y

RUN rm -rf /var/lib/apt/lists/* && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.utf8

RUN adduser --disabled-password --uid 1000 --gecos "Docker Builder" builder

WORKDIR /home/builder

USER builder

RUN mkdir -vp /home/builder/buildroot

RUN wget $BR_URL && tar -xvf ./buildroot-*.tar.gz --strip 1 -C /home/builder/buildroot

RUN mkdir -p /home/builder/pixie

COPY . /home/builder/pixie

WORKDIR /home/builder/buildroot

RUN cat /home/builder/pixie/pixieos_x86_64.config > .config

RUN cat /home/builder/pixie/pixieos_x86_64.defconfig > .defconfig

ENTRYPOINT make
