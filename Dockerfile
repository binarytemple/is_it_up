FROM elixir

RUN mix local.hex --force && mix local.rebar --force && mix hex.info

RUN apt-get update -y && apt-get install curl -y

WORKDIR /elixir_plug_poc

COPY ./mix* ./

ENV MIX_ENV=test

RUN mix hex.info && mix do deps.get

COPY . . 

RUN mix test

ENV MIX_ENV=dev

CMD ["/bin/bash"]
