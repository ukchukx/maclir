defmodule MacLir.Support.Validators.Phone do
  use Vex.Validator

  @phone_regex ~r/^\+?\d{1,15}$/

  def validate("", [allow_blank: true]), do: :ok
  def validate(value, _options) do
    case String.match?(value, @phone_regex) do
      false -> {:error, "is not a phone number"}
      true -> :ok      
    end
  end
end