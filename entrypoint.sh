#!/bin/bash

read RUBY_VERSION < /qoto/.ruby-version
curl -sSL https://raw.githubusercontent.com/rvm/rvm/stable/binscripts/rvm-installer | bash -s stable --ruby=${RUBY_VERSION}

source /usr/local/rvm/scripts/rvm

# Install Ruby
rvm reinstall ruby-$RUBY_VERSION --disable-binary
#rvm install ruby-2.6.1 --disable-binary
rvm use ruby-$RUBY_VERSION --default
#rvm use ruby-2.6.1 --default
gem install bundler foreman

rvm use ruby-$RUBY_VERSION --default


cd /qoto
export $(cat ".env.vagrant" | xargs)
redis-server &
/etc/init.d/postgresql start
bundle install
yarn install
bundle exec rails db:setup
echo 'export $(cat ".env.vagrant" | xargs)' >> ~/.bash_profile
foreman start
