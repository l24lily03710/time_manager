  defmodule TimeManagerWeb.TeamController do
    use TimeManagerWeb, :controller

    action_fallback TimeManagerWeb.FallbackController

    def index(conn, %{"userID" => userID}) do
      user = TimeManager.TimeManagerContext.get_user!(userID)

      teams =
        case user.role do
          2 ->
            # Si le rôle de l'utilisateur est égal à 2, renvoyer toutes les équipes
            TimeManager.TimeManagerContext.list_teams()
          _ ->
            # Si le rôle de l'utilisateur est 0 ou 1, renvoyer seulement les équipes liées à l'utilisateur
            TimeManager.TimeManagerContext.list_user_teams(userID)
        end

      render(conn, "index.json", teams: teams)
    end

    def show(conn, %{"teamID" => teamID}) do
      team = TimeManager.TimeManagerContext.get_team(teamID)

      case team do
        %TimeManager.TimeManagerContext.Team{} ->
          # Si l'équipe existe, renvoyer les détails de l'équipe
          render(conn, "show.json", team: team)
        _ ->
          # Si l'équipe n'existe pas, renvoyer une réponse d'erreur
          conn
          |> put_status(:not_found)
          |> render("error.json", message: "L'équipe n'existe pas.")
      end
    end

    def add_user(conn, %{"user_id" => user_id, "team_id" => team_id}) do
      case TimeManager.TimeManagerContext.add_user_to_team(user_id, team_id) do
        {:ok, _team} ->
          conn
          |> put_status(:ok)
          |> json(%{message: "Utilisateur ajouté à l'équipe avec succès"})

        {:error, reason} ->
          conn
          |> put_status(422)  # Statut HTTP pour une validation incorrecte
          |> json(%{errors: reason})
      end
    end

    def clear_user_team(conn, %{"user_id" => user_id}) do
      case TimeManager.TimeManagerContext.clear_user_team(user_id) do
        {:ok, team} ->
          conn
          |> put_status(:ok)
          |> render("show.json", team: team)

        {:error, reason} ->
          conn
          |> put_status(422)
          |> render("error.json", message: "L'user n'existe pas.")
      end
    end

    def create(conn, %{"team" => team_params}) do
      case TimeManager.TimeManagerContext.create_team(team_params) do
        {:ok, team} ->
          conn
          |> put_status(:ok)
          |> render("show.json", team: team)

        {:error, changeset} ->
          conn
          |> put_status(422)  # Statut HTTP pour une validation incorrecte
          |> render("new.json", changeset: changeset)
      end
    end

    def delete(conn, %{"teamID" => teamID}) do
      case TimeManager.TimeManagerContext.delete_team(teamID) do
        {:ok, message} ->
          conn
          |> put_status(:ok)
          |> json(%{message: message})

        {:error, error_message} ->
          conn
          |> put_status(:not_found)  # Vous pouvez utiliser un autre statut HTTP approprié
          |> json(%{error: error_message})
      end
    end
  end
