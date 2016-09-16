defmodule Kompax.Router do
  use Kompax.Web, :router

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

  scope "/", Kompax do
    pipe_through :browser # Use the default browser stack

    resources "/activities", ActivityController do
      resources "/sections", SectionController, except: [:index, :show]
      patch "/sections/move/:id", SectionController, :move
    end

    post "/toggle_annotation", AnnotationController, :toggle

    resources "/aspects", AspectController do
      resources "/tags", TagController, except: [:index, :show]
      patch "/tags/move/:id", TagController, :move
    end

    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", Kompax do
    pipe_through :api

    get "/frame", FrameController, :show
  end
end
