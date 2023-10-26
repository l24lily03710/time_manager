defmodule TimeManager.TimeManagerContext.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :email, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email])
    |> validate_required([:username, :email])
    |> validate_format(:email, ~r/\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\z/, message: "L'adresse e-mail n'est pas au bon format.")
    |> unique_constraint(:email, message: "Cette adresse e-mail est déjà utilisée.")
  end
end
