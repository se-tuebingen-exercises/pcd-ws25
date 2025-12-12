# Exercise 07: Actors

## Benchmark Prime Sieve

Benchmark the concurrent prime sieve from Exercise 05 written in Java and Go,
against an implementation in Elixir with actors. Each stage corresponds to a
prime number and spawns a new actor that filters received numbers divisible by
it.

What do you expect? Document your findings.

Use file `primes.exs` as a starting point.

## Chat Engine

Create the same chat engine from Exercise 05, this time in Elixir with actors.
The engine, the server, and each client is an actor. The engine and the server
should register themselves with global names `:engine` and `:server`.

Use files `engine.exs`, `server.exs`, and `client.exs` as starting points.

Optional challenge: make the system robust against various forms of failure.

## Resilient Counter

Implement a global counter that can be incremented and displayed and is
resilient to node crashes. At all times there should be an actor registered at
global name `:counter`, receiving `:increment` and `:display` messages.

Start two actors, primary and backup, each running the same code. Whichever
starts first, takes the global name `:counter`, whichever starts second links
the two with `Process.link`. When the primary crashes, the backup takes over the
global name, and receives `:increment` and `:display` messages, but starting
from its own state.

Use file `counter.exs` as a starting point.

Optional challenge: replicate the state of the counter also to the backup actor.

Optional challenge: periodically send a hearbeat message and make the backup
take over after a timeout.

