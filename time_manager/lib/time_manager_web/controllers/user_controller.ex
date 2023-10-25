defmodule TimeManagerWeb.UserController do
  use TimeManagerWeb, :controller

  alias TimeManager.TimeManagerContext
  alias TimeManager.TimeManagerContext.User

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

  def index(conn, %{"email" => email, "username" => username}) do
    users = TimeManagerContext.list_users()
    users_filtres = Enum.filter(users, fn user -> user.email == email end)
    users_filtres_final = Enum.filter(users_filtres, fn user -> user.username == username end)

    render(conn, "index.json", users: users_filtres_final)
  end

  def index(conn, %{"email" => email}) do
    users = TimeManagerContext.list_users()
    users_filtres = Enum.filter(users, fn user -> user.email == email end)

    render(conn, "index.json", users: users_filtres)
  end

  def index(conn, %{"username" => username}) do
    users = TimeManagerContext.list_users()
    users_filtres = Enum.filter(users, fn user -> user.username == username end)

    render(conn, "index.json", users: users_filtres)
  end

  def index(conn, _params) do
    users = TimeManagerContext.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    case TimeManagerContext.create_user(user_params) do
      {:ok, %User{} = user} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.user_path(conn, :show, user))
        |> render("show.json", user: user)

      {:error, changeset} ->
        conn
        |> put_status(422)  # Statut HTTP pour une validation incorrecte
        |> json(%{errors: changeset_error_to_string(changeset)})
    end
  end

  def show(conn, %{"id" => id}) do
    user = TimeManagerContext.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = TimeManagerContext.get_user!(id)

    with {:ok, %User{} = user} <- TimeManagerContext.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = TimeManagerContext.get_user!(id)

    with {:ok, %User{}} <- TimeManagerContext.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
