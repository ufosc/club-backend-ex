# Setting up environment with Docker

This guide requires that you have Docker installed.

- [Docker Windows 10 Pro/Student](https://docs.docker.com/docker-for-windows/install/)
- [Docker Windows 10 Home](https://docs.docker.com/docker-for-windows/install-windows-home/)
- [Docker MacOS](https://docs.docker.com/docker-for-mac/install/)
- [Docker Linux](https://docs.docker.com/compose/install/)

## Running

To start the server you should be able to run the following:

```bash
 $ docker-compose up
```

If you would like to run other commands such as those in the getting started guide you will need to prefix them as follows.

For the command `mix test`:

```bash
 $ docker-compose run phoenix mix test
```

## More

Now you are ready for the main getting started guide: [Getting Started](./GETTING_STARTED.md)
