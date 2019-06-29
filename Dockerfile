FROM bitwalker/alpine-elixir:latest

MAINTAINER admin@binarytemple.co.uk

ENV PORT 4000

RUN mix local.hex --force && mix local.rebar --force 

RUN apk update && apk add curl vim

WORKDIR /elixir_plug_poc

COPY . .

ENV MIX_ENV=test

RUN mix do hex.info, deps.get

COPY . . 

RUN mix test

RUN MIX_ENV=prod mix do deps.get, compile, distillery.release

EXPOSE $PORT

ENV REPLACE_OS_VARS=true

ENTRYPOINT ["/elixir_plug_poc/_build/prod/rel/elixir_plug_poc/bin/elixir_plug_poc"]

CMD ["foreground"]
