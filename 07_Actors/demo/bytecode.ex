
defmodule Printer do
  def loop do
    receive do
      message ->
        IO.puts(message <> "!")
        loop()
    end
  end
end

