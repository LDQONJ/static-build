export PATH="/root/arm-linux-musleabi-cross/bin:$PATH"
cd ~
wget -c http://www.greenend.org.uk/rjk/sftpserver/sftpserver-2.tar.gz
tar -xzf sftpserver-2.tar.gz
cd sftpserver-2
./configure \
  --host=arm-linux-musleabi \
  LDFLAGS="-static"
make -j$(nproc)
arm-linux-musleabi-strip gesftpserver
mv gesftpserver sftp-server