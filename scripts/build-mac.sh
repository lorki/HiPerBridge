#/bin/sh
# 请在项目文件夹内执行这个脚本构建可用的 .app 通用程序
echo $*

if [ $1 == "--debug" ]
then
    echo "WARNING: You are using debug mode!"
    BUILD_ARGS=""
else
    BUILD_ARGS="--release -Z build-std=core,alloc,std,panic_abort -Z build-std-features=panic_immediate_abort"
fi

echo "Building ARM binary"
rustup default nightly-aarch64-apple-darwin
cargo +nightly build ${BUILD_ARGS} --target aarch64-apple-darwin
echo "Building X86_64 binary"
rustup default nightly-x86_64-apple-darwin
cargo +nightly build ${BUILD_ARGS} --target x86_64-apple-darwin

rustup default stable

rm -rf "./target/NetCha.app"

mkdir "./target/NetCha.app"
mkdir "./target/NetCha.app/Contents"
mkdir "./target/NetCha.app/Contents/MacOS"
mkdir "./target/NetCha.app/Contents/Resources"

iconutil --convert icns --output "./assets/mac-icons/HBLight.icns" "./assets/mac-icons/HBLight.iconset"

cp "./assets/Info.plist" "./target/NetCha.app/Contents/Info.plist"
cp "./assets/mac-icons/HBLight.icns" "./target/NetCha.app/Contents/Resources/AppIcon.icns"

if [ $1 == "--debug" ]
then
    lipo -create -output "./target/NetCha.app/Contents/MacOS/NetCha" \
        "./target/aarch64-apple-darwin/debug/net-cha" \
        "./target/x86_64-apple-darwin/debug/net-cha"
else
    lipo -create -output "./target/NetCha.app/Contents/MacOS/NetCha" \
        "./target/aarch64-apple-darwin/release/net-cha" \
        "./target/x86_64-apple-darwin/release/net-cha"
fi

# Setup Root
chmod 4777 "./target/NetCha.app/Contents/MacOS/NetCha"

tar -c -z -f "./target/NetCHa-universal-darwin.tar.gz" "./target/NetCha.app"
