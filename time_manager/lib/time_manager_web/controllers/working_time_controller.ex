defmodule TimeManagerWeb.WorkingTimeController do
  use TimeManagerWeb, :controller

  alias TimeManager.TimeManagerContext
  alias TimeManager.TimeManagerContext.WorkingTime

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, %{"userID" => user_id, "start" => start, "end" => the_end}) do
    working_times = TimeManagerContext.filter_workingTime_by(user_id, start, the_end)
    render_json(conn, working_times)
  end

  def create(conn, %{"userID" => userID, "workingtime" => workingtime_params}) do
    with {:ok, %WorkingTime{} = working_time} <- TimeManagerContext.create_workingtime(Map.merge(%{"user_id" => userID}, workingtime_params)) do
      conn
      |> put_status(:created)
      |> render("show.json", working_time: working_time)
    end
  end


  def show(conn, %{"userID" => user_id, "id" => id}) do
    working_time = TimeManagerContext.get_workingtime_by_user_and_id(user_id, id)

    case working_time do
      nil ->
        send_resp(conn, 404, "Not Found")
      _ ->
        render_json(conn, [working_time])
    end
  end

  def update(conn, %{"id" => id, "workingtime" => working_time_params}) do
    working_time = TimeManagerContext.get_workingtime(id)

    with {:ok, %WorkingTime{} = updated_working_time} <- TimeManagerContext.update_working_time(working_time, working_time_params) do
      render(conn, "show.json", working_time: updated_working_time)
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TimeManagerWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = TimeManagerContext.get_workingtime(id)

    with {:ok, %WorkingTime{}} <- TimeManagerContext.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end

  defp render_json(conn, working_times) do
    working_times_json = Enum.map(working_times, fn wt ->
      %{
        id: wt.id,
        start: wt.start,
        end: wt.end,
        user_id: wt.user_id,
        inserted_at: wt.inserted_at,
        updated_at: wt.updated_at
      }
    end)
    json(conn, working_times_json)
  end

end
