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

ENV MIX_ENV=prod

RUN mix deps.get 
RUN mix compile 
RUN mix distillery.release 

EXPOSE $PORT

CMD /elixir_plug_poc/_build/prod/rel/elixir_plug_poc/bin/elixir_plug_poc foreground
