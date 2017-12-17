defmodule MacLirWeb.API.UserControllerTest do
  use MacLirWeb.ConnCase

  alias MacLir.Accounts
  alias MacLir.Accounts.User

  @create_attrs %{bio: "some bio", email: "some email", hashed_password: "some hashed_password", image: "some image", lat: 120.5, long: 120.5, phone: "some phone", username: "some username"}
  @update_attrs %{bio: "some updated bio", email: "some updated email", hashed_password: "some updated hashed_password", image: "some updated image", lat: 456.7, long: 456.7, phone: "some updated phone", username: "some updated username"}
  @invalid_attrs %{bio: nil, email: nil, hashed_password: nil, image: nil, lat: nil, long: nil, phone: nil, username: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get conn, user_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, user_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "bio" => "some bio",
        "email" => "some email",
        "hashed_password" => "some hashed_password",
        "image" => "some image",
        "lat" => 120.5,
        "long" => 120.5,
        "phone" => "some phone",
        "username" => "some username"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put conn, user_path(conn, :update, user), user: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, user_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "bio" => "some updated bio",
        "email" => "some updated email",
        "hashed_password" => "some updated hashed_password",
        "image" => "some updated image",
        "lat" => 456.7,
        "long" => 456.7,
        "phone" => "some updated phone",
        "username" => "some updated username"}
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete conn, user_path(conn, :delete, user)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, user_path(conn, :show, user)
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
