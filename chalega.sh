#! /bin/bash
METACALL_PATH="metacall"
CFLAGS=""
LDFLAGS=" \
	-fPIC \
	-L${METACALL_PATH}/libc/lib \
	-L${METACALL_PATH}/python/lib \
	-L${METACALL_PATH}/ruby/lib \
	-Wl,-rpath=${METACALL_PATH}/libc/lib \
	-Wl,-rpath=${METACALL_PATH}/python/lib \
	-Wl,-rpath=${METACALL_PATH}/ruby/lib \
	-Wl,--dynamic-linker=${METACALL_PATH}/libc/lib/ld.so"
PATH="${PATH}:${METACALL_PATH}/python/bin:${METACALL_PATH}/ruby/bin"


git clone -j8 --single-branch https://github.com/metacall/core.git
mkdir -p core/build && cd core/build
cmake \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_INSTALL_PREFIX=${METACALL_PATH}/core \
	-DOPTION_BUILD_SECURITY=OFF `# Disable security in order to improve libc portabilitycompatibility` \
	-DOPTION_BUILD_DIST_LIBS=ON \
	-DOPTION_FORK_SAFE=OFF \
	-DOPTION_BUILD_TESTS=OFF \
	-DOPTION_BUILD_SCRIPTS=OFF \
	-DOPTION_BUILD_SERIALS=ON \
	-DOPTION_BUILD_SERIALS_RAPID_JSON=ON \
	-DOPTION_BUILD_SERIALS_METACALL=ON \
	-DOPTION_BUILD_EXAMPLES=ON \
	-DOPTION_BUILD_LOADERS=ON \
	-DOPTION_BUILD_LOADERS_MOCK=ON \
	-DOPTION_BUILD_LOADERS_PY=ON \
	-DPYTHON_EXECUTABLE=${METACALL_PATH}/python/bin/python3 \
	-DPYTHON_INCLUDE_DIRS=${METACALL_PATH}/python/include \
	-DPYTHON_LIBRARIES=${METACALL_PATH}/python/lib \
	-DOPTION_BUILD_LOADERS_RB=ON \
	-DRUBY_EXECUTABLE=${METACALL_PATH}/ruby/bin/ruby \
	-DRUBY_INCLUDE_DIR=${METACALL_PATH}/ruby/include/ruby-${METACALL_RUBY_INCLUDE_VERSION} \
	-DRUBY_CONFIG_INCLUDE_DIR=${METACALL_PATH}/ruby/include/ruby-${METACALL_RUBY_INCLUDE_VERSION{METACALL_ARCH_HOST}/ruby/config.h \
	-DRUBY_LIBRARY=${METACALL_PATH}/ruby/lib/libruby.so.${METACALL_RUBY_VERSION} \
	-DRUBY_VERSION=${METACALL_RUBY_VERSION} \
	-DOPTION_BUILD_LOADERS_FILE=ON \
	-DOPTION_BUILD_LOADERS_NODE=OFF `# TODO` \
	-DOPTION_BUILD_LOADERS_CS=OFF `# TODO` \
	-DOPTION_BUILD_LOADERS_JS=OFF `# TODO` \
	-DOPTION_BUILD_PORTS=ON \
	-DOPTION_BUILD_PORTS_PY=ON \
	-DOPTION_BUILD_PORTS_RB=ON \
	-DOPTION_BUILD_PORTS_CS=OFF `# TODO` \
	-DOPTION_BUILD_PORTS_NODE=OFF `# TODO` \
	-DCMAKE_CXX_FLAGS=-fpermissive `# Required by Python Port (Swig)` \
	..

make -j8
make install
