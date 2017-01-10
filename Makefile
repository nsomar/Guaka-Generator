install:
	make build-project
	cp bin/guaka ~/bin/guaka

build-project:
	swift build -Xswiftc -static-stdlib

docker-build:
	docker run --privileged -i -t --name swiftfun-builder --volume $PWD:/work swiftdocker/swift:latest /bin/sh -c "cd /work & ls"
	make docker-rm

docker-attach:
	docker run --privileged -i -t --name swiftfun-builder --volume $PWD:/work swiftdocker/swift:latest /bin/bash

docker-rm:
	docker rm swiftfun-builder

build-project-mac:
	rm -rf .build
	rm -rf bin/mac
	mkdir -p bin/mac
	make build-project
	cp ./.build/debug/guaka-cli bin/mac/guaka

build-project-ubnunt:
	rm -rf .build
	rm -rf bin/ubuntu
	mkdir -p bin/ubuntu
	make build-project
	cp ./.build/debug/guaka-cli bin/ubuntu/guaka

release-mac:
	bash scripts/release-mac.sh

deploy-mac:
	bash scripts/deploy-mac.sh

release-and-deploy-mac:
	make release-mac
	make deploy-mac

sha256:
	@shasum -a 256 bin/guaka | cut -f 1 -d " "
