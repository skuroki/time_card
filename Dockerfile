FROM ruby:3.0

ENV APP_ROOT /usr/src/app

WORKDIR $APP_ROOT

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN gem install bundler
RUN bundle install

COPY . $APP_ROOT

ENTRYPOINT ["bundle", "exec"]
CMD ["rails", "server"]