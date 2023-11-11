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

    case users do
      nil ->
        conn
          |> put_status(:not_found)
          |> render("error.json", message: "Erreur lors de la récupération de la liste des utilisateurs")
      users ->
        users_filtres = Enum.filter(users, fn user -> user.email == email end)
        users_filtres_final = Enum.filter(users_filtres, fn user -> user.username == username end)
        conn
          |> put_status(:ok)
          |> render("index.json", users: users_filtres_final)
      end
  end


  def index(conn, %{"email" => email}) do
    users = TimeManagerContext.list_users()

    case users do
      nil ->
        conn
          |> put_status(:not_found)
          |> render("error.json", message: "Erreur lors de la récupération de la liste des utilisateurs")
      users ->
        users_filtres = Enum.filter(users, fn user -> user.email == email end)
        conn
          |> put_status(:ok)
          |> render("index.json", users: users_filtres)
      end
  end


  def index(conn, %{"username" => username}) do
    users = TimeManagerContext.list_users()

    case users do
      nil ->
        conn
          |> put_status(:not_found)
          |> render("error.json", message: "Erreur lors de la récupération de la liste des utilisateurs")
      user ->
        users_filter = Enum.filter(users, fn user -> user.username == username end)
        conn
          |> put_status(:ok)
          |> render("index.json", users: users_filter)
      end
  end


  def index(conn, _params) do
    users = TimeManagerContext.list_users()

    case users do
      nil ->
        conn
          |> put_status(:not_found)
          |> render("error.json", message: "Utilisateurs introuvables")
      users ->
        conn
          |> put_status(:ok)
          |> render("index.json", users: users)
      end
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
    user = TimeManager.TimeManagerContext.get_user(id)

    case user do
      nil ->
        conn
          |> put_status(:not_found)
          |> render("error.json", message: "Utilisateur introuvable")
      user ->
        conn
          |> put_status(:ok)
          |> render("show.json", user: user)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = TimeManagerContext.get_user(id)
    with {:ok, %User{} = updated_user} <- TimeManagerContext.update_user(user, user_params) do
      conn
        |> put_status(:ok)
        |> render("show.json", user: updated_user)
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TimeManagerWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = TimeManagerContext.get_user!(id)
    with {:ok, _} <- TimeManagerContext.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def update_role(conn, %{"requester_id" => requester_id, "target_id" => target_id, "new_role" => new_role}) do
    requester = TimeManager.TimeManagerContext.get_user(requester_id)
    IO.inspect(new_role)

    # check that new_role is valid
    case requester.role do
      2 ->
        role =
          case new_role do
            "0" -> 0
            "1" -> 1
            "2" -> 2
            _ ->
              conn
              |> put_status(:bad_request)
              |> render("error.json", message: "Rôle invalide. Assurez-vous que new_role est une valeur valide.")
              |> halt()
          end

        # Continue with the rest of your logic...
        case TimeManager.TimeManagerContext.set_user_role(target_id, role) do
          {:ok, user} ->
            conn
            |> put_status(:ok)
            |> render("show.json", user: user)
          {:error, message} ->
            conn
            |> put_status(:not_found)
            |> render("error.json", message: message)
        end
      _ ->
        conn
        |> put_status(:forbidden)
        |> render("error.json", message: "L'utilisateur n'est pas autorisé à effectuer cette action.")
    end
  end




end