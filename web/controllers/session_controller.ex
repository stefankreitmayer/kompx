defmodule Kompax.SessionController do
  use Kompax.Web, :controller

  alias Kompax.UserSession
  alias Kompax.User

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  def new(conn, _params) do
    conn
    |> Plug.Conn.assign(:current_user, UserSession.current_user(conn))
    |> assign(:page_title, "KoLibris - Login")
    |> assign(:include_homelink, true)
    |> render("new.html", changeset: User.changeset(%User{}))
  end

  def create(conn, %{"user" => user_params}) do
    user = Repo.get_by(User, email: user_params["email"])
    if user && checkpw(user_params["password"], user.password_hash) do
      conn
      |> UserSession.login(user)
      |> redirect(to: activity_path(conn, :index))
    else
      dummy_checkpw
      conn
      |> put_flash(:warning, "Invalid email / password combination")
      |> render("new.html", changeset: User.changeset(%User{}))
    end
  end

  def delete(conn, _params) do
    conn
    |> UserSession.logout
    |> put_flash(:success, "You have been logged out")
    |> redirect(to: session_path(conn, :new))
  end
end
