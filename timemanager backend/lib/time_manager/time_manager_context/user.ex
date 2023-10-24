defmodule TimeManager.TimeManagerContext.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :status, :boolean, default: false
    field :time, :string
    field :username, :string
    field :email, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :time, :status])
    |> validate_required([:username, :email, :time, :status])
  end
end
