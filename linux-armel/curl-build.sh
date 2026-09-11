export PATH="~/arm-linux-musleabi-cross/bin:$PATH"

mkdir ~/build-curl & cd ~/build-curl
curl -o mbedtls-2.28.8.tar.gz https://github.com/Mbed-TLS/mbedtls/archive/refs/tags/v2.28.8.tar.gz
tar -zxf mbedtls-2.28.8.tar.gz
cd mbedtls-2.28.8/library
make -j$(nproc) CC=arm-linux-musleabi-gcc AR=arm-linux-musleabi-ar CFLAGS="-O2 -fPIC"
mkdir -p /root/build-curl/mbedtls_install/include /root/build-curl/mbedtls_install/lib
cp -r ../include/mbedtls /root/build-curl/mbedtls_install/include/
cp libmbed*.a /root/build-curl/mbedtls_install/lib/

cd ~/build-curl
curl -O https://curl.se/download/curl-8.7.1.tar.gz
tar -zxf curl-8.7.1.tar.gz
cd curl-8.7.1
./configure \
  --host=arm-linux-musleabi \
  CC=arm-linux-musleabi-gcc \
  CFLAGS="-O2 -static" \
  LDFLAGS="-static -L/root/build-curl/mbedtls_install/lib" \
  LIBS="-lmbedtls -lmbedx509 -lmbedcrypto" \
  --with-mbedtls=/root/build-curl/mbedtls_install \
  --enable-static \
  --disable-shared \
  --disable-ldap \
  --disable-rtsp \
  --disable-dict \
  --disable-telnet \
  --disable-tftp \
  --disable-pop3 \
  --disable-imap \
  --disable-smtp \
  --disable-gopher \
  --disable-manual \
  --without-zlib

make -j$(nproc)
cd ~/build-curl/curl-8.7.1/src
rm -f curl .libs/curl
make curl_LDFLAGS="-all-static"
arm-linux-gnueabi-strip curl

# root@ldq-hk-dog:~/build-curl/curl-8.7.1# file src/curl
# src/curl: ELF 32-bit LSB pie executable, ARM, EABI5 version 1 (SYSV), static-pie linked, with debug_info, not stripped