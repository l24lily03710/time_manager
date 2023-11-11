defmodule TimeManagerWeb.Router do
  use TimeManagerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug CORSPlug
  end

  pipeline :authenticated do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer", module: TimeManager.Guardian, error_handler: TimeManager.GuardianErrorHandler
    plug Guardian.Plug.LoadResource, module: TimeManager.Guardian,
    error_handler: TimeManager.GuardianErrorHandler
    plug TimeManager.FetchCurrentUser
  end

  scope "/", TimeManagerWeb do
    pipe_through :api

    post "/register", AuthController, :register
    post "/login", AuthController, :login
  end


  scope "/api", TimeManagerWeb do
    pipe_through :authenticated

    # Routes for the "User" controller
    get "/users", UserController, :index
    get "/users/:id", UserController, :show
    post "/users", UserController, :create
    put "/user_role", UserController, :update_role
    put "/users/:id", UserController, :update
    delete "/users/:id", UserController, :delete

    # Routes for the "Clock" controller
    get "/clocks/:userID", ClockController, :index
    post "/clocks/:userID", ClockController, :create

    # Routes for the "WorkingTime" controller
    get "/workingtimes/:m", WorkingTimeController, :index
    get "/workingtimes/:userID/:id", WorkingTimeController, :show
    post "/workingtimes/:userID", WorkingTimeController, :create
    put "/workingtimes/:id", WorkingTimeController, :update
    delete "/workingtimes/:id", WorkingTimeController, :delete

    # Routes for the "Team" controller
    get "/user/team/:userID", TeamController, :index
    get "/team/:teamID", TeamController, :show
    post "/team/add_user", TeamController, :add_user
    put "/team/clear_user_team/:user_id", TeamController, :clear_user_team
    post "/team", TeamController, :create
    delete "/team/:teamID", TeamController, :delete
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: TimeManagerWeb.Telemetry
    end
  end
end