defmodule Kompax.SessionControllerTest do
  use Kompax.ConnCase

  alias Kompax.UserSession
  alias Kompax.User

  import Kompax.ConnCase, only: [with_current_user: 2]

  @valid_attrs %{email: "bar@baz.com", password: "s3cr3t"}

  setup do
    conn = build_conn()
    {:ok, conn: conn, user: create_user}
  end

  defp create_user do
    User.changeset(%User{}, @valid_attrs)
    |> Repo.insert!
  end

  test "logs in", %{conn: conn, user: user} do
    conn = conn |> post(session_path(conn, :create), %{"user" => @valid_attrs})
    assert Plug.Conn.get_session(conn, :user_id) == user.id
    assert conn.assigns[:current_user] == Map.put(user, :password, nil)
  end

  test "does not login when account doesn't exist", %{conn: conn} do
    conn = conn |> post(session_path(conn, :create), %{"user" => Map.put(@valid_attrs, :email, "does@not.exist")})
    refute Plug.Conn.get_session(conn, :user_id)
  end

  test "does not login when password doesn't match", %{conn: conn} do
    conn = conn |> post(session_path(conn, :create), %{"user" => Map.put(@valid_attrs, :password, "invalid")})
    refute Plug.Conn.get_session(conn, :user_id)
  end

  test "logs out", %{conn: conn, user: user} do
    conn = conn |> with_current_user(user)
    assert UserSession.current_user(conn) == user
    conn = conn |> delete(session_path(conn, :delete))
    assert UserSession.current_user(conn) == nil
    assert redirected_to(conn) == session_path(conn, :new)
  end
end
