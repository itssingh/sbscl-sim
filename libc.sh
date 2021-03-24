#! /bin/bash

METACALL_ARCH="amd64"
METACALL_PATH="${METACALL_PATH}"
METACALL_GLIBC_VERSION="2.30"

apt-get update
apt-get install -y --no-install-recommends python3 python3-pip
rm -rf /var/lib/apt/lists/*
pip3 install pexpect

export LC_ALL=POSIX
export PATH=${METACALL_PATH}/bin:/bin:/usr/bin:/sbin:/usr/sbin

mkdir -p ${METACALL_PATH}/libc

curl https://ftp.gnu.org/gnu/glibc/glibc-${METACALL_GLIBC_VERSION}.tar.bz2 --output glibc.tar.bz2
curl https://ftp.gnu.org/gnu/glibc/glibc-${METACALL_GLIBC_VERSION}.tar.bz2.sig --output glibc.tar.bz2.sig
gpg --verify glibc.tar.bz2.sig glibc.tar.bz2
tar -xjf glibc.tar.bz2
mkdir -p glibc-${METACALL_GLIBC_VERSION}/build
cd glibc-${METACALL_GLIBC_VERSION}/build
../configure
		--prefix=${METACALL_PATH}/libc \
		--host=${METACALL_ARCH_HOST} \
		--build=$(../scripts/config.guess) \
		--enable-kernel=3.2 \
		libc_cv_forced_unwind=yes \
		libc_cv_c_cleanup=yes \
make -j $(nproc)
make install
cd ../..
rm -rf glibc-${METACALL_GLIBC_VERSION} glibc.tar.bz2 glibc.tar.bz2.sig

ln -s ${METACALL_PATH}/libc/lib/ld-${METACALL_GLIBC_VERSION}.so ${METACALL_PATH}/libc/lib/ld.so

echo 'int main(){}' > main.c
gcc main.c \
		-L${METACALL_PATH}/libc/lib \
		-Wl,-rpath=${METACALL_PATH}/libc/lib \
		-Wl,--dynamic-linker=${METACALL_PATH}/libc/lib/ld.so
readelf -l a.out | grep ": ${METACALL_PATH}"
rm main.c a.out
