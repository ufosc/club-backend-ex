# Developing Club Backend

Make sure you followed an environemnt setup guide to get the project running on your computer:

## Setup Guides

- [MacOS](/docs/SETUP_MACOS.md)

## Full File Structure

```bash
lib # All the code for the project
├── club_backend # This is where the models + business logic is stored.  
│   ├── accounts
│   │   └── user.ex # Accounts "context" user model
│   ├── accounts.ex # Accounts "context" where logic + database interaction
│   ├── application.ex # Entry point of the application
│   ├── guardian.ex # JSON Web Tokens for session managment
│   └── repo.ex # Auto generated Ecto Repo code
├── club_backend.ex
├── club_backend_web
│   ├── channels # Future websocket/presence code
│   │   └── user_socket.ex
│   ├── controllers # Controllers for different routes
│   │   ├── auth_controller.ex
│   │   └── ping_controller.ex
│   ├── endpoint.ex
│   ├── gettext.ex
│   ├── router.ex # Definition of the HTTP routes
│   ├── telemetry.ex
│   └── views # Where the response is formatted
│       ├── auth_view.ex
│       ├── error_helpers.ex
│       └── error_view.ex
└── club_backend_web.ex
config # Central configuration
├── config.exs
├── dev.exs
├── prod.exs
├── prod.secret.exs
└── test.exs
priv
├── gettext # Localization
│   ├── en
│   │   └── LC_MESSAGES
│   │       └── errors.po
│   └── errors.pot
└── repo
    ├── migrations # Database changes
    │   └── 20200725220419_create_users.exs
    └── seeds.exs # Models to initialize in the database
test
├── club_backend
│   └── accounts_test.exs
├── club_backend_web
│   ├── channels
│   ├── controllers
│   └── views
│       └── error_view_test.exs
├── support
│   ├── channel_case.ex
│   ├── conn_case.ex
│   └── data_case.ex
└── test_helper.exs
```

## Resources

- Official website: <https://www.phoenixframework.org/>
- Guides: <https://hexdocs.pm/phoenix/overview.html>
- Docs: <https://hexdocs.pm/phoenix>
- Forum: <https://elixirforum.com/c/phoenix-forum>

## Example Scenario

Let's say we want to add tracking Open Source Club's dogs to the project.

### Backend/Modeling

The first thing we need to do is figure out how we are going to model our problem. This assumes that we don't have an existing dog model.

