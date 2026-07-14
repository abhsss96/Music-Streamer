# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.4.4
FROM ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y libpq5 curl && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Defaults to a lean, production-only bundle. docker-compose overrides this
# build arg to an empty string for local dev, since RAILS_ENV=development
# there needs the :development group (e.g. the `debug` gem) present.
ARG BUNDLE_WITHOUT=development:test

ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT=$BUNDLE_WITHOUT


# --- Build stage: compile gems and anything else needed at boot ---
FROM base AS build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

COPY . .

RUN bundle exec bootsnap precompile app/ lib/


# --- Final stage: runtime image only ---
FROM base

COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log tmp storage
USER 1000:1000

ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 3000
# Bind to all interfaces -- Puma's dev-mode default of 127.0.0.1 is
# unreachable from outside any container, Docker Desktop's port mapping
# included.
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
