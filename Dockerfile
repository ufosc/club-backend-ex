FROM elixir:1.10

WORKDIR /app
COPY . /app

RUN apt-get update && apt-get install -y bash openssl postgresql-client

# Install hex
RUN mix local.hex --force && mix local.rebar --force

# Get and compile the depdencies
RUN mix deps.get && mix deps.compile

# Compile the application
RUN mix do compile

CMD ["/app/dockerentry.sh"]
