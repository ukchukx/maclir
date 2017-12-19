defmodule MacLir.Accounts.Validators.UniqueUsername do
  use Vex.Validator

  alias MacLir.Accounts
  alias MacLir.Accounts.Projections.User

  def validate(username, context) do
    user_uuid = Map.get(context, :user_uuid)

    case username_registered?(username, user_uuid) do
      true -> {:error, "has already been taken"}
      false -> :ok
    end
  end

  defp username_registered?(username, user_uuid) do
    case Accounts.user_by_username(username) do
      %User{uuid: ^user_uuid} -> false
      nil -> false
      _ -> true
    end
  end

  # def validate(value, _options) do
  #   Vex.Validators.By.validate(value, [
  #     function: fn value -> !username_registered?(value) end,
  #     message: "has already been taken"
  #   ])
  # end

  # defp username_registered?(username) do
  #   case Accounts.user_by_username(username) do
  #     nil -> false
  #     _ -> true
  #   end
  # end
end