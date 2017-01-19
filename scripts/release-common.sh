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

# Releases the artifact to Github Releases page.
# $1 The version to be released
# $2 The plaform: linux | darwin.
# $3 binary artifact to be released.
# $4 Github token.
release() {
    VERSION=$1
    PLATFORM=$2
    BINARY=$3
    GITHUB_TOKEN=$4

    RELEASE_TARBALL_PATH=-1
    RELEASE=guaka-generator-$VERSION-$PLATFORM-X64
    RELEASE_TARBALL=$RELEASE.tar.bz2

    build_tarball RELEASE_TARBALL_PATH $RELEASE $BINARY

    github-release -v release --user oarrabi --security-token ${GITHUB_TOKEN} --repo Guaka-Generator --tag ${VERSION} --name "Version ${VERSION}"
    github-release -v upload --user oarrabi --security-token ${GITHUB_TOKEN} --repo Guaka-Generator --tag ${VERSION} --name $RELEASE_TARBALL --file $RELEASE_TARBALL_PATH
}

