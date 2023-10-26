defmodule TimeManagerWeb.ClockView do
  use TimeManagerWeb, :view
  alias TimeManagerWeb.ClockView

  def render("index.json", %{clocks: clocks}) do
    %{data: render_many(clocks, ClockView, "clock.json")}
  end

  def render("show.json", %{clock: clock}) do
    %{data: render_one(clock, ClockView, "clock.json")}
  end

  def render("construct.json", %{clock: clock, user_id: user_id}) do
    %{
      data: %{
        id: clock.id,
        time: clock.time,
        status: clock.status,
        user_id: user_id
      }
    }
  end

  def render("clock.json", %{clock: clock}) do
    %{
      data: %{
        id: clock.id,
        time: clock.time,
        status: clock.status,
      }
    }
  end
end
