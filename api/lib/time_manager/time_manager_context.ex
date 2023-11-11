defmodule TimeManager.TimeManagerContext do
  @moduledoc """
  The TimeManagerContext context.
  """

  import Ecto.Query, warn: false
  alias TimeManager.Repo

  alias TimeManager.TimeManagerContext.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user(id) when is_binary(id) do
    Repo.get!(User, id)
  end

  def authenticate(email, password) do
    case Repo.get_by(User, email: email) do
      nil -> {:error, "User not found"}
      user ->
        if Bcrypt.verify_pass(password, user.password) do
          {:ok, user}
        else
          {:error, "Invalid password"}
        end
    end
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    # Compte le nombre d'utilisateurs dans la base de données
    user_count = Repo.aggregate(User, :count, :id)

    # Détermine le rôle en fonction du nombre d'utilisateurs
    role = if user_count == 0 do
             2  # Premier utilisateur, attribuer le rôle d'administrateur
           else
             0  # Les utilisateurs suivants auront un rôle différent (par exemple, 1 pour utilisateur standard)
           end

    user = %User{role: role}
    |> User.changeset(attrs)
    |> Ecto.Changeset.update_change(:password, &hash_password/1)
    |> Repo.insert()

    user
  end

  defp hash_password(password) do
    Bcrypt.hash_pwd_salt(password)
  end


  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  alias TimeManager.TimeManagerContext.Clock

  @doc """
  Returns the list of clocks.

  ## Examples

      iex> list_clocks()
      [%Clock{}, ...]

  """
  def list_clocks do
    Repo.all(Clock)
  end

  @doc """
  Gets a single clock.

  Raises `Ecto.NoResultsError` if the Clock does not exist.

  ## Examples

      iex> get_clock!(123)
      %Clock{}

      iex> get_clock!(456)
      ** (Ecto.NoResultsError)

  """
  def get_clock!(id), do: Repo.get!(Clock, id)
  def get_clock(id) when is_binary(id) do
    Repo.get(Clock, id)
  end

  @doc """
  Creates a clock.

  ## Examples

      iex> create_clock(%{field: value})
      {:ok, %Clock{}}

      iex> create_clock(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_clock(attrs \\ %{}) do
    %Clock{}
    |> Clock.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a clock.

  ## Examples

      iex> update_clock(clock, %{field: new_value})
      {:ok, %Clock{}}

      iex> update_clock(clock, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_clock(%Clock{} = clock, attrs) do
    clock
    |> Clock.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a clock.

  ## Examples

      iex> delete_clock(clock)
      {:ok, %Clock{}}

      iex> delete_clock(clock)
      {:error, %Ecto.Changeset{}}

  """
  def delete_clock(%Clock{} = clock) do
    Repo.delete(clock)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking clock changes.

  ## Examples

      iex> change_clock(clock)
      %Ecto.Changeset{data: %Clock{}}

  """
  def change_clock(%Clock{} = clock, attrs \\ %{}) do
    Clock.changeset(clock, attrs)
  end

  alias TimeManager.TimeManagerContext.WorkingTime

  @doc """
  Returns the list of workingtimes.

  ## Examples

      iex> list_workingtimes()
      [%WorkingTime{}, ...]

  """
  def list_workingtimes do
    Repo.all(WorkingTime)
  end

  @doc """
  Gets a single working_time.

  Raises `Ecto.NoResultsError` if the Working time does not exist.

  ## Examples

      iex> get_working_time!(123)
      %WorkingTime{}

      iex> get_working_time!(456)
      ** (Ecto.NoResultsError)

  """
  def filter_workingTime_by(user_id, start_date, end_date) do
    from(wt in WorkingTime,
      where: wt.user_id == ^user_id and wt.start >= ^start_date and wt.end <= ^end_date)
    |> Repo.all()
  end

  def get_workingtime(id) when is_binary(id) do
    id
    |> String.to_integer()
    |> get_workingtime()
  end

  def get_workingtime(id) when is_integer(id) do
    Repo.get(WorkingTime, id)
  end


  def get_workingtime_by_user_and_id(user_id, workingtime_id) do
    from(wt in WorkingTime,
      where: wt.user_id == ^user_id and wt.id == ^workingtime_id)
    |> Repo.one()
  end

  @doc """
  Creates a working_time.

  ## Examples

      iex> create_working_time(%{field: value})
      {:ok, %WorkingTime{}}

      iex> create_working_time(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_workingtime(attrs \\ %{}) do
    %WorkingTime{}
    |> WorkingTime.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a working_time.

  ## Examples

      iex> update_working_time(working_time, %{field: new_value})
      {:ok, %WorkingTime{}}

      iex> update_working_time(working_time, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_working_time(%WorkingTime{} = working_time, attrs) do
    working_time
    |> WorkingTime.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a working_time.

  ## Examples

      iex> delete_working_time(working_time)
      {:ok, %WorkingTime{}}

      iex> delete_working_time(working_time)
      {:error, %Ecto.Changeset{}}

  """
  def delete_working_time(%WorkingTime{} = working_time) do
    Repo.delete(working_time)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking working_time changes.

  ## Examples

      iex> change_working_time(working_time)
      %Ecto.Changeset{data: %WorkingTime{}}

  """
  def change_working_time(%WorkingTime{} = working_time, attrs \\ %{}) do
    WorkingTime.changeset(working_time, attrs)
  end

  def find_clock(userID) do
    query = from(c in Clock, where: c.user_id == ^userID, select: c)
    Repo.all(query)
  end

  alias TimeManager.TimeManagerContext.Team

  def list_user_teams(user_id) when is_binary(user_id) do
    user = get_user(user_id)

    user
    |> Ecto.assoc(:teams)
    |> Repo.all()
  end

  def list_teams do
    from(t in Team, select: t)
    |> Repo.all()
  end

  def get_team(team_id) when is_binary(team_id) do
    Repo.get(Team, team_id)
  end

  def add_user_to_team(user_id, team_id) do
    case {Repo.get(User, user_id), Repo.get(Team, team_id)} do
      {nil, _} ->
        {:error, "L'utilisateur avec l'ID #{user_id} n'existe pas."}

      {_, nil} ->
        {:error, "L'équipe avec l'ID #{team_id} n'existe pas."}

      {user, team} ->
        case Ecto.Changeset.change(user)
        |> Ecto.Changeset.put_assoc(:teams, [team])
        |> Repo.update() do
          {:ok, updated_user} ->
            {:ok, updated_user}

          {:error, changeset_errors} ->
            {:error, changeset_errors}
        end
    end
  end


  def clear_user_team(user_id) do
    case Repo.get(User, user_id) do
      nil ->
        {:error, "L'utilisateur avec l'ID #{user_id} n'existe pas."}

      user ->
        case Ecto.Changeset.change(user)
        |> Ecto.Changeset.put_assoc(:teams, [])
        |> Repo.update() do
          {:ok, updated_user} ->
            {:ok, updated_user}

          {:error, changeset_errors} ->
            {:error, changeset_errors}
        end
    end
  end


  def create_team(attrs) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  def set_user_role(user_id, new_role) do
    user = Repo.get(User, user_id)
    case user do
      %User{} = user ->
        user
        |> Ecto.Changeset.change(role: new_role)
        |> Repo.update()
        |> case do
          {:ok, user} -> {:ok, user}
          {:error, changeset} -> {:error, changeset.errors}
        end
      _ ->
        {:error, "Utilisateur introuvable"}
    end
  end

  def delete_team(teamID) do
  case TimeManager.TimeManagerContext.get_team(teamID) do
    %Team{} = team ->
      case Repo.delete(team) do
        {:ok, _} -> {:ok, "Équipe supprimée avec succès."}
        _ -> {:error, "Impossible de supprimer l'équipe."}
      end
    nil -> {:error, "L'équipe n'existe pas."}
  end
end

end