defmodule ClubBackendWeb.EventView do
  use ClubBackendWeb, :view
  alias ClubBackendWeb.EventView

  def render("index.json", %{events: events}) do
    %{data: render_many(events, EventView, "event.json")}
  end

  def render("show.json", %{event: event}) do
    %{data: render_one(event, EventView, "event.json")}
  end

  def render("event.json", %{event: event}) do
    %{
      id: event.id,
      title: event.title,
      description: event.description,
      location: event.location,
      category: event.category,
      start_dt: event.start_dt,
      end_dt: event.end_dt
    }
  end
end
