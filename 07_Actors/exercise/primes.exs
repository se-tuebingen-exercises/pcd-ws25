defmodule Primes do

  def generate(n, pid) do
    raise "TODO"
  end

  def sieve() do
    raise "TODO"
  end

  def filter_loop(prime, next) do
    raise "TODO"
  end
end

first = spawn(fn -> Primes.sieve() end)
Primes.generate(100, first)

