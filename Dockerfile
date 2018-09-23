FROM bitwalker/alpine-elixir-phoenix:latest
MAINTAINER Mickey Chen "mickey@zazaar.tv"

# Set exposed ports
ENV PORT 4000
ENV SSL_PORT 4443
ENV MIX_ENV prod

EXPOSE $PORT
EXPOSE $SSL_PORT

# Cache elixir deps
ADD mix.exs mix.lock ./
ADD config ./config
RUN mix do deps.get, deps.compile

# Install Yarn
RUN apk add yarn

# Run frontend build, compile, and digest assets
ADD assets ./assets
RUN cd assets/ && \
    yarn install && \
    yarn run deploy && \
    cd - && \
    mix do compile, phx.digest

ADD . .

USER default

RUN ls -al _build/prod/lib/zazaar/

CMD ["mix", "phx.server"]

RUN ls -al _build/prod/lib/
RUN whoami
