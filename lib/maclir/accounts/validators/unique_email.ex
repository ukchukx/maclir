defmodule MacLir.Accounts.Validators.UniqueEmail do
  use Vex.Validator

  alias MacLir.Accounts
  alias MacLir.Accounts.Projections.User

  def validate(value, context) do
    user_uuid = Map.get(context, :user_uuid)

    case email_registered?(value, user_uuid) do
      true -> {:error, "has already been taken"}
      false -> :ok
    end
  end

  defp email_registered?(email, user_uuid) do
    case Accounts.user_by_email(email) do
      %User{uuid: ^user_uuid} -> false
      nil -> false
      _ -> true
    end
  end

  # def validate(value, _options) do
  #   Vex.Validators.By.validate(value, [
  #     function: fn value -> !email_registered?(value) end,
  #     message: "has already been taken"
  #   ])
  # end

  # defp email_registered?(email) do
  #   case Accounts.user_by_email(email) do
  #     nil -> false
  #     _ -> true
  #   end
  # end
end