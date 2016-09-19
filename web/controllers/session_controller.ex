defmodule Kompax.SessionController do
  use Kompax.Web, :controller

  alias Kompax.UserSession
  alias Kompax.User

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  plug :put_layout, "visitor.html"

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"email" => email, "password" => password}) do
    user = Repo.get_by(User, email: email)
    if user && checkpw(password, user.password_hash) do
      conn
      |> UserSession.login(user)
    else
      dummy_checkpw
      conn
    end
  end

  def delete(conn, _params) do
    conn
    |> UserSession.logout
    |> redirect(to: page_path(conn, :index))
  end
end
