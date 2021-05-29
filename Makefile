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
		API_HOST_URL=https://stg-swif.herokuapp.com \
		bin/makefile/heroku-create

d.PHONY: production_deploy
production_deploy:
	RAILS_MASTER_KEY=`cat config/master.key` \
		HEROKU_APP_NAME=prd-swif \
		HEROKU_DOMAIN=swif.club \
		API_HOST_URL=https://swif.club \
		bin/makefile/heroku-create
