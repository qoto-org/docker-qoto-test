#!/bin/bash

source /usr/local/rvm/scripts/rvm
rvm use ruby-2.6.1 --default


cd /qoto
export $(cat ".env.vagrant" | xargs)
redis-server &
/etc/init.d/postgresql start
bundle install
yarn install
bundle exec rails db:setup
echo 'export $(cat ".env.vagrant" | xargs)' >> ~/.bash_profile
foreman start
