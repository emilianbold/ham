#!/bin/bash

toolset_import xslt_tools
if [ $? != 0 ]; then return 1; fi
toolset_import python_26
if [ $? != 0 ]; then return 1; fi

# toolset
export HAM_TOOLSET_IS_SETUP_FLASCC=1
export HAM_TOOLSET=FLASCC
export HAM_TOOLSET_VER=1
export HAM_TOOLSET_NAME=flascc
export HAM_TOOLSET_DIR=${HAM_HOME}/toolsets/flascc

export JAVA_HOME=${HAM_TOOLSET_DIR}/nt-x86/jre64
export PATH=${JAVA_HOME}/bin:${PATH}

export FLEX=${HAM_TOOLSET_DIR}/flex_sdk
export FLASCC_ROOT=${HAM_TOOLSET_DIR}/nt-x86/
export FLASCC=${HAM_TOOLSET_DIR}/nt-x86/sdk
export GCCDIR=${HAM_TOOLSET_DIR}/nt-x86/sdk/usr

# path setup
case $HAM_OS in
    NT*)
        export PATH=${GCCDIR}/bin:${PATH}:${FLASCC_ROOT}/bin:${FLASCC_ROOT}/cygwin/bin:${FLEX}/bin:${FLASCC_ROOT}/mtasc:${FLASCC_ROOT}/libming/bin:${FLEX}/runtimes/player/11.1/win
        if [ ! -e $GCCDIR ] || [ -z `type -P gcc` ]; then
            toolset_dl flascc flascc_nt-x86
            if [ ! -e $GCCDIR ] || [ -z `type -P gcc` ]; then
                echo "E/nt-x86 folder doesn't exist in the toolset"
                return 1
            fi
        fi
        export FLASCC_GDB_RUNTIME="${FLEX}/runtimes/player/11.1/win/FlashPlayerDebugger.exe"
        ;;
    *)
        echo "E/Toolset: Unsupported host OS"
        return 1
        ;;
esac

VER="--- flascc ------------------------
--- java ---
`java -version 2>&1`
--- gcc ---
`gcc --version`"
if [ $? != 0 ]; then
    echo "E/Can't get version."
    return 1
fi
export HAM_TOOLSET_VERSIONS="$HAM_TOOLSET_VERSIONS
$VER"
