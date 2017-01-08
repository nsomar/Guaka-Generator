install:
	make build-project
	cp bin/guaka ~/bin/guaka

build-project:
	rm -rf bin
	mkdir bin
	swift build -Xswiftc -static-stdlib
	cp ./.build/debug/guaka-cli bin/guaka
