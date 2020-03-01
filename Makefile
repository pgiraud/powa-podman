BUILD_CMD = ./build_all.sh
ifdef DOCKER_PUSH
BUILD_CMD += -p
endif

.PHONY: git powa-archivist-git powa-web-git powa-collector-git

all:
	$(MAKE) -C powa-archivist
	cp -r misc/setup_powa-archivist.sh powa-archivist-git/
	cp -r misc/install_all_powa_ext.sql powa-archivist-git/
	cp -r misc/powa-web.conf powa-web/
	cp -r misc/powa-web.conf powa-web-git/
	cp -r misc/powa-collector.conf powa-collector/
	cp -r misc/powa-collector.conf powa-collector-git/

images: all git
	${BUILD_CMD}

powa-archivist-git-misc: misc/setup_powa-archivist.sh misc/install_all_powa_ext.sql
	cp -r misc/setup_powa-archivist.sh powa-archivist-git/
	cp -r misc/install_all_powa_ext.sql powa-archivist-git/

powa-archivist-git: powa-archivist-git-misc
	$(BUILD_CMD) -i powa-archivist-git

powa-web-git-misc: misc/powa-web.conf
	cp -r misc/powa-web.conf powa-web-git/

powa-web-git: powa-web-git-misc
	$(BUILD_CMD) -i powa-web-git

powa-collector-git-misc: misc/powa-collector.conf
	cp -r misc/powa-collector.conf powa-collector-git/

powa-collector-git: powa-collector-git-misc
	$(BUILD_CMD) -i powa-collector-git

git:
	$(MAKE) powa-archivist-git-misc
	$(MAKE) powa-web-git-misc
	$(MAKE) powa-collector-git-misc
	$(BUILD_CMD) -i "powa-archivist-git" -i "powa-web-git" -i "powa-collector-git"
