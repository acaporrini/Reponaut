FROM ruby:3.0.2

RUN mkdir /myapp
WORKDIR /myapp

COPY Gemfile* /myapp/
RUN bundle install

COPY . /myapp

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "3000"]
