TOPDIR := $(shell pwd)
BUILD_DIR := $(TOPDIR)/build

all:

manifest:
	$(TOPDIR)/fetch-manifest.rb default.xml

setup:
	(cd ocuchbase-python-client \
	&& setup.py install)

test:
	(cd couchbase-examples \
	&& python docloader -u Administor -p 123456 -b mybucket testapp.zip)
