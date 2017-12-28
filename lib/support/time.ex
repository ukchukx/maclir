defmodule MacLir.Support.Time do

	@doc """
  Check if date_time occurred in the last seconds
  Since event handlers are called on aggregate hydration (at startup),
  we don't want to keep broadcasting past events
	"""
	def recent?(date_time, seconds \\ 10) do
    DateTime.utc_now
    |> DateTime.diff(date_time)
    |> Kernel.<(seconds)
  end

  def naive_to_datetime(naive_datetime) do
    naive_datetime
    |> NaiveDateTime.to_iso8601
    |> (&<>/2).("+00:00")
    |> DateTime.from_iso8601 # {:ok, date_time, 0}
    |> elem(1)
  end
end