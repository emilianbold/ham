#!/bin/bash

# import dependencies
toolset_import xslt_tools
if [ $? != 0 ]; then return 1; fi
toolset_import build_jni
if [ $? != 0 ]; then return 1; fi
toolset_import ant
if [ $? != 0 ]; then return 1; fi

# toolset
export HAM_TOOLSET=ANDROID
export HAM_TOOLSET_VER=17
export HAM_TOOLSET_NAME=adr_${ADR_VERSION}_${ADR_CPU_TYPE}
export HAM_TOOLSET_DIR="${HAM_HOME}/toolsets/adr_base"

# adr setup
case $HAM_OS in
    NT)
        export ADR_ROOT_DIR="${HAM_TOOLSET_DIR}/nt-x86"
        export ADR_NDK_PREBUILT=windows
        export ADR_NDK_VERSION=r12b
        export GCC_VER=4.9
        ;;
    OSX)
        export ADR_ROOT_DIR="${HAM_TOOLSET_DIR}/osx-x86"
        export ADR_NDK_PREBUILT=darwin-x86_64
        export ADR_NDK_VERSION=r12b # can't find r10d on google website now.. so we use the same one as windows
        export GCC_VER=4.9
        chmod +x "${HAM_TOOLSET_DIR}/adr-"*
        ;;
    *)
        echo "E/Toolset: Unsupported host OS"
        return 1
        ;;
esac

# dl if missing
if [ ! -e "$ADR_ROOT_DIR"  ]; then
    toolset_dl adr_base adr_base_nt-x86
    if [ ! -e "$ADR_ROOT_DIR" ]; then
        echo "adr_base nt-x86 folder doesn't exist in the toolset"
        return 1
    fi
fi

# Supported Android Platforms
# 42: Android 4.2, 4.2.2    17    JELLY_BEAN_MR1
# 22: Android 2.2.x          8    FROYO
if [ -z "$ADR_VERSION"  ]; then
    echo "E/Android toolset: version not defined !"
    return 1
fi

case $ADR_VERSION in
    50)
        export ADR_SDK_PLATFORM=android-21
        export ADR_NDK_PLATFORM=android-21
        ;;
    42)
        export ADR_SDK_PLATFORM=android-17
        export ADR_NDK_PLATFORM=android-17
        ;;
    22)
        export ADR_SDK_PLATFORM=android-8
        export ADR_NDK_PLATFORM=android-8
        ;;
    *)
        echo "E/Android toolset: Unsupported version: '${ADR_VERSION}' !"
        return 1;
esac

case $ADR_CPU_TYPE in
    arm64)
        export GCC_BASE=aarch64-linux-android
        export GCC_BASE_DIR=${GCC_BASE}
        export ADR_CPU_PROFILE=ARM64v8A
        export ADR_CPU_ABI=arm64-v8a
        ;;
    arm)
        export GCC_BASE=arm-linux-androideabi
        export GCC_BASE_DIR=${GCC_BASE}
        export ADR_CPU_PROFILE=ARMv7A
        export ADR_CPU_ABI=armeabi-v7a
        ;;
    x86)
        export GCC_BASE=i686-linux-android
        export GCC_BASE_DIR=x86
        export ADR_CPU_PROFILE=X86
        export ADR_CPU_ABI=x86
        ;;
    *)
        echo "E/Android toolset: Unsupported CPU: '${ADR_CPU_TYPE}' !"
        return 1
        ;;
esac

export ADR_GCC_OPT=-O2

export ADR_DIR_BASE="${ADR_ROOT_DIR}"
export ADR_DIR_NDK="${ADR_ROOT_DIR}/ndk_${ADR_NDK_VERSION}"
export ADR_DIR_NDK_USR="${ADR_DIR_NDK}/platforms/$ADR_NDK_PLATFORM/arch-${ADR_CPU_TYPE}/usr"

export ADR_SDK_BASE_DIR="${ADR_DIR_BASE}/sdk"

