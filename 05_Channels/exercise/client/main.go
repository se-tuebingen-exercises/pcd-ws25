package main

import (
	"bufio"
	"fmt"
	"net"
	"os"
)

func main() {
	connection, _ := net.Dial("tcp", "localhost:8080")
	writer := bufio.NewWriter(connection)

	input := make(chan string, 1)
	network := make(chan string, 1)

	go func() {
		scanner := bufio.NewScanner(os.Stdin)
		for scanner.Scan() {
			input <- scanner.Text()
		}
	}()

	go func() {
		scanner := bufio.NewScanner(connection)
		for scanner.Scan() {
			network <- scanner.Text()
		}
	}()

	for {
		select {
		case message := <-input:
			writer.WriteString(message + "\n")
			writer.Flush()
		case message := <-network:
			fmt.Println(">", message)
		}
	}
}
