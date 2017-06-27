#!/bin/bash

if [ -d "/Library/Caches" ] ; then
    CACHE_DIR="/Library/Caches/grakn-spec"
elif [ -d "/usr/local/share" ] ; then
    CACHE_DIR="/usr/local/share/grakn-spec"
else
    >&2 echo "Could not find cache directory"
    exit 1
fi
mkdir -p $CACHE_DIR

VERSION="0.13.0"

GRAKN_RELEASE="grakn-dist-${VERSION}"

GRAKN_TAR="${GRAKN_RELEASE}.tar.gz"

TEMP_DIR_PTR="$CACHE_DIR/temp-dir"

case $1 in
    start)
        set -e

        DOWNLOAD_URL="https://github.com/graknlabs/grakn/releases/download/v${VERSION}/${GRAKN_TAR}"

        set +e
        nc -z localhost 4567
        PORT_IN_USE=$?
        set -e

        if [ $PORT_IN_USE -eq 0 ]; then
            >&2 echo "Port 4567 is in use. Maybe a Grakn server is already running?"
            exit 1
        fi

        DOWNLOAD_PATH="${CACHE_DIR}/${GRAKN_TAR}"

        if [ ! -f "$DOWNLOAD_PATH" ] ; then
            wget -O "$DOWNLOAD_PATH" "$DOWNLOAD_URL"
        fi

        TEMP_DIR=`mktemp -d`
        echo "$TEMP_DIR" > "$TEMP_DIR_PTR"

        tar -xvf "${DOWNLOAD_PATH}" -C "${TEMP_DIR}"

        GRAKN_DIR="${TEMP_DIR}/grakn"

        mv "${TEMP_DIR}/${GRAKN_RELEASE}" "$GRAKN_DIR"

        "${GRAKN_DIR}/bin/grakn.sh" start
        sleep 5  # TODO: remove this when `grakn.sh start` blocks

        GRAQL_FILE_OF_TYPES_AND_INSTANCES="${GRAKN_DIR}/examples/pokemon.gql"

        "${GRAKN_DIR}/bin/graql.sh" -f "$GRAQL_FILE_OF_TYPES_AND_INSTANCES"
        ;;
    stop)
        TEMP_DIR=$(<"${TEMP_DIR_PTR}")

        GRAKN_DIR="${TEMP_DIR}/grakn"

        "${GRAKN_DIR}/bin/grakn.sh" stop

        rm -rf "$TEMP_DIR"
        ;;
    *)
        >&2 echo 'Valid commands are `start` and `stop`'
        exit 1
        ;;
esac
