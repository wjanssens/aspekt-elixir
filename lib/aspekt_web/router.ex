defmodule AspektWeb.Router do
  use AspektWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AspektWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api", AspektWeb.Api do
    pipe_through :api

    resources "/subjects", SubjectController, only: [:index, :create]
    resources "/subjects/:id/principals", PrincipalsController, except: [:new, :edit]
    resources "/subjects/:id/password", PasswordController, only: [:update]
    resources "/nodes", NodeController, except: [:new, :edit]
    get "/nodes/:id/nodes", NodeController, :index
    resources "/nodes/:id/milestones", MilestoneController, except: [:new, :edit]
  end
end
