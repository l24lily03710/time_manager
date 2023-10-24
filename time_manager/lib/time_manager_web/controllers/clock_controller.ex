defmodule TimeManagerWeb.ClockController do
  use TimeManagerWeb, :controller

  alias TimeManager.TimeManagerContext
  alias TimeManager.TimeManagerContext.Clock

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    clocks = TimeManagerContext.list_clocks()
    render(conn, "index.json", clocks: clocks)
  end

  def create(conn, %{"clock" => clock_params}) do
    with {:ok, %Clock{} = clock} <- TimeManagerContext.create_clock(clock_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.clock_path(conn, :show, clock))
      |> render("show.json", clock: clock)
    end
  end

  def show(conn, %{"id" => id}) do
    clock = TimeManagerContext.get_clock!(id)
    render(conn, "show.json", clock: clock)
  end

  def update(conn, %{"id" => id, "clock" => clock_params}) do
    clock = TimeManagerContext.get_clock!(id)

    with {:ok, %Clock{} = clock} <- TimeManagerContext.update_clock(clock, clock_params) do
      render(conn, "show.json", clock: clock)
    end
  end

  def delete(conn, %{"id" => id}) do
    clock = TimeManagerContext.get_clock!(id)

    with {:ok, %Clock{}} <- TimeManagerContext.delete_clock(clock) do
      send_resp(conn, :no_content, "")
    end
  end
end
