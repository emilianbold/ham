#!/bin/bash

# These are needed by gyp to build native nodejs modules
toolset_import_once default || return 1
toolset_import_once python_36 || return 1

# toolset
export HAM_TOOLSET=NODEJS
export HAM_TOOLSET_NAME=nodejs
export HAM_TOOLSET_DIR="${HAM_HOME}/toolsets/nodejs"

# We use a tag file to mark the version so that upgrades are automatically handled when we update the version number
NODEJS_DL_VER=v16.14.2
NODEJS_DL_TAG=$( echo ${NODEJS_DL_VER} | tr '.' '_' )
export NODEJS_DIR="${HAM_TOOLSET_DIR}/${HAM_BIN_LOA}"
case "$HAM_BIN_LOA" in
    nt-x86)
        # Absolutely obnoxious, why would you use a different folder structure only on Windows??
        export NODEJS_BIN_DIR="${NODEJS_DIR}"
        export NODEJS_GLOBAL_MODULES_DIR="${NODEJS_DIR}/node_modules"
        ;;
    *)
        export NODEJS_BIN_DIR="${NODEJS_DIR}/bin"
        export NODEJS_GLOBAL_MODULES_DIR="${NODEJS_DIR}/lib/node_modules"
        ;;
esac
export NODE_PATH=$NODEJS_GLOBAL_MODULES_DIR

export PATH=${HAM_TOOLSET_DIR}:"${NODEJS_BIN_DIR}":${PATH}
if [ ! -f "$NODEJS_DIR/$NODEJS_DL_TAG" ]; then
    echo "W/Couldn't find node, installing from the nodejs.org dist package..."
    case "$HAM_BIN_LOA" in
        nt-x86)
            NODEJS_DL_NAME="node-${NODEJS_DL_VER}-win-x64"
            NODEJS_DL_FN="${NODEJS_DL_NAME}.zip"
            ;;
        osx-x64)
            NODEJS_DL_NAME="node-${NODEJS_DL_VER}-darwin-x64"
            NODEJS_DL_FN="${NODEJS_DL_NAME}.tar.gz"
            ;;
        osx-arm64)
            NODEJS_DL_NAME="node-${NODEJS_DL_VER}-darwin-arm64"
            NODEJS_DL_FN="${NODEJS_DL_NAME}.tar.gz"
            ;;
        lin-x64)
            NODEJS_DL_NAME="node-${NODEJS_DL_VER}-linux-x64"
            NODEJS_DL_FN="${NODEJS_DL_NAME}.tar.xz"
            ;;
        *)
            complain nodejs_toolset "Unsupported arch '$HAM_BIN_LOA'."
            return 1;
            ;;
    esac
    NODEJS_DL_URL="https://nodejs.org/dist/${NODEJS_DL_VER}/${NODEJS_DL_FN}"
    NODEJS_DL_DEST="${HAM_HOME}/toolsets/_dl/${NODEJS_DL_FN}"
    (set -ex ;
     rm -Rf "$NODEJS_DIR" ;
     curl "$NODEJS_DL_URL" -o "${NODEJS_DL_DEST}" ;
     tar xf "${NODEJS_DL_DEST}" -C "${HAM_TOOLSET_DIR}" ;
     mv "${HAM_TOOLSET_DIR}/${NODEJS_DL_NAME}" "${NODEJS_DIR}" ;
     rm "${NODEJS_DL_DEST}" )
    if [ ! -f "$NODEJS_BIN_DIR/node" ]; then
        echo "E/'node' not found after unpacking the archive '%{NODEJS_DL_URL}'"
        return 1
    fi
    if [ ! -f "$NODEJS_BIN_DIR/npm" ]; then
        echo "E/'npm' not found after unpacking the archive '%{NODEJS_DL_URL}'"
        return 1
    fi
    # Output the tag file
    echo "$NODEJS_DL_VER" > "$NODEJS_DIR/$NODEJS_DL_TAG"
fi
chmod +x "$NODEJS_BIN_DIR/"*

# Install any missing global node tools
npm-install-global-deps

VER="--- nodejs ------------------------
`node --version`
--- npm ---------------------------
`npm --version`
--- yarn --------------------------
`yarn --version`
--- esbuild -----------------------
`esbuild --version`"
if [ $? != 0 ]; then
    echo "E/Can't get version."
    return 1
fi
export HAM_TOOLSET_VERSIONS="$HAM_TOOLSET_VERSIONS
$VER"
