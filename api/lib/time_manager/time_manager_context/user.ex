defmodule TimeManager.TimeManagerContext.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :email, :username, :role, :inserted_at, :updated_at]}
  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string
    field :role, :integer

    timestamps(type: :utc_datetime)
  end

  @spec changeset(
          {map(), map()}
          | %{
              :__struct__ => atom() | %{:__changeset__ => map(), optional(any()) => any()},
              optional(atom()) => any()
            },
          :invalid | %{optional(:__struct__) => none(), optional(atom() | binary()) => any()}
        ) :: Ecto.Changeset.t()
  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password])
    |> validate_required([:username, :email, :password])
    |> validate_format(:email, ~r/\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\z/, message: "L'adresse e-mail n'est pas au bon format.")
    |> unique_constraint(:email, message: "Cette adresse e-mail est déjà utilisée.")
  end
end