# This file is a template, and might need editing before it works on your project.
FROM ruby:2.5.9

# Edit with nodejs, mysql-client, postgresql-client, sqlite3, etc. for your needs.
# Or delete entirely if not needed.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        nodejs \
        postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# throw errors if Gemfile has been modified since Gemfile.lock
#RUN bundle config --global frozen 1

RUN mkdir /src
WORKDIR /src

COPY Gemfile Gemfile.lock /src/
RUN bundle install -j $(nproc)

COPY . /src


# For Rails
EXPOSE 5432
CMD ["bundle", "exec", "rspec", "--format", "progress", "--format", "RspecJunitFormatter", "--out", "rspec.xml"]
