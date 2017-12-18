defmodule MacLir.Support.Validators.Latitude do
  use Vex.Validator

  def validate(value, _options) do
    case is_number(value) do
      false -> {:error, "must be a decimal number"}
      true -> 
      	case value >= -90 && value <= 90 do
          false -> {:error, "must fall between -90S & 90N"}
          true -> :ok  
        end        
    end
  end
end