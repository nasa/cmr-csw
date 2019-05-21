# Ruby image
FROM ruby:2.5.3

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

RUN mkdir /cmr-csw
WORKDIR /cmr-csw


# Copy ruby version file
COPY .ruby-version /cmr-csw/.ruby-version

# Copy Gemfiles
COPY Gemfile /cmr-csw/Gemfile
COPY Gemfile.lock /cmr-csw/Gemfile.lock

#Always bundle before copying app src.
# Prevent bundler warnings;
# ensure that the bundler version executed is >= that which created Gemfile.lock

RUN gem install bundler

# Finish establishing our Ruby enviornment
RUN bundle install

# Copy the Rails application into place
COPY . /cmr-csw

RUN bundle exec rake assets:precompile
