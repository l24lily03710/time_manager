defmodule TimeManagerWeb.Router do
  use TimeManagerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TimeManagerWeb do
    pipe_through :api

    # Routes for the "User" controller
    get "/users", UserController, :index
    get "/users/:id", UserController, :show
    post "/users", UserController, :create
    put "/users/:id", UserController, :update
    delete "/users/:id", UserController, :delete

    # Routes for the "Clock" controller
    get "/clocks", ClockController, :index
    get "/clocks/:id", ClockController, :show
    post "/clocks", ClockController, :create
    put "/clocks/:id", ClockController, :update
    delete "/clocks/:id", ClockController, :delete

    # Routes for the "WorkingTime" controller
    get "/working_times", WorkingTimeController, :index
    get "/working_times/:id", WorkingTimeController, :show
    post "/working_times", WorkingTimeController, :create
    put "/working_times/:id", WorkingTimeController, :update
    delete "/working_times/:id", WorkingTimeController, :delete
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
