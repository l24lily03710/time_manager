defmodule TimeManagerWeb.AuthController do
  use TimeManagerWeb, :controller
  alias TimeManager.TimeManagerContext
  alias TimeManager.Guardian

  def register(conn, %{"user" => user_params}) do
    case TimeManagerContext.create_user(user_params) do
      {:ok, user} ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user)
        conn
        |> put_status(:created)
        |> render("login.json", user: user, token: token)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TimeManagerWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def login(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case TimeManagerContext.authenticate(email, password) do
      {:ok, user} ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user)
        conn
        |> render("login.json", user: user, token: token)
      {:error, _reason} ->
        conn
        |> put_status(:unauthorized)
        |> render(TimeManagerWeb.ErrorView, "401.json", reason: "Invalid email or password")
    end
  end
end