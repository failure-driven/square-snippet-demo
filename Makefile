PROJECT := NaaS

default: usage
usage:
	bin/makefile/usage

.PHONY: build
build:
	bin/makefile/full-build

d.PHONY: deploy
deploy:
	RAILS_MASTER_KEY=`cat config/master.key` \
		HEROKU_APP_NAME=stg-swif \
		SCHEME=http \
		HOST=stg-swif.herokuapp.com \
		PORT=80 \
		bin/makefile/heroku-create
