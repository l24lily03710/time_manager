defmodule TimeManagerWeb.WorkingTimeController do
  use TimeManagerWeb, :controller

  alias TimeManager.TimeManagerContext
  alias TimeManager.TimeManagerContext.WorkingTime

  action_fallback TimeManagerWeb.FallbackController

  def changeset_error_to_string(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
    |> Enum.reduce("", fn {k, v}, acc ->
      joined_errors = Enum.join(v, "; ")
      "#{acc}#{k}: #{joined_errors}\n"
    end)
  end

  def index(conn, params) when is_map(params) do
    start = Map.get(params, "start", nil)
    end_date = Map.get(params, "end", nil)
    userID = Map.get(params, "userID", nil)

    working_times = TimeManagerContext.list_workingtimes()

    # Filtrer par userID
    working_times =
      working_times
      |> Enum.filter(fn wt -> userID == nil or wt.user_id == userID end)

    # Filtrer par date de début et de fin
    working_times =
      working_times
      |> Enum.filter(fn wt ->
        case {start, end_date} do
          {nil, nil} ->
            true
          {nil, _} ->
            DateTime.compare(wt.end_time, end_date) != :gt
          {_, nil} ->
            DateTime.compare(wt.start_time, start) != :lt
          {_, _} ->
            DateTime.compare(wt.start_time, start) != :lt and
            DateTime.compare(wt.end_time, end_date) != :gt
        end
      end)

    render(conn, "index.json", workingtimes: working_times)
  end

  def index(conn, _params) do
    workingtimes = TimeManagerContext.list_workingtimes()
    render(conn, "index.json", workingtimes: workingtimes)
  end

  def show(conn, %{"userID" => _userID, "id" => id}) do
    working_time = TimeManagerContext.get_working_time!(id)
    render(conn, "show.json", working_time: working_time)
  end

  def create(conn, %{"userID" => user_id, "working_time" => working_time_params}) do
    # Ajoutez l'ID de l'utilisateur aux paramètres de working_time
    working_time_params = Map.put(working_time_params, "user", user_id)

    case TimeManagerContext.create_working_time(working_time_params) do
      {:ok, %WorkingTime{} = working_time} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.working_time_path(conn, :index, working_time))
        |> render("show.json", working_time: working_time)

      {:error, _changeset} ->
        conn
        |> put_status(422)  # Statut HTTP pour une validation incorrecte
        |> json(%{error: "La création du working a échoué."})
    end
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
