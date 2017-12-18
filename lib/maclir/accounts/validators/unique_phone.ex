defmodule MacLir.Accounts.Validators.UniquePhone do
  use Vex.Validator

  alias MacLir.Accounts

  def validate(value, _options) do
    Vex.Validators.By.validate(value, [
      function: fn value -> !phone_registered?(value) end,
      message: "has already been taken"
    ])
  end

  defp phone_registered?(phone) do
    case Accounts.user_by_phone(phone) do
      nil -> false
      _ -> true
    end
  end
end