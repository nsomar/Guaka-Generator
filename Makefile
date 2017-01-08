install:
	make build-project
	cp bin/guaka ~/bin/guaka

build-project:
	rm -rf bin
	mkdir bin
	swift build -Xswiftc -static-stdlib
	cp ./.build/debug/guaka-cli bin/guaka

release:
	bash scripts/release.sh

sha256:
	@shasum -a 256 bin/guaka | cut -f 1 -d " "
