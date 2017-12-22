defmodule MacLir.Accounts.Queries.SentFriendRequests do
  import Ecto.Query

  alias MacLir.Accounts.Projections.Friend

  def new(uuid), do: from(f in Friend, where: ^uuid in f.received_requests)
end