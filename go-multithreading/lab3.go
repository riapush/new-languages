package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"sync"
)

// Функция для вычисления факториала числа
func factorial(n int) int {
	if n == 0 {
		return 1
	}
	result := 1
	for i := 1; i <= n; i++ {
		result *= i
	}
	return result
}

func receiver3(ch <-chan int, wg *sync.WaitGroup) {
	defer wg.Done()
	for value := range ch {
		fmt.Printf("Факториал числа %d: %d\n", value, factorial(value))
	}
}

func sender(c chan int, wg *sync.WaitGroup) {
	defer wg.Done()
	file, err := os.Open("numbers.txt")
	if err != nil {
		panic(err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		num, err := strconv.Atoi(scanner.Text())
		if err != nil {
			fmt.Printf("Error converting to int: %v\n", err)
			continue
		}
		c <- num
	}
	close(c) // Close the channel when sender is done.
}

func main() {
	ch := make(chan int)
	fmt.Println("main() started")

	var wg sync.WaitGroup

	// Start the sender goroutine.
	wg.Add(1)
	go sender(ch, &wg)

	// Start multiple receiver goroutines.
	for i := 0; i < 10; i++ {
		wg.Add(1)
		go receiver3(ch, &wg)
	}

	wg.Wait() // Wait for all sender and receiver goroutines to finish.
}