export ADR_SDK_PLATFORM_DIR="${ADR_DIR_BASE}/sdk/platforms/${ADR_SDK_PLATFORM}"
if [ ! -e "$ADR_SDK_PLATFORM_DIR"  ]; then
    echo "E/Android toolset: can't find SDK platform:" ${ADR_SDK_PLATFORM_DIR}
    return 1
fi

export ADR_NDK_PLATFORM_DIR="${ADR_DIR_NDK}/platforms/${ADR_NDK_PLATFORM}"
if [ ! -e "$ADR_NDK_PLATFORM_DIR"  ]; then
    echo "E/Android toolset: can't find NDK platform:" ${ADR_NDK_PLATFORM_DIR}
    return 1
fi
if [ ! -e "$ADR_DIR_NDK_USR"  ]; then
    echo "E/Android toolset: can't find NDK platform for CPU arch:" ${ADR_DIR_NDK_USR}
    return 1
fi

export ADR_SYSTEM_LINKLIBS=""

export CYGWIN=nodosfilewarning # disable awesome cygwin warning...

export GCC_EXE_BASE=${GCC_BASE}-
export GCC_DIR="${ADR_DIR_NDK}/toolchains/${GCC_BASE_DIR}-${GCC_VER}/prebuilt/$ADR_NDK_PREBUILT"
export ADR_LIBGCC_PATH="${GCC_DIR}/lib/gcc/${GCC_BASE_DIR}/${GCC_VER}/libgcc.a"

# macOS has a ld command by default in the path, we need to add our path after the origin one, so it can be found first
export PATH=${PATH}:"${HAM_TOOLSET_DIR}":"${ADR_DIR_BASE}/scripts":"${GCC_DIR}/bin":"${ADR_DIR_BASE}/sdk/tools":"${ADR_DIR_BASE}/sdk/platform-tools"

VER="--- android ------------------------
cpu: $ADR_CPU_PROFILE, $ADR_CPU_ABI
sdk: $ADR_SDK_PLATFORM
ndk: $ADR_NDK_VERSION, $ADR_NDK_PLATFORM, $ADR_NDK_PREBUILT
--- adr-gcc ------------------------
`${GCC_EXE_BASE}gcc --version`"
if [ $? != 0 ]; then
    echo "E/Can't get gcc version."
    return 1
fi

export ADR_LIBCPP_DIR_INCLUDE="$ADR_DIR_NDK/sources/cxx-stl/stlport/stlport"
export ADR_LIBCPP_DIR_LIBS="$ADR_DIR_NDK/sources/cxx-stl/stlport/libs/$ADR_CPU_ABI"
export ADR_LIBCPP_DEFINES="-DANDROID_STLPORT"
export ADR_LIBCPP_LINKER_LIB="-lstlport_static"

export ADR_LLVM_VERSION=3.8
export ADR_LLVM_NAME=llvm
export ADR_LLVM_TOOLCHAIN_ROOT="${ADR_DIR_NDK}/toolchains/${ADR_LLVM_NAME}"
export ADR_LLVM_TOOLCHAIN_PREBUILT_ROOT="${ADR_LLVM_TOOLCHAIN_ROOT}/prebuilt/$ADR_NDK_PREBUILT"
export ADR_LLVM_TOOLCHAIN_PREFIX="${ADR_LLVM_TOOLCHAIN_PREBUILT_ROOT}/bin/"
export PATH="${ADR_LLVM_TOOLCHAIN_PREFIX}":${PATH}

# other IDE like IJ can't find this path cause it was in our toolset.. so is better to leave it as default
# or we need to found a way to set it in the IDE
# export GRADLE_USER_HOME="${ADR_DIR_BASE}/gradle"
export ANDROID_HOME=${ADR_SDK_BASE_DIR}

VER="$VER
--- adr-clang ------------------
`clang --version`"
if [ $? != 0 ]; then
    echo "E/Can't get clang version."
    return 1
fi

export HAM_TOOLSET_VERSIONS="$HAM_TOOLSET_VERSIONS
$VER"
