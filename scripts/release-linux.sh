source ./scripts/release-common.sh

[ -z ${VERSION+x} ] && { echo "VERSION is missing"; exit 1; }
[ -z ${GITHUB_TOKEN+x} ] && { echo "GITHUB_TOKEN is missing"; exit 1; }

# git tag $VERSION
# git push origin master --tags

release $VERSION "linux" "bin/linux/guaka" $GITHUB_TOKEN
