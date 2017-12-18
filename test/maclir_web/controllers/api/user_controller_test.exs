defmodule MacLirWeb.API.UserControllerTest do
  use MacLirWeb.ConnCase


  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "register user" do
    @tag :api
    test "should create and return user when data is valid", %{conn: conn} do
      params = build(:user)
      conn = post conn, user_path(conn, :create), user: params
      json = json_response(conn, 201)["data"]

      assert json == %{
        "id" => json["id"],
        "token" => json["token"],
        "bio" => nil,
        "image" => nil,
        "role" => params.role,
        "email" => params.email,
        "username" => params.username,
        "phone" => params.phone,
        "latitude" => params.latitude,
        "longitude" => params.longitude
      }
      refute json["token"] == ""
    end

    @tag :api
    test "should not create user and render errors when data is invalid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: build(:user, username: "")
      assert json_response(conn, 422)["errors"] == %{
        "username" => [
          "can't be empty",
        ]
      }
    end

    @tag :api
    test "should not create user and render errors when unique fields has been taken", %{conn: conn} do
      # register a user
      {:ok, _user} = fixture(:user)
      %{email: email} = build(:user)

      # attempt to register the same username
      conn = post conn, user_path(conn, :create), user: build(:user, email: email)
      assert json_response(conn, 422)["errors"] == %{
        "username" => [
          "has already been taken",
        ],
        "email" => [
          "has already been taken",
        ],
        "phone" => [
          "has already been taken",
        ]
      }
    end
  end

  describe "get current user" do
    @tag :api
    test "should return user when authenticated", %{conn: conn} do
      params = build(:user)
      conn = get authenticated_conn(conn), user_path(conn, :current)
      json = json_response(conn, 200)["data"]
      token = json["token"]

      assert json == %{
        "id" => json["id"],
        "token" => token,
        "bio" => nil,
        "image" => nil,
        "role" => params.role,
        "email" => params.email,
        "username" => params.username,
        "phone" => params.phone,
        "latitude" => params.latitude,
        "longitude" => params.longitude
      }
      refute token == ""
    end

    @tag :api
    test "should not return user when unauthenticated", %{conn: conn} do
      conn = get conn, user_path(conn, :current)

      assert response(conn, 401) == ""
    end
  end

  def authenticated_conn(conn) do
    with {:ok, user} <- fixture(:user),
         {:ok, jwt} <- MacLirWeb.JWT.generate_jwt(user)
    do
      conn
      |> put_req_header("authorization", "Bearer " <> jwt)
    end
  end
end
