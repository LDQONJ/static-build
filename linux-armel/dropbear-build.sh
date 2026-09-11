apt update && apt install -y build-essential gcc-arm-linux-gnueabi bzip2 curl
cd ~
tar -xzf arm-linux-musleabi-cross.tgz
curl -O https://musl.cc/arm-linux-musleabi-cross.tgz

curl -O https://dropbear.nl/mirror/releases/dropbear-2026.94.tar.bz2
tar -xjf dropbear-2026.94.tar.bz2
cd dropbear-2024.86

# 关闭 shell 检查，不然会报错：User 'root' has invalid shell, rejected
sed -i '/\/\* no matching shell \*\//a \\tgoto goodshell;' src/svr-auth.c

./configure --host=arm-linux-musleabi \
  CC=~/arm-linux-musleabi-cross/bin/arm-linux-musleabi-gcc \
  --disable-zlib \
  --enable-static

make PROGRAMS="dropbear dropbearkey" STATIC=1
arm-linux-gnueabi-strip ~/dropbear-2026.94/dropbear
arm-linux-gnueabi-strip ~/dropbear-2026.94/dropbearkey

# root@ldq-hk-dog:~# file ~/dropbear-2026.94/dropbear
# dropbear: ELF 32-bit LSB pie executable, ARM, EABI5 version 1 (SYSV), static-pie linked, with debug_info, not stripped