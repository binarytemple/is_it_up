FROM bitwalker/alpine-elixir:1.9.0

RUN mix local.hex --force && mix local.rebar --force 

RUN apk update && apk add curl make g++

WORKDIR /otp/app

COPY config config/
COPY lib lib/
COPY mix.exs .
COPY mix.lock .
COPY test test/

ENV MIX_ENV=test

RUN mix do hex.info, deps.get

RUN mix test

ENV MIX_ENV=prod 

RUN mix do deps.get, compile

COPY rel rel/

RUN mix do distillery.release

FROM bitwalker/alpine-elixir:1.9.0

COPY --from=0 /otp/app/_build/prod/rel/is_it_up/releases/*/is_it_up.tar.gz /opt/app/

WORKDIR /opt/app/

RUN tar zxvfp ./is_it_up.tar.gz && \
    rm -rf ./is_it_up.tar.gz && \
    rm -rf ./.hex && \
    rm -rf ./.mix 
 
RUN apk update && apk add bind-tools
     
EXPOSE 4000

ENV REPLACE_OS_VARS=true

ENTRYPOINT ["/opt/app/bin/is_it_up"]

CMD ["foreground"]