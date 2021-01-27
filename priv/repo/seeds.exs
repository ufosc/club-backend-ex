# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ClubBackend.Repo.insert!(%ClubBackend.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
ClubBackend.Accounts.create_user(%{
  email: "test@test.com",
  username: "test",
  password: "test"
})

ClubBackend.Accounts.create_user(%{
  email: "admin@ufopensource.club",
  username: "admin",
  password: "admin",
  is_officer: true
})
