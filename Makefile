all:
	bundle exec rerun -p "**/*.{rb}" foreman start

install: uninstall
	bundle config --local build.pg --with-pg-config=/Applications/Postgres.app/Contents/Versions/9.4/bin/pg_config
	bundle install --binstubs vendor/bundle/bin --path vendor/bundle -j4 --without production

uninstall:
	rm -fr Gemfile.lock vendor/ .bundle/

latest:
	curl -o latest.dump `heroku pg:backups public-url --app brt-backend`
	pg_restore --verbose --clean --no-acl --no-owner -d brt latest.dump

.PHONY: all install uninstall test latest
