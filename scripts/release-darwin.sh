if [ -z "$VERSION" ]; then
    echo "VERSION is missing"
    exit 1
fi

if [ -z "$GITHUB_TOKEN" ]; then
    echo "GITHUB_TOKEN is missing"
    exit 1
fi

# git tag $VERSION
# git push origin master --tags

RELEASE=guaka-generator-$VERSION-darwin-X64
BINARY="bin/darwin/guaka"
RELEASE_TARBALL_PATH=-1
build_tarball RELEASE_TARBALL_PATH $RELEASE $BINARY

github-release -v release --user $USER --repo Guaka-Generator --tag ${VERSION} --name "Version ${VERSION}"
github-release -v upload --user $USER --repo Guaka-Generator --tag ${VERSION} --name $RELEASE_TARBALL --file $RELEASE_TARBALL_PATH
