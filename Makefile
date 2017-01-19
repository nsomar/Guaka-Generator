install:
	make build-project
	cp bin/guaka ~/bin/guaka
clean:
	rm -rf .build
	rm -rf bin/darwin
	rm -rf bin/linux

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

sha256:
	@shasum -a 256 bin/guaka | cut -f 1 -d " "
