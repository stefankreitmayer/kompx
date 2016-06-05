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
      resources "/sections", SectionController, except: [:index]
    end

    resources "/sections", SectionController, only: [] do
      resources "/paragraphs", ParagraphController, except: [:index, :show]
    end

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Kompax do
  #   pipe_through :api
  # end
end
