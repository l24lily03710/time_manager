defmodule TimeManagerWeb.UserController do
  use TimeManagerWeb, :controller

  alias TimeManager.TimeManagerContext
  alias TimeManager.TimeManagerContext.User

  action_fallback TimeManagerWeb.FallbackController

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
        |> json(%{errors: Ecto.Changeset.traverse_errors(changeset, :email)})
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
