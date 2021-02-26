defmodule ClubBackend.Factory do
  use ExMachina.Ecto, repo: ClubBackend.Repo

  @test_categories ["Casual Coding", "GBM", "Social Event"]

  def user_factory do
    %ClubBackend.Accounts.User{
      email: sequence(:email, &"email-#{&1}@example.com"),
      username: sequence(:username, &"user-#{&1}"),
      password: "password",
      is_officer: false
    }
  end

  def event_factory do
    %ClubBackend.Events.Event{
      category: sequence(:category, @test_categories),
      description: sequence(:description, &"Event Description - #{&1}"),
      location: sequence(:location, &"A cool test location #{&1}"),
      title: sequence(:title, &"A Cool Test Event - #{&1}"),
      start_dt: DateTime.now("America/New York"),
      end_dt: DateTime.now("America/New York")
    }
  end

  def make_admin(user) do
    %{user | is_officer: true}
  end

end
