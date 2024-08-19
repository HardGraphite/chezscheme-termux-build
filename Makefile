GIT ?= git
SED ?= sed

CHEZ_GIT_REPO_URL ?= https://github.com/cisco/ChezScheme
CHEZ_INSTALL_NAME ?= chez
CHEZ_CONFIGURE_EXTRA_OPTS ?=

.all: build

.ONESHELL:

ChezScheme:
	$(GIT) clone "${CHEZ_GIT_REPO_URL}" --depth=1 --filter=blob:none

.PHONY: configure
configure: ChezScheme/Makefile
ChezScheme/Makefile: ChezScheme
	cd ChezScheme
	./configure \
		--installprefix=$(PREFIX) \
		--installschemename=$(CHEZ_INSTALL_NAME) \
		--installscriptname=$(CHEZ_INSTALL_NAME)-script \
		--threads --disable-x11 \
		$(CHEZ_CONFIGURE_EXTRA_OPTS)
	$(SED) -i -e 's/^LIBS=.*$$/& -liconv/' */Mf-config

.PHONY: build
build: ChezScheme/Makefile
	$(MAKE) -C ChezScheme build

.PHONY: install
install: ChezScheme/Makefile 
	PATH='$(PWD)/bin:$(PATH)' $(MAKE) -C ChezScheme install

.PHONY: uninstall
uninstall: ChezScheme/Makefile 
	$(MAKE) -C ChezScheme uninstall
