# Exercise 05: Communicating Processes

## Benchmark Prime Sieve

Implement the classical Sieve of Eratosthenes algorithm using a pipeline of
goroutines communicating through channels. Each stage corresponds to a prime
number and filters out all those numbers divisible by it. The first stage feeds
a sequence of numbers starting from `2`. Upon discovering a new prime number,
print it and add a new stage to the pipeline.

Optional: Benchmark against an implementation in Java using blocking queues.

Use file `primes/main.go` as a starting point.

## Race Detection

Consider the program in `accounts/main.go`, which models bank accounts and money
transfers between them. It prints the total balance after all transfers are
done, which should be `100000`. Unfortunately, this is not always so. Diagnose
and fix the issue.

Optional Challenge: Benchmark and optimize your program for a large number of
concurrent transfers.

## Chat Engine

Create a server that when started connects via TCP to an engine which responds
with random messages to newlines. This engine is in file `engine/main.go`. It
should then accept connections from clients and respond to their messages by
querying the engine. The client is in file `client/main.go`.

Use file `server/main.go` as a starting point.

Optional Challenge: modify the server to send the current weather in Tübingen
from `open-meteo.com` to clients after random time intervals.

