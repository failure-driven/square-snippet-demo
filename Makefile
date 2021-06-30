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

tmux:
	bin/makefile/tmux
rails_bundle:
	bundle
rails_server: rails_bundle
	bundle exec bin/rails server
rails_yarn:
	yarn
webpacker: rails_yarn
	bin/webpack-dev-server
sidekiq:
	echo "we will get to having background jobs"
tmux_down:
	bin/makefile/tmux_down

pg_init:
	bin/makefile/pg_init
pg_start:
	bin/makefile/pg_start
pg_stop:
	bin/makefile/pg_stop
