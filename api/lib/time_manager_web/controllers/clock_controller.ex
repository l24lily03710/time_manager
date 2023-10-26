defmodule TimeManagerWeb.ClockController do
  use TimeManagerWeb, :controller

  alias TimeManager.TimeManagerContext
  alias TimeManager.TimeManagerContext.Clock

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, %{"userID" => userID}) do
    clocks = TimeManagerContext.find_clock(userID)
    render(conn, "index.json", clocks: clocks)
  end

  def create(conn, %{"clock" => clock_params, "userID" => userID}) do
    case TimeManagerContext.create_clock(Map.put(clock_params, "user_id", userID)) do
      {:ok, %Clock{} = clock} ->
        conn
        |> put_status(:created)
        |> render("construct.json", clock: clock, user_id: userID)
      {:error, _changeset} ->
        conn
        |> put_status(422)
        |> json(%{error: "La création de la clock a échoué."})
    end
  end


  def show(conn, %{"userID" => id}) do
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
