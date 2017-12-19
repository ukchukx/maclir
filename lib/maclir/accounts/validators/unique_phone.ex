defmodule MacLir.Accounts.Validators.UniquePhone do
  use Vex.Validator

  alias MacLir.Accounts
  alias MacLir.Accounts.Projections.User

  def validate(phone, context) do
    user_uuid = Map.get(context, :user_uuid)

    case phone_registered?(phone, user_uuid) do
      true -> {:error, "has already been taken"}
      false -> :ok
    end
  end

  defp phone_registered?(phone, user_uuid) do
    case Accounts.user_by_phone(phone) do
      %User{uuid: ^user_uuid} -> false
      nil -> false
      _ -> true
    end
  end

  # def validate(value, _options) do
  #   Vex.Validators.By.validate(value, [
  #     function: fn value -> !phone_registered?(value) end,
  #     message: "has already been taken"
  #   ])
  # end

  # defp phone_registered?(phone) do
  #   case Accounts.user_by_phone(phone) do
  #     nil -> false
  #     _ -> true
  #   end
  # end
end