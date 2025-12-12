
IO.puts("Hello, World!")

defmodule Demo do
  def factorial(n) do
    case n do
      0 -> 1
      n -> n * factorial(n - 1)
    end
  end
end

IO.puts(Demo.factorial(5))

IO.puts(:hello == :hallo)

