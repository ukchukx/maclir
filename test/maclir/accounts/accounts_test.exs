defmodule MacLir.AccountsTest do
  use MacLir.DataCase

  alias MacLir.Accounts

  describe "users" do
    alias MacLir.Accounts.User

    @valid_attrs %{bio: "some bio", email: "some email", hashed_password: "some hashed_password", image: "some image", lat: 120.5, long: 120.5, phone: "some phone", username: "some username"}
    @update_attrs %{bio: "some updated bio", email: "some updated email", hashed_password: "some updated hashed_password", image: "some updated image", lat: 456.7, long: 456.7, phone: "some updated phone", username: "some updated username"}
    @invalid_attrs %{bio: nil, email: nil, hashed_password: nil, image: nil, lat: nil, long: nil, phone: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.bio == "some bio"
      assert user.email == "some email"
      assert user.hashed_password == "some hashed_password"
      assert user.image == "some image"
      assert user.lat == 120.5
      assert user.long == 120.5
      assert user.phone == "some phone"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.bio == "some updated bio"
      assert user.email == "some updated email"
      assert user.hashed_password == "some updated hashed_password"
      assert user.image == "some updated image"
      assert user.lat == 456.7
      assert user.long == 456.7
      assert user.phone == "some updated phone"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
