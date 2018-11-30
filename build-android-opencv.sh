#!/usr/bin/env sh

# 功能：
# 编译arm64和armeabi-v7a版本的opencv with contrib
# 会将结果安装到opencv
#
# Author: jefby
# Date: 2018.11.21

#NDK_ROOT="${1:-${NDK_ROOT}}"
NDK_ROOT=${ANDROID_NDK_ROOT}
if [ -z ${NDK_ROOT} ];then
    echo “NDK_ROOT is empty!!” 
    exit
fi


### ABI setup
#ANDROID_ABI=${ANDROID_ABI:-"armeabi-v7a with NEON"}
#ANDROID_ABI=${ANDROID_ABI:-"x86"}
#ANDROID_ABI=${ANDROID_ABI:-"x86_64"}
declare -a ANDROID_ABI_LIST=("arm64-v8a" "armeabi-v7a with NEON")

### path setup
SCRIPT=$(readlink -f $0)
WD=`dirname $SCRIPT`
OPENCV_ROOT=${WD}/opencv

BUILD_DIR=$OPENCV_ROOT/platforms/build_android
INSTALL_DIR=${WD}/android_opencv
N_JOBS=${N_JOBS:-8}


rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"


# First argument is abi type (armeabi-v7a, x86)
function build_opencv {
  ABI=$1

  if [ "${ABI}" = "armeabi" ]; then
    API_LEVEL=19
  else
    API_LEVEL=21
  fi


  echo "Building Opencv for $ABI"
  mkdir build_$ABI
  pushd build_$ABI
  
# collect install directories to build/install
  cmake -D CMAKE_BUILD_WITH_INSTALL_RPATH=ON \
      -D ANDROID_STL=c++_shared \
      -D CMAKE_TOOLCHAIN_FILE="${NDK_ROOT}/build/cmake/android.toolchain.cmake" \
      -D ANDROID_NDK="${NDK_ROOT}" \
      -D ANDROID_NATIVE_API_LEVEL=${API_LEVEL} \
      -D ANDROID_ARM_NEON=ON \
      -D ANDROID_ABI="$ABI" \
      -D WITH_CUDA=OFF \
      -D WITH_MATLAB=OFF \
      -D BUILD_ANDROID_EXAMPLES=OFF \
      -D BUILD_DOCS=OFF \
      -D BUILD_PERF_TESTS=OFF \
      -D BUILD_TESTS=OFF \
      -D OPENCV_EXTRA_MODULES_PATH="${WD}/opencv_contrib/modules/"  \
      -D CMAKE_INSTALL_PREFIX="${INSTALL_DIR}/opencv" \
      -D BUILD_ANDROID_PROJECTS=OFF \
      -D CMAKE_CXX_FLAGS="${CMAKE_CXX_FLAGS} -O3 -Wall" \
      -D CMAKE_BUILD_TYPE=Release \
      ../../..
  make -j${N_JOBS}
  make install/strip

  popd
}

build_opencv armeabi-v7a
build_opencv arm64-v8a


cd "${WD}"
rm -rf "${BUILD_DIR}"
