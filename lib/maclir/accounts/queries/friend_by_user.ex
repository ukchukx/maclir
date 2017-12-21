defmodule MacLir.Accounts.Queries.FriendByUser do
  import Ecto.Query

  alias MacLir.Accounts.Projections.Friend

  def new(user_uuid), do: from f in Friend, where: f.user_uuid == ^user_uuid
end