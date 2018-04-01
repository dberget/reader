defmodule RandomReader.Web.Router do
  use RandomReader.Web, :router
  use Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  if Mix.env == :dev do
  forward "/sent_emails", Bamboo.EmailPreviewPlug
  end
  
  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RandomReader.Web do
    pipe_through :browser # Use the default browser stack

    get "/", UserController, :new
    resources "/users", UserController
    resources "/articles", ArticleController, except: [:new, :edit]
  end

  # Other scopes may use custom stacks.
  # scope "/api", RandomReader.Web do
  #   pipe_through :api
  # end
end
