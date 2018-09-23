###### Build Stage
FROM elixir:alpine

ARG APP_NAME=zazaar
ARG PHOENIX_SUBDIR=.

# Set exposed ports
ENV PORT=4000 \
    SSL_PORT=4443 \
    MIX_ENV=prod \
    TERM=xterm \
    REPLACE_OS_VARS=true

WORKDIR /opt/app

RUN apk update && \
    apk --no-cache --update add nodejs nodejs-npm yarn git && \
    apk --no-cache --update add build-base && \
    mix local.rebar --force && \
    mix local.hex --force

COPY . .

RUN mix do deps.get, deps.compile, compile

# Run frontend build, and digest assets
RUN cd assets/ && \
    yarn install && \
    yarn run deploy && \
    cd - && \
    mix phx.digest

# Build and move release to directory
RUN mix release --env=prod --verbose && \
    mv _build/prod/rel/${APP_NAME} /opt/release && \
    ls -al /opt/release && \
    mv /opt/release/bin/${APP_NAME} /opt/release/bin/start_server


###### Runtime Stage
FROM alpine:latest

# Install dependencies for ERTS.
RUN apk update \
    && apk --no-cache --update add bash openssl-dev

# This is the runtime environment for a Phoenix app.
# It listens on port 8080, and runs in the prod environment.
ENV PORT=8080 \
    MIX_ENV=prod \
    REPLACE_OS_VARS=true

# Set the install directory. The app will run from here.
WORKDIR /opt/app

# Obtain the built application release from the build stage.
COPY --from=0 /opt/release .

# Start the server.
EXPOSE ${PORT}
CMD ["/opt/app/bin/start_server", "foreground"]
