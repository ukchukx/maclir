defmodule MacLirWeb.API.SessionControllerTest do
  use MacLirWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "authenticate user" do
    @tag :api
    test "creates session using email and renders session when data is valid", %{conn: conn} do
      register_user()

      params = build(:user)

      conn = post conn, session_path(conn, :create), user: %{
        id: params.email,
        password: params.password
      }

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
    test "creates session using phone and renders session when data is valid", %{conn: conn} do
      register_user()
      params = build(:user)

      conn = post conn, session_path(conn, :create), user: %{
        id: params.phone,
        password: params.password
      }

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
    test "does not create session and renders errors when password does not match", %{conn: conn} do
      register_user()
      params = build(:user)

      conn = post conn, session_path(conn, :create), user: %{
        id: params.email,
        password: "invalidpassword"
      }

      assert json_response(conn, 422)["errors"] == %{
        "id or password" => ["is invalid"]
      }
    end

    @tag :api
    test "does not create session and renders errors when user with email not found", %{conn: conn} do
      conn = post conn, session_path(conn, :create), user: %{
        id: "doesnotexist",
        password: "jakejake"
      }

      assert json_response(conn, 422)["errors"] == %{
        "id or password" => ["is invalid"]
      }
    end

    @tag :api
    test "does not create session and renders errors when user with phone not found", %{conn: conn} do
      conn = post conn, session_path(conn, :create), user: %{
        id: "doesnotexist",
        password: "jakejake"
      }

      assert json_response(conn, 422)["errors"] == %{
        "id or password" => ["is invalid"]
      }
    end
  end

  defp register_user, do: fixture(:user)
end