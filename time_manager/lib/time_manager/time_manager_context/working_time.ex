defmodule TimeManager.TimeManagerContext.WorkingTime do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workingtimes" do
    field :end, :naive_datetime
    field :start, :naive_datetime
    belongs_to :user, TimeManager.TimeManagerContext.User

    timestamps()
  end

  defp add_datetime_error(changeset, field, message) do
    add_error(changeset, field, message)
  end

  def validate_datetime(changeset, field) do
    value = get_field(changeset, field)

    case value do
      %NaiveDateTime{} -> changeset
      _ -> add_datetime_error(changeset, field, "Invalid datetime format, it should be YYYY - MM - DD HH : mm : ss")
    end
  end

  @doc false
  def changeset(working_time, attrs) do
    working_time
    |> cast(attrs, [:start, :end])
    |> validate_required([:start, :end])
    |> validate_datetime(:start)
    |> validate_datetime(:end)
  end
end
