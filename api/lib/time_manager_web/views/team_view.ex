defmodule TimeManagerWeb.TeamView do
  use TimeManagerWeb, :view

  def render("show.json", %{team: team}) do
    %{data: render_team(team)}
  end

  def render("index.json", %{teams: teams}) do
    %{data: Enum.map(teams, &render_team/1)}
  end

  def render("error.json", %{message: message}) do
    %{error: %{message: message}}
  end

  def render("new.json", %{changeset: changeset}) do
    %{error: %{message: "Échec de la création d'équipe", errors: changeset.errors}}
  end

  defp render_team(team) do
    %{
      id: team.id,
      name: team.name,
      inserted_at: team.inserted_at,
      updated_at: team.updated_at
    }
  end

end
