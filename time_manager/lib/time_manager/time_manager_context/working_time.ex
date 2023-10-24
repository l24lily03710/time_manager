defmodule TimeManager.TimeManagerContext.WorkingTime do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "workingtimes" do
    field :start, :naive_datetime
    field :end, :naive_datetime
    field :user, :binary_id, foreign_key: :user
    
    timestamps()
  end

  @doc false
  def changeset(working_time, attrs) do
    working_time
    |> cast(attrs, [:start, :end])
    |> validate_required([:start, :end])
    |> validate_format(:start, ~r/\A\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\z/, message: "Le format de début n'est pas valide (YYYY-MM-DD HH:MM:SS)")
    |> validate_format(:end, ~r/\A\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\z/, message: "Le format de fin n'est pas valide (YYYY-MM-DD HH:MM:SS)")
  end
end
