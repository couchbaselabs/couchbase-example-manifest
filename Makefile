TOPDIR := $(shell pwd)
BUILD_DIR := $(TOPDIR)/build

all: manifest build

manifest:
	$(TOPDIR)/fetch-manifest.rb default.xml

setup:
	(cd couchbase-python-client \
	&& ./setup.py install)

build:
	$(TOPDIR)/genexe.rb couchbase-examples

test:
	(cd couchbase-examples \
	&& python docloader -u Administor -p 123456 -b mybucket testapp.zip)
