package main

import (
	"fmt"
	"math"
	"math/cmplx"
)

func fft(x []complex128) []complex128 {
	N := len(x)
	if N == 1 {
		return x
	}
	X := make([]complex128, N)
	for k := 0; k < N/2; k++ {
		X[k] = x[2*k] + cmplx.Exp(complex(0, -2*math.Pi*float64(k)/float64(N)))*x[2*k+1]
		X[k+N/2] = x[2*k] - cmplx.Exp(complex(0, -2*math.Pi*float64(k)/float64(N)))*x[2*k+1]
	}
	return X
}

func main() {
	x := make([]complex128, 4)
	for i := 0; i < 4; i++ {
		x[i] = complex(float64(i), 0)
	}
	fmt.Println(fft(x))
}
