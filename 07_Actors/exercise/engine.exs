
defmodule Engine do
  def start do
    Process.register(self(), :engine)
    loop([
      "Hello","How are you?","Nice!","Interesting",
      "Wow","Cool","Sure","Okay","Go on","Bye"])
  end

  def loop(messages) do
    receive do
      {:message, from} ->
        reply = Enum.random(messages)
        send(from, {:reply, reply})
        loop(messages)
    end
  end
end


