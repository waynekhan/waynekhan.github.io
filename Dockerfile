# From https://hub.docker.com/_/ruby/.
FROM ruby

ENV JEKYLL_BASE="/home/worker/jekyll"

# Run this container as a non-root user (worker).
RUN groupadd --gid 3000 worker \
  && useradd -g worker worker

RUN mkdir JEKYLL_BASE
COPY . JEKYLL_BASE
WORKDIR JEKYLL_BASE
RUN gem install jekyll bundler \
    && bundle install

CMD ["exec", "jekyll", "serve"]
ENTRYPOINT ["bundle"]
