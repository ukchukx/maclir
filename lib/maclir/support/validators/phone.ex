defmodule MacLir.Support.Validators.Phone do
  use Vex.Validator

  @nigerian_mobile_regex ~r/^(\+?2340?|0)\d{10}$/

  def validate("", [allow_blank: true]), do: :ok
  def validate(value, _options) do
    case String.match?(value, @nigerian_mobile_regex) do
      false -> {:error, "is not a Nigerian GSM number"}
      true -> :ok      
    end
  end
end