defmodule TimeManagerWeb.WorkingTimeController do
  use TimeManagerWeb, :controller

  alias TimeManager.TimeManagerContext
  alias TimeManager.TimeManagerContext.WorkingTime

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    workingtimes = TimeManagerContext.list_workingtimes()
    render(conn, "index.json", workingtimes: workingtimes)
  end

  def create(conn, %{"working_time" => working_time_params}) do
    case TimeManagerContext.create_working_time(working_time_params) do
      {:ok, %WorkingTime{} = working_time} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.working_time_path(conn, :show, working_time))
        |> render("show.json", working_time: working_time)

      {:error, _changeset} ->
        conn
        |> put_status(422)  # Statut HTTP pour une validation incorrecte
        |> json(%{error: "La création du working time a échoué."})
    end
  end

  def show(conn, %{"id" => id}) do
    working_time = TimeManagerContext.get_working_time!(id)
    render(conn, "show.json", working_time: working_time)
  end

  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = TimeManagerContext.get_working_time!(id)

    with {:ok, %WorkingTime{} = working_time} <- TimeManagerContext.update_working_time(working_time, working_time_params) do
      render(conn, "show.json", working_time: working_time)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = TimeManagerContext.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- TimeManagerContext.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end
end
