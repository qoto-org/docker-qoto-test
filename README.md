Just run the following:

docker run -p 3000:3000 --volume="$PWD:/qoto" qotoorg/qoto-test:latest

This will determine what version of ruby the mastodon repo needs, install it into the container, then run bundle and yarn install, setup a database, setup redis and then run the server at http://localhost:3000

You can then run this within the container to generate an admin user:

source /usr/local/rvm/scripts/rvm && RAILS_ENV=production bin/tootctl accounts create dev --email dev@mastodon.local --confirmed --role admin
