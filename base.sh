#! /bin/bash

METACALL_ARCH="amd64"
METACALL_ARCH_HOST="x86_64-linux-gnu"
METACALL_PATH="metacall"


mkdir -p metacall

sudo apt-get update 
sudo apt-get install -y --no-install-recommends \
	locales \
	git \
	build-essential \
	bison \
	libltdl-dev \
	gawk \
	gettext \
	texinfo \
	autoconf \
	autopoint \
	automake \
	autopoint \
	pkg-config \
	libtool \
	libedit2 \
	curl \
	gnupg \
	ca-certificates 

sudo rm -rf /var/lib/apt/lists/* 
sudo localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 
curl https://ftp.gnu.org/gnu/gnu-keyring.gpg --output gnu-keyring.gpg 
gpg --quiet --import gnu-keyring.gpg 
rm gnu-keyring.gpg

export LANG=en_US.utf8
export DEBIAN_FRONTEND=noninteractive
export METACALL_ARCH_HOST=${METACALL_ARCH_HOST}
export METACALL_PATH=${METACALL_PATH}
export nproc="8"
