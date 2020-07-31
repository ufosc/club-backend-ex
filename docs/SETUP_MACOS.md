# Setting up environment on MacOS

This guide requires that you have [homebrew installed](https://brew.sh/). This tool is highly recommended for any development on a Mac.

## Elixir

First we need to install the [Elixir](https://elixir-lang.org/) programming language.

```bash
    $ brew install elixir
```

## Phoenix

Next we install the latest version of hex and then the latest Phoenix version.

```bash
    $ mix local.hex
    $ mix archive.install hex phx_new 1.5.4
```

## Postgresql

Finally we install the Postgres database.

```bash
    $ brew install postgresql
    # Start the postgres service
    $ brew services start postgresql
```

## More

Now you are ready for the main getting started guide: [Getting Started](./GETTING_STARTED.md)
