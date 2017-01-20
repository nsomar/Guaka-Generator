install:
	make build-project
	cp bin/guaka ~/bin/guaka

test:
	bash scripts/test.sh

install-swift:
	eval "$(curl -sL https://gist.githubusercontent.com/kylef/5c0475ff02b7c7671d2a/raw/02090c7ede5a637b76e6df1710e83cd0bbe7dcdf/swiftenv-install.sh)"

test-darwin:
	xcodebuild -project guaka-cli.xcodeproj -scheme guaka-cli build test

test-linux:
	swift test

coverage:
	slather coverage guaka-cli.xcodeproj

generate:
	swift package generate-xcodeproj --enable-code-coverage

clean-darwin:
	rm -rf bin/darwin

clean-linux:
	rm -rf bin/linux

clean:
	rm -rf .build
	make clean-darwin
	make clean-linux

build-project:
	swift build -Xswiftc -static-stdlib

build-project-darwin:
	mkdir -p bin/darwin
	make build-project
	cp ./.build/debug/guaka-cli bin/darwin/guaka

build-project-linux:
	mkdir -p bin/linux
	make build-project
	cp -f ./.build/debug/guaka-cli bin/linux/guaka

release-darwin:
	bash scripts/release-darwin.sh

release-linux:
	bash scripts/release-linux.sh

publish-homebrew-mac:
	bash scripts/publish-homebrew-mac.sh

release-and-deploy-darwin:
	make release-darwin
	make publish-homebrew-mac

release-and-deploy:
	if [[ "$TRAVIS_OS_NAME" == "osx" ]]; then make build-project-darwin release-darwin VERSION=${TRAVIS_TAG} GITHUB_TOKEN=${GITHUB_TOKEN} ; fi
	if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then make build-project-linux release-linux VERSION=${TRAVIS_TAG} GITHUB_TOKEN=${GITHUB_TOKEN} ; fi

sha256:
	@shasum -a 256 bin/guaka | cut -f 1 -d " "
