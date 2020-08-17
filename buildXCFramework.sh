echo framework module Clibavif { >> module.modulemap
echo "umbrella header \"avif.h\"" >> module.modulemap
echo "export *"  >> module.modulemap
echo "}" >> module.modulemap


dest=macos-x86_64

rm -d -r ext/aom/build.libavif
rm -d -r build

mkdir ext/aom/build.libavif
mkdir build

cd ext/aom/build.libavif

cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DENABLE_DOCS=0 -DENABLE_EXAMPLES=0 -DENABLE_TESTDATA=0 -DENABLE_TESTS=0 -DENABLE_TOOLS=0 -DCMAKE_CXX_FLAGS="-mmacosx-version-min=10.13" -DCMAKE_C_FLAGS="-mmacosx-version-min=10.13" ..
ninja

cd ../../../build
cmake .. -GNinja -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DAVIF_CODEC_AOM=ON -DAVIF_LOCAL_AOM=ON -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_CXX_FLAGS="-mmacosx-version-min=10.13" -DCMAKE_C_FLAGS="-mmacosx-version-min=10.13"
ninja
cd ..

libtool -static -o Clibavif ./ext/aom/build.libavif/libaom.a ./build/libavif.a

mkdir -p $dest/Clibavif.framework
mv Clibavif $dest/Clibavif.framework/Clibavif
mkdir -p $dest/Clibavif.framework/Headers
cp ./include/avif/avif.h $dest/Clibavif.framework/Headers/avif.h
mkdir -p $dest/Clibavif.framework/Modules
cp module.modulemap $dest/Clibavif.framework/Modules


rm -d -r ext/aom/build.libavif
rm -d -r build

mkdir ext/aom/build.libavif
mkdir build

cd ext/aom/build.libavif

cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DENABLE_DOCS=0 -DENABLE_EXAMPLES=0 -DENABLE_TESTDATA=0 -DENABLE_TESTS=0 -DENABLE_TOOLS=0 -DCMAKE_TOOLCHAIN_FILE=../build/cmake/toolchains/x86_64-ios-simulator.cmake ..
ninja
cd ../../../build
cmake .. -GNinja -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DAVIF_CODEC_AOM=ON -DAVIF_LOCAL_AOM=ON -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_OSX_SYSROOT=iphonesimulator -DCMAKE_SYSTEM_PROCESSOR=x86_64 -DCMAKE_OSX_ARCHITECTURES=x86_64
ninja

cd ..
libtool -static -o Clibavif ./ext/aom/build.libavif/libaom.a ./build/libavif.a

dest=ios_x86_64-simulator

mkdir -p $dest/Clibavif.framework
mv Clibavif $dest/Clibavif.framework/Clibavif
mkdir -p $dest/Clibavif.framework/Headers
cp ./include/avif/avif.h $dest/Clibavif.framework/Headers/avif.h
mkdir -p $dest/Clibavif.framework/Modules
cp module.modulemap $dest/Clibavif.framework/Modules

rm -d -r ext/aom/build.libavif
rm -d -r build


mkdir ext/aom/build.libavif
mkdir build

cd ext/aom/build.libavif

cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DENABLE_DOCS=0 -DENABLE_EXAMPLES=0 -DENABLE_TESTDATA=0 -DENABLE_TESTS=0 -DENABLE_TOOLS=0 -DCMAKE_TOOLCHAIN_FILE=../build/cmake/toolchains/arm64-ios.cmake -DCMAKE_CXX_FLAGS="-miphoneos-version-min=12.0 -fembed-bitcode" -DCMAKE_C_FLAGS="-miphoneos-version-min=12.0 -fembed-bitcode" ..
ninja
cd ../../../build
cmake .. -GNinja -DCMAKE_SYSTEM_PROCESSOR=arm64 -DCMAKE_OSX_ARCHITECTURES=arm64 -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DAVIF_CODEC_AOM=ON -DAVIF_LOCAL_AOM=ON -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_OSX_SYSROOT=iphoneos -DCMAKE_CXX_FLAGS="-miphoneos-version-min=12.0 -fembed-bitcode" -DCMAKE_C_FLAGS="-miphoneos-version-min=12.0 -fembed-bitcode"
ninja

cd ..
libtool -static -o Clibavif ./ext/aom/build.libavif/libaom.a ./build/libavif.a

dest=ios-arm64

mkdir -p $dest/Clibavif.framework
mv Clibavif $dest/Clibavif.framework/Clibavif
mkdir -p $dest/Clibavif.framework/Headers
cp ./include/avif/avif.h $dest/Clibavif.framework/Headers/avif.h
mkdir -p $dest/Clibavif.framework/Modules
cp module.modulemap $dest/Clibavif.framework/Modules

rm -d -r ext/aom/build.libavif
rm -d -r build

mkdir ext/aom/build.libavif
mkdir build

cd ext/aom/build.libavif

cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DENABLE_DOCS=0 -DENABLE_EXAMPLES=0 -DENABLE_TESTDATA=0 -DENABLE_TESTS=0 -DENABLE_TOOLS=0 -DCMAKE_OSX_ARCHITECTURES=x86_64 -DCMAKE_CXX_FLAGS="-target x86_64-apple-ios13.0-macabi -miphoneos-version-min=13.0" -DCMAKE_C_FLAGS="-target x86_64-apple-ios13.0-macabi -miphoneos-version-min=13.0" -DCMAKE_ASM_FLAGS="-target x86_64-apple-ios13.0-macabi -miphoneos-version-min=13.0" ..

ninja
cd ../../../build
cmake .. -GNinja -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DAVIF_CODEC_AOM=ON -DAVIF_LOCAL_AOM=ON -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_CXX_FLAGS="-target x86_64-apple-ios13.0-macabi -miphoneos-version-min=13.0" -DCMAKE_C_FLAGS="-target x86_64-apple-ios13.0-macabi -miphoneos-version-min=13.0"
ninja

cd ..
libtool -static -o Clibavif ./ext/aom/build.libavif/libaom.a ./build/libavif.a

dest=mac-catalyst

mkdir -p $dest/Clibavif.framework
mv Clibavif $dest/Clibavif.framework/Clibavif
mkdir -p $dest/Clibavif.framework/Headers
cp ./include/avif/avif.h $dest/Clibavif.framework/Headers/avif.h
mkdir -p $dest/Clibavif.framework/Modules
cp module.modulemap $dest/Clibavif.framework/Modules

rm -d -r ext/aom/build.libavif
rm -d -r build




# cmake -GNinja -DCMAKE_OSX_SYSROOT=/Applications/Xcode-beta.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX11.0.sdk -DCMAKE_BUILD_TYPE=Release -DENABLE_DOCS=0 -DENABLE_EXAMPLES=0 -DENABLE_TESTDATA=0 -DENABLE_TESTS=0 -DENABLE_TOOLS=0 -DCMAKE_SYSTEM_PROCESSOR=arm64 -DCMAKE_OSX_ARCHITECTURES=arm64 -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_C_COMPILER_ARG1="-arch arm64" -DCMAKE_CXX_COMPILER_ARG1="-arch arm64" -DCONFIG_RUNTIME_CPU_DETECT=0 ..
# 
# ninja
# cd ../../../build
# 
# cmake .. -GNinja -DCMAKE_SYSTEM_PROCESSOR=arm64 -DCMAKE_OSX_ARCHITECTURES=arm64  -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DAVIF_CODEC_AOM=ON -DAVIF_LOCAL_AOM=ON -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_OSX_SYSROOT=/Applications/Xcode-beta.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX11.0.sdk
# ninja
# cd ..
# libtool -static -o Clibavif ./ext/aom/build.libavif/libaom.a ./build/libavif.a
# 
# mkdir -p macos-arm64/Clibavif.framework
# 
# mv Clibavif macos-arm64/Clibavif.framework/Clibavif
# mkdir -p macos-arm64/Clibavif.framework/Headers
# cp ./include/avif/avif.h macos-arm64/Clibavif.framework/Headers/avif.h
# mkdir -p macos-arm64/Clibavif.framework/Modules
# cp module.modulemap macos-arm64/Clibavif.framework/Modules


xcodebuild -create-xcframework -framework ./macos-x86_64/Clibavif.framework -framework ios_x86_64-simulator/Clibavif.framework -framework ./ios-arm64/Clibavif.framework -framework ./mac-catalyst/Clibavif.framework -output Clibavif.xcframework
