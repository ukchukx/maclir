defmodule MacLir.Support.Validators.Role do
  use Vex.Validator

  @roles ["user", "admin"]

  def validate(value, _options) do
    case value in @roles do
      false -> {:error, "is not a valid role"}
      true -> :ok      
    end
  end
end