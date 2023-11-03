defmodule TimeManager.Guardian do
  require Logger
  use Guardian, otp_app: :time_manager

  alias TimeManager.TimeManagerContext

  def subject_for_token(resource, _claims) do
    sub = to_string(resource.id)
    {:ok, sub}
  end

  def resource_from_claims(%{"sub" => id}) do
    {:ok, TimeManagerContext.get_user(id)}
  end
end

defmodule TimeManager.FetchCurrentUser do
  import Plug.Conn

  def init(options), do: options

  def call(conn, _options) do
    # Guardian.Plug.current_resource/1 returns the current user
    current_user = Guardian.Plug.current_resource(conn)

    # Assign the current user to the connection
    assign(conn, :current_user, current_user)
  end
end
