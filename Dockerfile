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

# Configure database
RUN /etc/init.d/postgresql restart &&  /etc/init.d/postgresql status && sudo -u postgres createuser -U postgres vagrant -s && sudo -u postgres createuser -U postgres root -s && sudo -u postgres createdb -U postgres mastodon_development
RUN echo "host all all 0.0.0.0/0 trust" > /etc/postgresql/10/main/pg_hba.conf
RUN echo "local all all trust" >> /etc/postgresql/10/main/pg_hba.conf

# Run the command on container startup
EXPOSE 3000
ENV BIND="0.0.0.0"
ENV OTP_SECRET="73f8f9a16e114be94ffb5378b323da045692d7d4afd4e4c96a4c9f9b423a7e6d820855440d2fab5e2d93e3c557c0a4515cec50a1dff6a89479a410ed5a3fe212"
ENV SECRET_KEY_BASE="c7b1664cf5af7943a357357669a58a5720f8fa83248542c99e5a47422fa9df422c12748a3dc700c8f1207d2a4dbc0629061d8aecaa8820d52dde64223e5ce3f8"
ENV DB_HOST=127.0.0.1
ENV DB_USER=root
ENV DB_PASS=""
ENV DB_NAME="mastodon_development"
COPY entrypoint.sh /root/entrypoint.sh
CMD bash /root/entrypoint.sh
