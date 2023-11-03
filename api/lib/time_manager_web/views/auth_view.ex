defmodule TimeManagerWeb.AuthView do
  use TimeManagerWeb, :view

  def render("login.json", %{user: user, token: token}) do
    %{data: %{user: render_user(user), token: token}}
  end

  defp render_user(%TimeManager.TimeManagerContext.User{email: email, username: username}) do
    %{email: email, username: username}
  end

  defp render_user_with_password(%TimeManager.TimeManagerContext.User{email: email, username: username, password: password}) do
    %{email: email, username: username, password: password}
  end
end
