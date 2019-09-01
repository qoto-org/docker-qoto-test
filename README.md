Just run the following:

docker run -p 3000:3000 --volume="$PWD:/qoto" qotoorg/qoto-test:1

This will determine what version of ruby the mastodon repo needs, install it into the container, then run bundle and yarn install, setup a database, setup redis and then run the server at http://localhost:3000
