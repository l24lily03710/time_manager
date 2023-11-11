defmodule TimeManager.Repo.Migrations.CreateClocks do
  use Ecto.Migration

  def change do
    create table(:clocks) do
      add :time, :utc_datetime
      add :status, :boolean, default: false, null: false
      add :user, references(:users, on_delete: :delete_all, type: :integer)

      timestamps(type: :utc_datetime)
    end

    create index(:clocks, [:user])
  end
end