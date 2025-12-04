# Exercise 06: Transactional Memory

## Benchmark Bank Accounts

Compare the running time of the program `Accounts.hs`, written in Haskell using
Software Transactional Memory, with `accounts/main.go` from Exercise 05, written
in Go using Locks. Experiment with different levels of contention. Document your
findings.

Optional Challenge: Also benchmark and optimize this program using a different
language and technology of your choice.

## Santa Claus Problem

John A. Trono. 1994. A new exercise in concurrency.

https://dl.acm.org/doi/abs/10.1145/187387.187391

Santa Claus sleeps at the North Pole. He should be woken up when either:

- All 9 reindeer have returned from vacation and are ready to deliver toys,
- or 3 elves are waiting with problems they need help solving.

When woken by reindeer, Santa harnesses them to his sleigh, delivers toys, and
releases them back on vacation. When woken by elves, Santa helps them with their
problems and sends them back to work. Reindeer have priority: if reindeer and
elves are both waiting, handle the reindeer first.

Implement this scenario using Haskell Software Transactional Memory. Create
threads for Santa, 9 reindeer, and 10 elves. Reindeer and elves should loop:
work for a random time, then wait for Santa's help.

Use file `Santa.hs` as a starting point.

Optional Challenge: Read the group sizes (9 reindeer, 3 elves) at runtime.

## Hotel Booking

You are developing a booking server for a hotel with a single room only for the
month of December. You want to avoid two bookings of the same day. The server
runs at `localhost:8080` and already serves a website at `index.html`, which
allows users to select days and submit their request. The server also has an API
endpoint `/book` that receives a request of a list of days and responds with
whether the booking is ok and what the currently booked days are. Unfortunately,
it can happen that two people get an ok for booking ovelapping days. Fix this
state of affairs, by using a `TVar` instead of an `IORef` for the state of the
bookings.

Use file `Hotel.hs` as a starting point. Compile with `ghc -threaded Hotel.hs`
and run with `./Hotel`. Then point a browser to `localhost:8080/index.html`.

## Double-Compare-And-Swap

Optional challenge: think about how to implement Compare-And-Swap for two
locations atomically, using either Compare-And-Swap for a single location, or
using Load-Linked/Store-Conditional.

