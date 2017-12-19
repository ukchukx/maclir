defmodule MacLir.Support.Validators.Longitude do
  use Vex.Validator

  def validate(nil, [allow_nil: true]), do: :ok
  def validate(value, _options) do
    case is_number(value) do
      false -> {:error, "must be a number"}
      true -> 
      	case value >= -180 && value <= 180 do
          false -> {:error, "must fall between -180W & 180E"}
          true -> :ok  
        end        
    end
  end
end