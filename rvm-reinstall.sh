#!/bin/bash

source /usr/local/rvm/scripts/rvm

# Install Ruby
#rvm reinstall ruby-$RUBY_VERSION --disable-binary
rvm install ruby-2.6.1 --disable-binary
#rvm use ruby-$RUBY_VERSION --default
rvm use ruby-2.6.1 --default
gem install bundler foreman
