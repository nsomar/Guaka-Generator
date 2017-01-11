if [ -z "$VERSION" ]; then
    echo "VERSION is missing"
    exit 1
fi

# if [ -z "$GITHUB_TOKEN" ]; then
#     echo "GITHUB_TOKEN is missing"
#     exit 1
# fi

# git tag $VERSION
# git push origin master --tags

SHA=$(shasum -a 256 bin/mac/guaka | cut -f 1 -d " ")
echo $SHA

cd /tmp
git clone https://github.com/oarrabi/homebrew-tap.git
cd homebrew-tap
ls
pwd
sed -i.bak s/"sha256 \".*\""/"sha256 \"${SHA}\""/g guaka.rb
sed -i.bak s/"version \".*\""/"version \"${VERSION}\""/g guaka.rb
cat guaka.rb
git add guaka.rb
git commit -m "Releasing Guaka-Generator version ${VERSION}"
rm -rf /tmp/homebrew-tap
