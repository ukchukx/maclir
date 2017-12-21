defmodule MacLir.Accounts.Queries.FriendByUUID do
  import Ecto.Query

  alias MacLir.Accounts.Projections.Friend

  def new(uuid), do: from(f in Friend, where: f.uuid == ^uuid)
end