
defmodule ChatServer do
  def start(port) do
    server = self()
    {:ok, listen_socket} = :gen_tcp.listen(port, [active: false, reuseaddr: true])
    spawn(fn -> accept_loop(listen_socket, server) end)
    broadcast_loop([])
  end

  def accept_loop(listen_socket, server) do
    {:ok, socket} = :gen_tcp.accept(listen_socket)
    spawn(fn -> client_loop(socket, server) end)
    send(server, {:connected, socket})
    accept_loop(listen_socket, server)
  end

  def client_loop(socket, server) do
    case :gen_tcp.recv(socket, 0) do
      {:ok, data} ->
        send(server, {:broadcast, data})
        client_loop(socket, server)
      {:error, :closed} ->
        send(server, {:disconnect, socket})
    end
  end

  def broadcast_loop(clients) do
    receive do

      {:connected, socket} ->
        broadcast_loop([socket | clients])

      {:disconnect, socket} ->
        IO.puts("disconnected")
        broadcast_loop(clients.filter(fn s -> s != socket end))

      {:broadcast, message} ->
        Enum.each(clients, fn client ->
          :gen_tcp.send(client, message)
        end)
        broadcast_loop(clients)

    end
  end
end

ChatServer.start(8080)

