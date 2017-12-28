defmodule MacLir.DataCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias MacLir.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import MacLir.Factory
      import MacLir.Fixture
      import MacLir.DataCase
      import MacLir.Helpers.Wait
      import MacLir.Helpers.ProcessHelper
    end
  end

  setup do
    MacLir.Storage.reset!()

    :ok
  end
end
