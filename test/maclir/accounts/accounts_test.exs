defmodule MacLir.AccountsTest do
  use MacLir.DataCase

  alias MacLir.Accounts
  alias MacLir.Accounts.Projections.User
  alias MacLir.Auth

  describe "register user" do
    @tag :integration
    test "should succeed with valid data" do
      params = build(:user)
      assert {:ok, %User{} = user} = Accounts.register_user(params)

      assert user.bio == nil
      assert user.email == params.email
      assert user.role == params.role
      assert user.phone == params.phone
      assert user.latitude == params.latitude
      assert user.longitude == params.longitude
      assert user.image == nil
      assert user.username == params.username
    end

    @tag :integration
    test "should fail with invalid data and return error" do
      assert {:error, :validation_failure, errors} = Accounts.register_user(build(:user, username: ""))

      assert errors == %{username: ["can't be empty"]}
    end

    @tag :integration
    test "should fail when username or phone already taken and return error" do
      assert {:ok, %User{}} = Accounts.register_user(build(:user))
      assert {:error, :validation_failure, errors} = Accounts.register_user(build(:user, email: "jake2@jake.jake"))

      assert errors == %{phone: ["has already been taken"], username: ["has already been taken"]}
    end

    @tag :integration
    test "should fail when registering identical username or phone at same time and return error" do
      1..2
      |> Enum.map(fn x -> Task.async(fn -> Accounts.register_user(build(:user, email: "jake#{x}@jake.jake")) end)  end)
      |> Enum.map(&Task.await/1)
    end

    @tag :integration
    test "should fail when username format is invalid and return error" do
      assert {:error, :validation_failure, errors} = Accounts.register_user(build(:user, username: "j@ke"))

      assert errors == %{username: ["is invalid"]}
    end

    @tag :integration
    test "should fail when phone is not Nigerian GSM number and return error" do
      assert {:error, :validation_failure, errors} = Accounts.register_user(build(:user, phone: "084123456"))

      assert errors == %{phone: ["is not a Nigerian GSM number"]}
    end

    @tag :integration
    test "should convert username to lowercase" do
      assert {:ok, %User{} = user} = Accounts.register_user(build(:user, username: "JAKE"))

      assert user.username == "jake"
    end

    @tag :integration
    test "should fail when email address already taken and return error" do
      assert {:ok, %User{}} = Accounts.register_user(build(:user, username: "jake"))
      assert {:error, :validation_failure, errors} = 
        Accounts.register_user(build(:user, username: "jake2", phone: "+2348034445555"))

      assert errors == %{email: ["has already been taken"]}
    end

    @tag :integration
    test "should fail when registering identical email addresses at same time and return error" do
      1..2
      |> Enum.map(fn x -> Task.async(fn -> Accounts.register_user(build(:user, username: "user#{x}")) end)  end)
      |> Enum.map(&Task.await/1)
    end

    @tag :integration
    test "should fail when email address format is invalid and return error" do
      assert {:error, :validation_failure, errors} = Accounts.register_user(build(:user, email: "invalidemail"))

      assert errors == %{email: ["is invalid"]}
    end

    @tag :integration
    test "should convert email address to lowercase" do
      assert {:ok, %User{} = user} = Accounts.register_user(build(:user, email: "JAKE@JAKE.JAKE"))

      assert user.email == "jake@jake.jake"
    end

    @tag :integration
    test "should hash password" do
      assert {:ok, %User{} = user} = Accounts.register_user(build(:user))

      assert Auth.validate_password("jakejake", user.hashed_password)
    end
  end
end
