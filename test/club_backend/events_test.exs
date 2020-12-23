defmodule ClubBackend.EventsTest do
  use ClubBackend.DataCase

  alias ClubBackend.Events

  describe "events" do
    alias ClubBackend.Events.Event

    @valid_attrs %{
      category: "some category",
      description: "some description",
      end_dt: ~N[2010-04-17 14:00:00],
      location: "some location",
      start_dt: ~N[2010-04-17 14:00:00],
      title: "some title"
    }
    @update_attrs %{
      category: "some updated category",
      description: "some updated description",
      end_dt: ~N[2011-05-18 15:01:01],
      location: "some updated location",
      start_dt: ~N[2011-05-18 15:01:01],
      title: "some updated title"
    }
    @invalid_attrs %{
      category: nil,
      description: nil,
      end_dt: nil,
      location: nil,
      start_dt: nil,
      title: nil
    }

    def event_fixture(attrs \\ %{}) do
      {:ok, event} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Events.create_event()

      event
    end

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Events.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Events.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      assert {:ok, %Event{} = event} = Events.create_event(@valid_attrs)
      assert event.category == "some category"
      assert event.description == "some description"
      assert event.end_dt == ~U[2010-04-17 14:00:00Z]
      assert event.location == "some location"
      assert event.start_dt == ~U[2010-04-17 14:00:00Z]
      assert event.title == "some title"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      assert {:ok, %Event{} = event} = Events.update_event(event, @update_attrs)
      assert event.category == "some updated category"
      assert event.description == "some updated description"
      assert event.end_dt == ~U[2011-05-18 15:01:01Z]
      assert event.location == "some updated location"
      assert event.start_dt == ~U[2011-05-18 15:01:01Z]
      assert event.title == "some updated title"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_event(event, @invalid_attrs)
      assert event == Events.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Events.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Events.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Events.change_event(event)
    end
  end
end
