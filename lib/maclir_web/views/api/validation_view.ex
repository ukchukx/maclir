defmodule MacLirWeb.API.ValidationView do
  use MacLirWeb, :view

  def render("error.json", %{errors: errors}) do
    %{errors: errors}
  end
end