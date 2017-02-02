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
	rm -rf release/darwin

clean-linux:
	rm -rf bin/linux
	rm -rf release/linux

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
	@echo "\nDarwin version built at bin/darwin/guaka\n"

build-project-linux:
	mkdir -p bin/linux
	make build-project
	cp -f ./.build/debug/guaka-cli bin/linux/guaka

release-darwin:
	bash scripts/release-darwin.sh

release-darwin-local:
	rm -rf .build
	make build-project-darwin
	bash scripts/release-darwin.sh

release-linux:
	bash scripts/release-linux.sh

release-linux-local:
	rm -rf .build
	make clean-linux
	make build-project-linux

publish-local-darwin:
	bash scripts/publish-homebrew-mac.sh

build-linux-docker:
	@echo "Runs release-linux-local inside a docker image"
	@echo "The built file is located at bin/linux/guaka"
	docker-compose run -w /work swift
	@echo "\nLinux version built at bin/linux/guaka\n"

build-all-local: clone-swiftline clean build-linux-docker build-project-darwin
	@echo "Binaries built at bin/\n"

release-local:
	make build-all-local
	@echo "Starting the github release for version ${VERSION}/\n"
	bash scripts/github-release.sh

	@echo "Upload darwin binary\n"
	bash scripts/release-darwin.sh

	@echo "Upload linux binary\n"
	bash scripts/release-linux.sh

publish-local:
	make publish-local-darwin

release-publish-local:
	make release-local
	make publish-local

clone-swiftline:
	@echo "Removing old Swiftline"
	@echo ""
	rm -rf SwiftLineTemp

	@echo "Clone new Swiftline from oarrabi/linux! branch"
	git clone -b oarrabi/linux! https://github.com/oarrabi/Swiftline.git SwiftLineTemp
	mv SwiftLineTemp/Sources/*.* Sources/Swiftline/
	rm -rf SwiftLineTemp

release-and-deploy:
	if [[ "$TRAVIS_OS_NAME" == "osx" ]]; then make build-project-darwin release-darwin VERSION=${TRAVIS_TAG} GITHUB_TOKEN=${GITHUB_TOKEN} ; fi
	if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then make build-project-linux release-linux VERSION=${TRAVIS_TAG} GITHUB_TOKEN=${GITHUB_TOKEN} ; fi

sha256:
	@shasum -a 256 bin/guaka | cut -f 1 -d " "
