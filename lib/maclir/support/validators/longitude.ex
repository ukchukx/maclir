defmodule MacLir.Support.Validators.Longitude do
  use Vex.Validator

  def validate(value, _options) do
    case is_float(value) do
      false -> {:error, "must be a decimal number"}
      true -> 
      	case value >= -180 && value <= 180 do
          false -> {:error, "must fall between -180W & 180E"}
          true -> :ok  
        end        
    end
  end
end