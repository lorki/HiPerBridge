#/bin/sh
# 通过这个来在构建的同时安装程序
sh ./scripts/build-mac.sh $*
rm -rf "/Applications/NetCha.app"
cp -rf "./target/NetCha.app" "/Applications/NetCha.app"
