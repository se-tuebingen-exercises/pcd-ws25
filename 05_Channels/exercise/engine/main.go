package main

import (
	"bufio"
	"math/rand"
	"net"
)

func main() {
	messages := []string{
		"Hello", "How are you?", "Nice!", "Interesting", "Wow",
		"Cool", "Sure", "Okay", "Go on", "Bye",
	}

	listener, _ := net.Listen("tcp", ":9000")
	connection, _ := listener.Accept()
	writer := bufio.NewWriter(connection)
	scanner := bufio.NewScanner(connection)

	for scanner.Scan() {
		_ = scanner.Text()
		response := messages[rand.Intn(len(messages))]
		writer.WriteString(response + "\n")
		writer.Flush()
	}
}
