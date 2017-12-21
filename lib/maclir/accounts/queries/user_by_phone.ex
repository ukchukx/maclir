defmodule MacLir.Accounts.Queries.UserByPhone do
  import Ecto.Query

  alias MacLir.Accounts.Projections.User

  def new(phone), do: from u in User, where: u.phone == ^phone
end