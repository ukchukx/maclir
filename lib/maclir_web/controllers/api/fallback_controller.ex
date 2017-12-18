defmodule MacLirWeb.API.FallbackController do
  use MacLirWeb, :controller

  def call(conn, {:error, :validation_failure, errors}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(MacLirWeb.API.ValidationView, "error.json", errors: errors)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(MacLirWeb.API.ErrorView, :"404")
  end
end
