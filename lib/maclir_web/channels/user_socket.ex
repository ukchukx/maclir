defmodule MacLirWeb.UserSocket do
  use Phoenix.Socket

  alias MacLir.Accounts
  alias MacLir.Accounts.Projections.User


  ## Channels
  channel "user:*", MacLirWeb.UserChannel
  # "user_presence:*" is not meant to be joined, added here to clarify that the topic prefix is used by the UserChannel
  channel "user_presence:*", MacLirWeb.UserChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  def connect(%{"token" => token}, socket) do
    # max_age: 1209600 is equivalent to two weeks in seconds
    case Phoenix.Token.verify(socket, "socket_token", token, max_age: 1209600) do
     {:ok, uuid} -> 
      case Accounts.user_by_uuid(uuid) do
        %User{} -> {:ok, assign(socket, :user_uuid, uuid)}
        _ -> :error          
      end
     {:error, _reason} -> :error
    end
  end

  def connect(_params, _socket), do: :error

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     MacLirWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
