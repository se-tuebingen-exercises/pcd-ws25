
defmodule ChatClient do

  def start(port) do
    {:ok, socket} = :gen_tcp.connect(String.to_charlist("localhost"), port, [:binary, active: false])
    main = self()
    spawn(fn -> stdin_loop(main) end)
    spawn(fn -> network_loop(socket, main) end)
    loop(socket)
  end

  def stdin_loop(main) do
    data = IO.gets("")
    send(main, {:stdin, data})
    stdin_loop(main)
  end

  def network_loop(socket, main) do
    case :gen_tcp.recv(socket, 0) do
      {:ok, data} ->
        send(main, {:network, data})
        network_loop(socket, main)
    end
  end

  def loop(socket) do
    receive do
      {:stdin, line} ->
        :gen_tcp.send(socket, line)
        loop(socket)
      {:network, data} ->
        IO.write("> #{data}")
        loop(socket)
    end
  end
end

ChatClient.start(8080)

