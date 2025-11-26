package main

import (
	"fmt"
	"math/rand"
	"sync"
)

var accounts [100]int

func transfer(amount int, source int, target int) bool {
	if accounts[source] < amount {
		return false
	}
	accounts[source] = accounts[source] - amount
	accounts[target] = accounts[target] + amount
	return true
}

func main() {

	for i := range accounts {
		accounts[i] = 1000
	}

	var wg sync.WaitGroup

	for i:= range 100000 {
		random := rand.New(rand.NewSource(int64(i)))
		source := random.Intn(len(accounts))
		target := random.Intn(len(accounts))
		amount := random.Intn(100)
		wg.Add(1)
		go func() {
			for !transfer(amount, source, target) { }
			wg.Done()
		}()
		wg.Add(1)
		go func() {
			for !transfer(amount, target, source) { }
			wg.Done()
		}()

	}

	wg.Wait()

	total := 0
	for i := range accounts {
		total = total + accounts[i]
	}

	fmt.Printf("Total: %d\n", total)
}

