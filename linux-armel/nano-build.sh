export CROSS_COMPILE=arm-linux-gnueabi-
export CC=${CROSS_COMPILE}gcc
export CXX=${CROSS_COMPILE}g++
export AR=${CROSS_COMPILE}ar
export RANLIB=${CROSS_COMPILE}ranlib
export INSTALL_DIR=$(pwd)/arm-nano-install

mkdir -p ~/build-nano & cd ~/build-nano
curl -O https://invisible-island.net/datafiles/release/ncurses.tar.gz
tar -zxvf ncurses.tar.gz && cd ncurses-*
./configure \
  --host=arm-linux-musleabi \
  --prefix=/root/arm-nano-musl \
  --enable-widec \
  --without-shared \
  --with-normal \
  --without-debug \
  --without-ada \
  --without-manpages
make -j$(nproc) && make install

cd ~/build-nano
curl -O https://www.nano-editor.org/dist/v7/nano-7.2.tar.xz
tar -Jxvf nano-7.2.tar.xz && cd nano-7.2
./configure \
  --host=arm-linux-musleabi \
  --prefix=/opt/upt/apps \
  --enable-utf8 \
  CPPFLAGS="-I/root/arm-nano-musl/include -I/root/arm-nano-musl/include/ncursesw" \
  LDFLAGS="-L/root/arm-nano-musl/lib -static" \
  LIBS="-lncursesw"
make LDFLAGS="-all-static" -j$(nproc)
${CROSS_COMPILE}strip src/nano
cd ~/build-nano/nano-7.2/src
arm-linux-gnueabi-gcc -g -O2 -Wall -static -o nano \
  browser.o chars.o color.o cut.o files.o global.o help.o history.o \
  move.o nano.o prompt.o rcfile.o search.o text.o utils.o winio.o \
  ../lib/libgnu.a -L/root/arm-nano-install/lib -lncursesw
make -C lib -j$(nproc)
make -C src -j$(nproc)
arm-linux-gnueabi-strip nano

TI_BASE=$(find /lib/terminfo /usr/share/terminfo -name "xterm-256color" 2>/dev/null | head -n 1 | sed 's|/x/xterm-256color||')
mkdir -p /tmp/mini-terminfo/x /tmp/mini-terminfo/l /tmp/mini-terminfo/v
cp "$TI_BASE/x/xterm-256color" /tmp/mini-terminfo/x/ 2>/dev/null || true
cp "$TI_BASE/x/xterm" /tmp/mini-terminfo/x/ 2>/dev/null || true
cp "$TI_BASE/l/linux" /tmp/mini-terminfo/l/ 2>/dev/null || true
cp "$TI_BASE/v/vt100" /tmp/mini-terminfo/v/ 2>/dev/null || true
tar -czf /tmp/terminfo.tar.gz -C /tmp/mini-terminfo .
cd /root/nano-7.2/syntax
tar -czf /tmp/nano-syntax.tar.gz *.nanorc