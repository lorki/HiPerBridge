#/bin/sh
# 通过这个来在构建的同时安装程序
sh ./scripts/install-mac.sh $*

if [ $1 == "--debug" ]
then
    "/Applications/NetCha.app/Contents/MacOS/NetCha"
else
    run "/Applications/NetCha.app"
fi