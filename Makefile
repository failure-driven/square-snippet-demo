PROJECT := NaaS

default: usage
usage:
	bin/makefile/usage

prettier:
	bin/makefile/prettier-ruby
	bin/makefile/prettier-js

.PHONY: build
build:
	bin/makefile/full-build

d.PHONY: production_deploy
production_deploy:
	RAILS_MASTER_KEY=`cat config/master.key` \
		HEROKU_APP_NAME=prd-swif \
		HEROKU_DOMAIN=swif.club \
		API_HOST_URL=https://swif.club \
		bin/makefile/heroku-create
