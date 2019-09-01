FROM ubuntu:bionic
MAINTAINER jeffrey.freeman@qoto.org

RUN cd ~
RUN export DEBIAN_FRONTEND=noninteractive
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
RUN apt-get update
RUN apt-get install \
  git-core \
  g++ \
  libpq-dev \
  libxml2-dev \
  libxslt1-dev \
  imagemagick \
  redis-server \
  redis-tools \
  postgresql \
  postgresql-contrib \
  sudo \
  protobuf-compiler \
  curl \
  libicu-dev \
  libidn11-dev \
  libprotobuf-dev \
  libreadline-dev \
  libpam0g-dev \
  -y
RUN dpkg-reconfigure --frontend noninteractive tzdata
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

RUN curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
RUN apt-get install -y nodejs && npm install -g yarn

# Install rvm
COPY ./qoto/.ruby-version .ruby-version
RUN read RUBY_VERSION < .ruby-version
RUN rm .ruby-version
RUN curl -sSL https://raw.githubusercontent.com/rvm/rvm/stable/binscripts/rvm-installer | bash -s stable --ruby=$RUBY_VERSION
COPY rvm-reinstall.sh rvm-reinstall.sh
RUN bash rvm-reinstall.sh && rm rvm-reinstall.sh

# Configure database
RUN /etc/init.d/postgresql restart &&  /etc/init.d/postgresql status && sudo -u postgres createuser -U postgres vagrant -s && sudo -u postgres createuser -U postgres root -s && sudo -u postgres createdb -U postgres mastodon_development

# Install gems and node modules
#RUN gem install bundler foreman
#RUN bundle install
#RUN yarn install

#RUN apt remove cmdtest yarn -y && apt-get install npm -y && npm install -g yarn
#RUN apt-get install npm -y && npm install -g yarn

#RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
#RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
#RUN echo "deb https://nightly.yarnpkg.com/debian/ nightly main" | tee /etc/apt/sources.list.d/yarn.list
#RUN apt-get install yarn -y

#RUN update-rc.d postgresql enable

# Run the command on container startup
EXPOSE 3000
ENV BIND="0.0.0.0"
COPY entrypoint.sh /root/entrypoint.sh
CMD bash /root/entrypoint.sh
