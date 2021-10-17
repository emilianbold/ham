#!/bin/bash

# toolset
export HAM_TOOLSET=JAVA_JDK
export HAM_TOOLSET_VER=11
export HAM_TOOLSET_NAME=java_jdk_11
export HAM_TOOLSET_DIR="${HAM_HOME}/toolsets/java_jdk_11"

# path setup
case $HAM_OS in
    OSX)
        if [ "$HAM_BIN_LOA" == "osx-arm64" ]; then
            export JAVA_HOME="/opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk/Contents/Home/"
            if [ ! -e "$JAVA_HOME/bin/java" ]; then
                echo "W/Couldn't find openjdk@11's java, trying to install with brew"
                brew install openjdk@11
            fi
            export PATH="${JAVA_HOME}/bin":${PATH}
        else
            toolset_check_and_dl_ver java_jdk_11 $HAM_BIN_LOA v11_0_12 || return 1
            export JAVA_HOME="${HAM_TOOLSET_DIR}/$HAM_BIN_LOA/"
        fi
        ;;
    *)
        echo "E/Toolset: Unsupported host OS"
        return 1
        ;;
esac

VER="--- java_jdk_11 ------------------------"
if [ "$HAM_NO_VER_CHECK" != "1" ]; then
    VER="$VER
--- java ---
`java -version 2>&1`
--- javac ---
`javac -version 2>&1`"
    if [ $? != 0 ]; then
        echo "E/Can't get Java version."
        return 1
    fi
fi

export HAM_TOOLSET_VERSIONS="$HAM_TOOLSET_VERSIONS
$VER"
