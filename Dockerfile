FROM ruby:2.1.2
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN mkdir /cmr-csw
WORKDIR /cmr-csw
ADD Gemfile /cmr-csw/Gemfile
ADD Gemfile.lock /cmr-csw/Gemfile.lock
RUN bundle install
ADD . /cmr-csw