For this we are going to create a `Friends` context incase we want to add different kinds of friends than dogs later on. To learn more about contexts [see here.](https://hexdocs.pm/phoenix/contexts.html)

#### Now lets model the Dog

Column Name | Type | Attributes
----- | ----- | ------
name | string | not null
breed | string |
description | string | not null
birthday | datetime |

And lets throw an index on the name column to make it so we can do quick lookups by name.

#### Generate the migration

Now that we have an idea on how we want the Dog to be modeled lets create a migration so that Ecto can create a database table.

We will use the [shortcut command](https://hexdocs.pm/phoenix/Mix.Tasks.Phx.Gen.Context.html) `mix phx.gen.context` to generate the Context, Model, and Migration all in one go. Don't worry if you forgot any fields in the command as we can always add them later.

```bash
$ mix phx.gen.context Friends Dog dogs name:string breed:string description:string birthday:utc_datetime

    * creating lib/club_backend/friends/dog.ex
    * creating priv/repo/migrations/20200730030529_create_dogs.exs
    * creating lib/club_backend/friends.ex
    * injecting lib/club_backend/friends.ex
    * creating test/club_backend/friends_test.exs
    * injecting test/club_backend/friends_test.exs
```

#### Modify the migration

Now lets open the brand new migration file found in /priv/repo/migrations which should look like this:

```elixir
defmodule ClubBackend.Repo.Migrations.CreateDogs do
  use Ecto.Migration

  def change do
    create table(:dogs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :breed, :string
      add :description, :string
      add :birthday, :utc_datetime

      timestamps()
    end

  end
end
```

As you can see we didn't have to specify the primary key and it was created for us, along with `timestamps()` which gives us created_at and updated_at.

Here we can add any more fields we want to the table and indexes. Lets add the new index and make name required, or not null.

```elixir
defmodule ClubBackend.Repo.Migrations.CreateDogs do
  use Ecto.Migration

  def change do
    create table(:dogs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :breed, :string
      add :description, :string, null: false
      add :birthday, :utc_datetime

      timestamps()
    end

    create index(:dogs, [:name])
  end
end
```

#### Migrate the database

Now to create this table in the database we run this command:

```bash
$ mix ecto.migrate

    23:10:31.825 [info]  == Running 20200730030529 ClubBackend.Repo.Migrations.CreateDogs.change/0 forward

    23:10:31.827 [info]  create table dogs

    23:10:31.845 [info]  create index dogs_name_index

    23:10:31.849 [info]  == Migrated 20200730030529 in 0.0s
```

This as you can see creates the table. If we missed something we can always roll back these changes with:

```bash
$ mix ecto.rollback

    23:10:39.149 [info]  == Running 20200730030529 ClubBackend.Repo.Migrations.CreateDogs.change/0 backward

    23:10:39.150 [info]  drop index dogs_name_index

    23:10:39.156 [info]  drop table dogs

    23:10:39.159 [info]  == Migrated 20200730030529 in 0.0s
```

#### Modify the model

Now lets open the `/lib/club_backend/friends/dog.ex` file.

This should look like:

```elixir
defmodule ClubBackend.Friends.Dog do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "dogs" do
    field :birthday, :utc_datetime
    field :breed, :string
    field :description, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(dog, attrs) do
    dog
    |> cast(attrs, [:name, :breed, :description, :birthday])
    |> validate_required([:name, :breed, :description, :birthday])
  end
end
```

As you can see the fields we specified are already created here but we could add new fields to both this and the migration.

We only want to ensure that there is a name and a description for the dogs so we can modify the `validate_required` function to only check for these fields.

```elixir
def changeset(dog, attrs) do
    dog
    |> cast(attrs, [:name, :breed, :description, :birthday])
    |> validate_required([:name, :description])
end
```

Next we want to ensure that users provide a good description for their dogs so lets ensure that the length is at least 20 characters. We can do this by adding another function to the changeset. You can find all of the builtin functions [here.](https://hexdocs.pm/ecto/Ecto.Changeset.html)

```elixir
def changeset(dog, attrs) do
    dog
    |> cast(attrs, [:name, :breed, :description, :birthday])
    |> validate_required([:name, :description])
    |> validate_length(:description, min: 20)
end
```

The last thing we want to do is tell the JSON encoder what fields we want to export when we serialize/output the data. So all together

```elixir
defmodule ClubBackend.Friends.Dog do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:birthday, :breed, :description, :name]}
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "dogs" do
    field :birthday, :utc_datetime
    field :breed, :string
    field :description, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(dog, attrs) do
    dog
    |> cast(attrs, [:name, :breed, :description, :birthday])
    |> validate_required([:name, :description])
    |> validate_length(:description, min: 20)
  end
end
```

### Frontend/Presentation

Now we can add files to the /lib/club_backend_web/ in order to serve the Dogs to the public.

#### Creating the Controller and View

The first thing we need to do is create the controller. Lets create a file called `dog_controller.ex` in `/lib/club_backend_web/controllers` and add the following:

```elixir
defmodule ClubBackendWeb.DogController do
  use ClubBackendWeb, :controller

end
```

This is the minimum needed to create a controller with no handlers. Learn more about [controllers here.](https://hexdocs.pm/phoenix/controllers.html)

Now lets create the view in `/lib/club_backend_web/views/dog_view.ex`.

```elixir
defmodule ClubBackendWeb.AuthView do
  use ClubBackendWeb, :view

end
```

This is also the bare minimum needed to create a view. Learn more about [views here.](https://hexdocs.pm/phoenix/views.html)

#### List all the Dogs

Lets add an `index` handler to get all of the dogs. The first thing we should do is add to the controller.

```elixir
defmodule ClubBackendWeb.DogController do
  use ClubBackendWeb, :controller

  # Alias the Friends context so that we don't have to use the full path
  alias ClubBackend.Friends

  # We don't care about the parameters for listing all the dogs
  def index(conn, _params) do
    # Get all the dogs using the Friends context
    dogs = Friends.list_dogs()

    # Calls the same named view using the same connection, a handler named index.json, and params friends
    # The params are just named arbitrarily and could change to whatever you want to call it. Just make sure the view matches!
    render(conn, "index.json", %{friends: dogs})
  end
end
```

Now that the controller is done lets move on to the view:

```elixir
defmodule ClubBackendWeb.DogView do
  use ClubBackendWeb, :view

  # Here we pattern match on the name and the structure of the parameters.
  def render("index.json", %{friends: dogs}) do
    # We return this map which will get ~automagically~ transformed into JSON. We could do other data transformations here.
    %{dogs: dogs}
  end
end
```

Final step is to modify the `/lib/club_backend_web/router.ex` file to add our new route.

As of writing this guide the `router.ex` file looks like the following:

```elixir
defmodule ClubBackendWeb.Router do
  use ClubBackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  get "/ping", ClubBackendWeb.PingController, :ping

  scope "/api", ClubBackendWeb do
    pipe_through :api

    post "/auth/login", AuthController, :login
    post "/auth/register", AuthController, :register
  end

  # ... TRIMED BELOW ...
end
```

To learn more about routing [click here.](https://hexdocs.pm/phoenix/routing.html)

Lets add a GET request under the "/api" scope to fetch our dogs:

```elixir
defmodule ClubBackendWeb.Router do
  use ClubBackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  get "/ping", ClubBackendWeb.PingController, :ping

  scope "/api", ClubBackendWeb do
    pipe_through :api

    get "/dogs", DogController, :index

    post "/auth/login", AuthController, :login
    post "/auth/register", AuthController, :register
  end

  # ... TRIMED BELOW ...
end
```

#### Running our Example

Now we can see this in action by running:

```bash
$ mix phx.server

[info] Running ClubBackendWeb.Endpoint with cowboy 2.8.0 at 0.0.0.0:4000 (http)
[info] Access ClubBackendWeb.Endpoint at http://localhost:4000
```

And you can either go to <http://localhost:4000/api/dogs> or run the following command:

```bash
$ curl http://localhost:4000/api/dogs

{"dogs":[]}
```

Great! We can see that our controller is working and is rendering output to JSON.

You can also see in the console you ran the `phx.server` in that our database is being queried. Run the curl again or refresh the page a few times and see the response time.

```log
info] GET /api/dogs
[debug] Processing with ClubBackendWeb.DogController.index/2
  Parameters: %{}
  Pipelines: [:api]
[debug] QUERY OK source="dogs" db=0.2ms idle=577.3ms
SELECT d0."id", d0."birthday", d0."breed", d0."description", d0."name", d0."inserted_at", d0."updated_at" FROM "dogs" AS d0 []
[info] Sent 200 in 568µs
[info] GET /api/dogs
[debug] Processing with ClubBackendWeb.DogController.index/2
  Parameters: %{}
  Pipelines: [:api]
[debug] QUERY OK source="dogs" db=1.5ms idle=754.3ms
SELECT d0."id", d0."birthday", d0."breed", d0."description", d0."name", d0."inserted_at", d0."updated_at" FROM "dogs" AS d0 []
[info] Sent 200 in 1ms
```

Wow you can see response times as little as 568 micro seconds!

#### Seeds

First you can end the server by pressing CTRL + C in the terminal you stared it in. 

Lets add a few seed pets so that our response is nicer. Open up `/priv/repo/seeds.exs`

And modify it to add the following:

```elixir
ClubBackend.Friends.create_dog(%{
    birthday: ~U[2010-05-05 00:00:01Z],
    breed: "Lab",
    description: "A friendly laborador friend.",
    name: "Pal"
})
```

Now we can run the seed file directly with:

```elixir
$ mix run priv/repo/seeds.exs

[debug] QUERY OK db=0.9ms queue=0.6ms idle=311.7ms
INSERT INTO "dogs" ("birthday","breed","description","name","inserted_at","updated_at","id") VALUES ($1,$2,$3,$4,$5,$6,$7) [~U[2010-05-05 00:00:01Z], "Lab", "A friendly laborador friend.", "Pal", ~N[2020-07-31 01:55:40], ~N[2020-07-31 01:55:40], <<212, 190, 250, 163, 15, 16, 64, 164, 175, 158, 81, 82, 179, 231, 72, 240>>]
```

Lets start the server back up with `mix phx.server` and make the /api/dogs request again. Now you should get back something like this:

`{"dogs":[{"birthday":"2010-05-05T00:00:01Z","breed":"Lab","description":"A friendly laborador friend.","name":"Pal"}]}`

#### Exercise Left to the Reader

For your exercise add a way to create new dogs. This will require you to add a new function to the controller and view.

For the index handler in the controller we ignored the params argument but we can pattern match it to get any information we want. For example if we wanted the fields `colors` and `fish` we could've written our function like:

```elixir
def index(conn, %{colors: colors, fish: fish}) do
    ...
end
```

This would only run if the structure of the parameters matches what we gave it.

Some starting points:

- Add a function `new(conn, %{... your params go here ...})` to the controller
- Use the `Friends.create_dog` function in the same way as the `seeds.exs` file and pass the output to the view
- Add a function to the view to send the result back to the requester
- Instead of a GET request in `router.ex` you probably want a POST request
- To test your function you can curl a POST request like: `curl -X POST -d '{"fish":"test", "color":"test"}' -H "Content-Type: application/json" http://localhost:8088/api/dogs/new`
