rm -d module.modulemap

echo framework module Clibavif { >> module.modulemap
echo "umbrella header \"avif.h\"" >> module.modulemap
echo "export *"  >> module.modulemap
echo "}" >> module.modulemap


lib_list=""

dest=macos-x86_64
target=macos

rm -d -r ext/aom/build.libavif
rm -d -r build

mkdir ext/aom/build.libavif
mkdir build

cd ext/aom/build.libavif

cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DENABLE_DOCS=0 -DENABLE_EXAMPLES=0 -DENABLE_TESTDATA=0 -DENABLE_TESTS=0 -DENABLE_TOOLS=0 -DCMAKE_CXX_FLAGS="-mmacosx-version-min=10.13" -DCMAKE_C_FLAGS="-mmacosx-version-min=10.13" -DCMAKE_SYSTEM_PROCESSOR=x86_64 -DCMAKE_OSX_ARCHITECTURES=x86_64 -DCMAKE_OSX_SYSROOT=macosx ..
ninja

cd ../../../build
cmake .. -GNinja -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DAVIF_CODEC_AOM=ON -DAVIF_LOCAL_AOM=ON -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_CXX_FLAGS="-mmacosx-version-min=10.13" -DCMAKE_C_FLAGS="-mmacosx-version-min=10.13" -DCMAKE_SYSTEM_PROCESSOR=x86_64 -DCMAKE_OSX_ARCHITECTURES=x86_64 -DCMAKE_OSX_SYSROOT=macosx
ninja
cd ..

libtool -static -o Clibavif-$dest ./ext/aom/build.libavif/libaom.a ./build/libavif.a
lib_list="${lib_list} Clibavif-$dest"
echo "Created: " $lib_list

dest=macos-arm64

rm -d -r ext/aom/build.libavif
rm -d -r build

mkdir ext/aom/build.libavif
mkdir build

cd ext/aom/build.libavif

cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DENABLE_DOCS=0 -DENABLE_EXAMPLES=0 -DENABLE_TESTDATA=0 -DENABLE_TESTS=0 -DENABLE_TOOLS=0 -DCMAKE_CXX_FLAGS="-mmacosx-version-min=10.13" -DCMAKE_C_FLAGS="-mmacosx-version-min=10.13" -DCMAKE_SYSTEM_PROCESSOR=arm64 -DCMAKE_OSX_ARCHITECTURES=arm64 -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_OSX_SYSROOT=macosx -DCONFIG_RUNTIME_CPU_DETECT=0 ..
ninja

cd ../../../build
cmake .. -GNinja -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DAVIF_CODEC_AOM=ON -DAVIF_LOCAL_AOM=ON -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_CXX_FLAGS="-mmacosx-version-min=10.13" -DCMAKE_C_FLAGS="-mmacosx-version-min=10.13" -DCMAKE_SYSTEM_PROCESSOR=arm64 -DCMAKE_OSX_ARCHITECTURES=arm64 -DCMAKE_OSX_SYSROOT=macosx
ninja
cd ..

libtool -static -o Clibavif-$dest ./ext/aom/build.libavif/libaom.a ./build/libavif.a
lib_list="${lib_list} Clibavif-$dest"
echo "Created: " $lib_list

lipo -create ${lib_list} -output Clibavif

mkdir -p $target/Clibavif.framework
mv Clibavif $target/Clibavif.framework/Clibavif
mkdir -p $target/Clibavif.framework/Headers
cp ./include/avif/avif.h $target/Clibavif.framework/Headers/avif.h
mkdir -p $target/Clibavif.framework/Modules
cp module.modulemap $target/Clibavif.framework/Modules

rm -d -r ext/aom/build.libavif
rm -d -r build


mkdir ext/aom/build.libavif
mkdir build

cd ext/aom/build.libavif

cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DENABLE_DOCS=0 -DENABLE_EXAMPLES=0 -DENABLE_TESTDATA=0 -DENABLE_TESTS=0 -DENABLE_TOOLS=0 -DCMAKE_CXX_FLAGS="-miphoneos-version-min=12.0 -fembed-bitcode" -DCMAKE_C_FLAGS="-miphoneos-version-min=12.0 -fembed-bitcode" -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_OSX_SYSROOT=iphoneos -DCMAKE_SYSTEM_PROCESSOR=arm64 -DCMAKE_OSX_ARCHITECTURES=arm64 -DCONFIG_RUNTIME_CPU_DETECT=0 ..
ninja
cd ../../../build
cmake .. -GNinja -DCMAKE_SYSTEM_PROCESSOR=arm64 -DCMAKE_OSX_ARCHITECTURES=arm64 -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DAVIF_CODEC_AOM=ON -DAVIF_LOCAL_AOM=ON -DCMAKE_SYSTEM_NAME=iOS -DCMAKE_OSX_SYSROOT=iphoneos -DCMAKE_CXX_FLAGS="-miphoneos-version-min=12.0 -fembed-bitcode" -DCMAKE_C_FLAGS="-miphoneos-version-min=12.0 -fembed-bitcode"
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

echo "Built " $dest

dest=iphonesimulator-arm64
target=iphonesimulator

rm -d -r ext/aom/build.libavif
rm -d -r build


mkdir ext/aom/build.libavif
mkdir build

cd ext/aom/build.libavif

lib_list=""

cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DENABLE_DOCS=0 -DENABLE_EXAMPLES=0 -DENABLE_TESTDATA=0 -DENABLE_TESTS=0 -DENABLE_TOOLS=0 -DCMAKE_CXX_FLAGS="-mios-simulator-version-min=12.0" -DCMAKE_C_FLAGS="-mios-simulator-version-min=12.0" -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_OSX_SYSROOT=iphonesimulator -DCMAKE_SYSTEM_PROCESSOR=arm64 -DCMAKE_OSX_ARCHITECTURES=arm64 -DCONFIG_RUNTIME_CPU_DETECT=0 ..
ninja
cd ../../../build
cmake .. -GNinja -DCMAKE_SYSTEM_PROCESSOR=arm64 -DCMAKE_OSX_ARCHITECTURES=arm64 -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DAVIF_CODEC_AOM=ON -DAVIF_LOCAL_AOM=ON -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_OSX_SYSROOT=iphonesimulator -DCMAKE_CXX_FLAGS="-mios-simulator-version-min=12.0" -DCMAKE_C_FLAGS="-mios-simulator-version-min=12.0"
ninja

cd ..

libtool -static -o Clibavif-$dest ./ext/aom/build.libavif/libaom.a ./build/libavif.a
lib_list="${lib_list} Clibavif-$dest"
echo "Created: " $lib_list

dest=iphonesimulator-x86_64

rm -d -r ext/aom/build.libavif
rm -d -r build


mkdir ext/aom/build.libavif
mkdir build

cd ext/aom/build.libavif

cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DENABLE_DOCS=0 -DENABLE_EXAMPLES=0 -DENABLE_TESTDATA=0 -DENABLE_TESTS=0 -DENABLE_TOOLS=0 -DCMAKE_CXX_FLAGS="-mios-simulator-version-min=12.0" -DCMAKE_C_FLAGS="-mios-simulator-version-min=12.0" -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_OSX_SYSROOT=iphonesimulator -DCMAKE_SYSTEM_PROCESSOR=x86_64 -DCMAKE_OSX_ARCHITECTURES=x86_64 ..
ninja
cd ../../../build
cmake .. -GNinja -DCMAKE_SYSTEM_PROCESSOR=x86_64 -DCMAKE_OSX_ARCHITECTURES=x86_64 -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DAVIF_CODEC_AOM=ON -DAVIF_LOCAL_AOM=ON -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_OSX_SYSROOT=iphonesimulator -DCMAKE_CXX_FLAGS="-mios-simulator-version-min=12.0" -DCMAKE_C_FLAGS="-mios-simulator-version-min=12.0"
ninja

cd ..

libtool -static -o Clibavif-$dest ./ext/aom/build.libavif/libaom.a ./build/libavif.a
lib_list="${lib_list} Clibavif-$dest"
echo "Created: " $lib_list

lipo -create ${lib_list} -output Clibavif

mkdir -p $target/Clibavif.framework
mv Clibavif $target/Clibavif.framework/Clibavif
mkdir -p $target/Clibavif.framework/Headers
cp ./include/avif/avif.h $target/Clibavif.framework/Headers/avif.h
mkdir -p $target/Clibavif.framework/Modules
cp module.modulemap $target/Clibavif.framework/Modules



dest=maccatalyst-x86_64
target=maccatalyst

rm -d -r ext/aom/build.libavif
rm -d -r build


mkdir ext/aom/build.libavif
mkdir build

cd ext/aom/build.libavif

lib_list=""

flags="-miphoneos-version-min=13.0 -target x86_64-apple-ios13.0-macabi"

cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DENABLE_DOCS=0 -DENABLE_EXAMPLES=0 -DENABLE_TESTDATA=0 -DENABLE_TESTS=0 -DENABLE_TOOLS=0 -DCMAKE_CXX_FLAGS="$flags" -DCMAKE_C_FLAGS="$flags" -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_OSX_SYSROOT=macosx -DCMAKE_SYSTEM_PROCESSOR=x86_64 -DCMAKE_OSX_ARCHITECTURES=x86_64 -DASMFLAGS=$flags ..
ninja
cd ../../../build
cmake .. -GNinja -DCMAKE_SYSTEM_PROCESSOR=x86_64 -DCMAKE_OSX_ARCHITECTURES=x86_64 -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DAVIF_CODEC_AOM=ON -DAVIF_LOCAL_AOM=ON -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_OSX_SYSROOT=macosx -DCMAKE_CXX_FLAGS="$flags" -DCMAKE_C_FLAGS="$flags"
ninja

cd ..

libtool -static -o Clibavif-$dest ./ext/aom/build.libavif/libaom.a ./build/libavif.a
lib_list="${lib_list} Clibavif-$dest"
echo "Created: " $lib_list

dest=maccatalyst-arm64

rm -d -r ext/aom/build.libavif
rm -d -r build


mkdir ext/aom/build.libavif
mkdir build

cd ext/aom/build.libavif

flags="-miphoneos-version-min=13.0 -target arm64-apple-ios13.0-macabi"

cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DENABLE_DOCS=0 -DENABLE_EXAMPLES=0 -DENABLE_TESTDATA=0 -DENABLE_TESTS=0 -DENABLE_TOOLS=0 -DCMAKE_CXX_FLAGS="$flags" -DCMAKE_C_FLAGS="$flags" -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_OSX_SYSROOT=macosx -DCMAKE_SYSTEM_PROCESSOR=arm64 -DCMAKE_OSX_ARCHITECTURES=arm64 -DCONFIG_RUNTIME_CPU_DETECT=0 ..
ninja
cd ../../../build
cmake .. -GNinja -DCMAKE_SYSTEM_PROCESSOR=arm64 -DCMAKE_OSX_ARCHITECTURES=arm64 -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DAVIF_CODEC_AOM=ON -DAVIF_LOCAL_AOM=ON -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_OSX_SYSROOT=macosx -DCMAKE_CXX_FLAGS="$flags" -DCMAKE_C_FLAGS="$flags"
ninja

cd ..

libtool -static -o Clibavif-$dest ./ext/aom/build.libavif/libaom.a ./build/libavif.a
lib_list="${lib_list} Clibavif-$dest"
echo "Created: " $lib_list

lipo -create ${lib_list} -output Clibavif

mkdir -p $target/Clibavif.framework
mv Clibavif $target/Clibavif.framework/Clibavif
mkdir -p $target/Clibavif.framework/Headers
cp ./include/avif/avif.h $target/Clibavif.framework/Headers/avif.h
mkdir -p $target/Clibavif.framework/Modules
cp module.modulemap $target/Clibavif.framework/Modules


xcodebuild -create-xcframework -framework ./macos/Clibavif.framework -framework ./ios-arm64/Clibavif.framework -framework ./iphonesimulator/Clibavif.framework -framework ./maccatalyst/Clibavif.framework -output Clibavif.xcframework

