# Builds a TAR bunziped ready for release.
# $1 in/out parameter to place the tarball path to be returned.
# $2 release name.
# $3 binary to be released.

build_tarball() {
    RELEASE_DIR=/tmp/$2
    rm -rf $RELEASE_DIR
    mkdir -p $RELEASE_DIR
    mv $3 $RELEASE_DIR/
    RELEASE_TARBALL=$2.tar.bz2
    cd $RELEASE_DIR && tar -cjSf $RELEASE_TARBALL guaka
    RELEASE_TARBALL_PATH=$RELEASE_DIR/$RELEASE_TARBALL
    eval "$1=$RELEASE_TARBALL_PATH"
}
