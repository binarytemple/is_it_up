FROM elixir

MAINTAINER admin@binarytemple.co.uk

EXPOSE 4000

RUN mix local.hex --force && mix local.rebar --force 

RUN apt-get update -y && apt-get install -y curl vim

WORKDIR /elixir_plug_poc

COPY ./mix* ./

ENV MIX_ENV=test

RUN mix hex.info && mix do deps.get

COPY . . 

RUN mix test

ENV MIX_ENV=dev

RUN mix compile

CMD ["/bin/bash"]
