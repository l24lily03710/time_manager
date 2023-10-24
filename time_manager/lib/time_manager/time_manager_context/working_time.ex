defmodule TimeManager.TimeManagerContext.WorkingTime do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workingtimes" do
    field :start, :naive_datetime
    field :end, :naive_datetime

    belongs_to :user, TimeManager.TimeManagerContext.User

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
