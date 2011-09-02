# Building With Repo
## Ensure You Have the Dependencies

### Windows:

    make manifest
    make setup
    make test

## Get Repo

    $ curl http://android.git.kernel.org/repo > ~/bin/repo
    $ chmod a+x ~/bin/repo

## Clone the Manifest

    $ mkdir couchdb
    $ cd couchdb
    $ repo init -u git@github.com:couchbaselabs/couchbase-example-manifest.git
    $ repo sync

## Build

    $ make
