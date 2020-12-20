FROM elixir:1.11

RUN apt-get update && apt-get install -y postgresql-client

RUN mix local.hex --force & mix local.rebar --force

ENV MIX_ENV=prod

WORKDIR /app

COPY . /app/
RUN mix deps.get && mix deps.compile && mix compile

RUN mix release

COPY ./start.sh /app/
ENTRYPOINT [ "/app/start.sh" ]
