FROM ruby:2.4

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install

COPY . /usr/src/app

RUN bundle exec jekyll build

FROM nginx:1

RUN mkdir -p /mtail/logs
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=0 /usr/src/app/_site /usr/share/nginx/html
