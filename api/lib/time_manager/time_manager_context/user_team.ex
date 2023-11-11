defmodule TimeManager.TimeManagerContext.UserTeam do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "user_teams" do
    belongs_to :team, TimeManager.TimeManagerContext.Team, type: :integer, primary_key: true
    belongs_to :user, TimeManager.TimeManagerContext.User, type: :integer, primary_key: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user_teams, attrs) do
    user_teams
    |> cast(attrs, [:team_id, :user_id])
    |> validate_required([:team_id, :user_id])
  end
end
