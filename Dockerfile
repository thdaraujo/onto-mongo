FROM ruby:2.3.0
# Install dependencies.
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
# Setup app directory.
RUN mkdir /myapp
RUN mkdir /data
WORKDIR /myapp
# Copy the Gemfile and Gemfile.lock into the image and install gems before the project is copied,
# this is to avoid do bundle install every time some project file change.
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install --jobs=4
# Everything up to here was cached. This includes the bundle install, unless the Gemfiles changed.
# Now copy the app into the image.
ADD . /myapp
# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
