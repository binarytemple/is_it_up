FROM bitwalker/alpine-elixir:1.9.0 as builder

MAINTAINER admin@binarytemple.co.uk

RUN mix local.hex --force && mix local.rebar --force 

RUN apk update && apk add curl vim

WORKDIR /otp/app

COPY . .

ENV MIX_ENV=test

RUN mix do hex.info, deps.get

RUN mix test

RUN MIX_ENV=prod mix do deps.get, compile, distillery.release

FROM bitwalker/alpine-elixir:1.9.0 

COPY --from=builder /otp/app/_build/prod/rel/elixir_plug_poc/releases/*/elixir_plug_poc.tar.gz /opt/app/

WORKDIR /opt/app/

RUN tar zxvfp ./elixir_plug_poc.tar.gz && \
    rm -rf ./elixir_plug_poc.tar.gz && \
    rm -rf ./.hex && \
    rm -rf ./.mix 
      
EXPOSE 4000

ENV REPLACE_OS_VARS=true

ENTRYPOINT ["/opt/app/bin/elixir_plug_poc"]

CMD ["foreground"]
