#!/usr/bin/env sh
#NDK_ROOT="${1:-${NDK_ROOT}}"
NDK_ROOT=${ANDROID_NDK_ROOT}


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

if [ "${ANDROID_ABI}" = "armeabi" ]; then
    API_LEVEL=19
else
    API_LEVEL=21
fi

rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"


# First argument is abi type (armeabi-v7a, x86)
function build_opencv {
  ABI=$1

  pushd opencv

  echo "Building Opencv for $ABI"
  mkdir build_$ABI
  pushd build_$ABI
  
# collect install directories to build/install
  cmake -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
      -DCMAKE_TOOLCHAIN_FILE="${NDK_ROOT}/build/cmake/android.toolchain.cmake" \
      -DANDROID_NDK="${NDK_ROOT}" \
      -DANDROID_NATIVE_API_LEVEL=${API_LEVEL} \
      -DANDROID_ARM_NEON=ON \
      -DANDROID_ABI="$ABI" \
      -D WITH_CUDA=OFF \
      -D WITH_MATLAB=OFF \
      -D BUILD_ANDROID_EXAMPLES=OFF \
      -D BUILD_DOCS=OFF \
      -D BUILD_PERF_TESTS=OFF \
      -D BUILD_TESTS=OFF \
      -DOPENCV_EXTRA_MODULES_PATH="${WD}/opencv_contrib/modules/"  \
      -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}/opencv" \
      -D BUILD_ANDROID_PROJECTS=OFF \
      ../../..
  make -j${N_JOBS}
  make install/strip

  popd
  popd
}

build_opencv armeabi-v7a
build_opencv arm64-v8a


cd "${WD}"
rm -rf "${BUILD_DIR}"
