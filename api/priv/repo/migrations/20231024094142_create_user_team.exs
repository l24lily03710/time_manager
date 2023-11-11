defmodule TimeManager.Repo.Migrations.CreateUserTeam do
  use Ecto.Migration

  def change do
    create table(:user_teams, primary_key: false) do
      add :team_id, references(:teams, type: :integer, on_delete: :delete_all)
      add :user_id, references(:users, type: :integer, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:user_teams, [:team_id, :user_id], primary_key: true)
  end
end
