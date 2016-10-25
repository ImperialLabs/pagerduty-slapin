FROM slapi/ruby:latest

MAINTAINER SLAPI Devs

RUN mkdir -p /pager && chmod 777 /pager
WORKDIR /pager

COPY .gemrc /root/.gemrc
# Copy pager cli to container
COPY . ./
# Install dependencies
RUN apk update &&\
    apk add ruby-dev &&\
    gem install io-console -v 0.4.5 &&\
    gem install bundler &&\
    bundle install &&\
    rm /var/cache/apk/*

ENTRYPOINT ["/pager/bin/pager"]
