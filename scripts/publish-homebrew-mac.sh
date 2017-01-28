[ -z ${VERSION+x} ] && { echo "VERSION is missing"; exit 1; }

FOLDER=guaka-generator-${VERSION}-darwin-X64
FILE=${FOLDER}.tar.bz2

if [ ! -f release/${FOLDER}/${FILE} ]; then
    echo "
    release/${FOLDER}/${FILE} not found!
    "
    exit 1
fi

BRANCH="releasing-${VERSION}"
SHA=$(shasum -a 256 release/${FOLDER}/${FILE} | cut -f 1 -d " ")
echo $SHA

cd /tmp
git clone git@github.com:oarrabi/homebrew-tap.git
cd homebrew-tap
git checkout -b ${BRANCH}

echo "class Guaka < Formula" > guaka.rb
echo "  url \"https://github.com/oarrabi/Guaka-Generator/releases/download/${VERSION}/${FILE}\"" >> guaka.rb
echo "  version \"${VERSION}\"" >> guaka.rb
echo "  sha256 \"${SHA}\" " >> guaka.rb
echo "" >> guaka.rb
echo "  def install" >> guaka.rb
echo "    bin.install \"guaka\"" >> guaka.rb
echo "  end" >> guaka.rb
echo "end" >> guaka.rb

git add guaka.rb
git commit -m "Releasing Guaka-Generator version ${VERSION}"
git push origin ${BRANCH}

hub pull-request -m "Releasing Guaka-Generator version ${VERSION}"
rm -rf /tmp/homebrew-tap
