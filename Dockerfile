FROM ruby:3.1.2

RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    libpq-dev \
    net-tools

RUN gem install bundler --version="2.4.8"

RUN mkdir /app
WORKDIR /app

COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install --full-index

COPY . .

EXPOSE 4567
CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "4567"]
