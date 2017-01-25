#! /bin/bash
echo "Installing Guaka generator. Please wait.."
REPOSITORY="oarrabi/Guaka-Generator"

DEFAULT_OS=$(uname -s | tr '[:upper:]' '[:lower:]')
if ((1<<32)); then
  DEFAULT_ARCH="X64"
else
  DEFAULT_ARCH="386"
fi

OS=${3:-$DEFAULT_OS}
ARCH=${4:-$DEFAULT_ARCH}

REPOSITORY_OWNER=$(echo $REPOSITORY | cut -f1 -d/)
REPOSITORY_NAME=$(echo $REPOSITORY | cut -f2 -d/)
RELEASES_URL="https://api.github.com/repos/$REPOSITORY_OWNER/$REPOSITORY_NAME/releases"
RELEASES_RESPONSE=$(curl -s "$RELEASES_URL")
if [ $? -ne 0 ]; then
    echo "Error determining latest release version."
    exit 1
fi

DEFAULT_TAG_NAME=$(echo "$RELEASES_RESPONSE" \
           | grep -m 1 "^    \"tag_name\": " \
           | sed "s/    \"tag_name\"\: \"//g" \
           | sed "s/[\",]//g")
TAG_NAME=${5:-$DEFAULT_TAG_NAME}

FILENAME="$REPOSITORY_NAME-$TAG_NAME-$OS-$ARCH.tar.bz2"
DOWNLOAD_URL="https://github.com/$REPOSITORY/releases/download/$TAG_NAME/$FILENAME"

TEMP_TARBAL="/tmp/$FILENAME"
if [ -f $TEMP_TARBAL ] ; then
    rm $TEMP_TARBAL
fi

curl -sL "$DOWNLOAD_URL" -o $TEMP_TARBAL
if [ $? -ne 0 ]; then
    echo "Error downloading the release tarball."
    exit 1
fi

BINARY_DEST="$HOME/.$REPOSITORY_NAME/bin"
mkdir -p $BINARY_DEST

tar -jxf $TEMP_TARBAL -C $BINARY_DEST
if [ $? -eq 0 ]; then
    echo "Installed! Make sure \"$BINARY_DEST\" is on your \$PATH"
fi

rm -f $TEMP_TARBAL
