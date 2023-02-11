import {Complex} from "https://deno.land/x/complex/mod.ts";

const PI = Math.PI;

// Recursive FFT implementation
function fft(arr: Complex[], invert: boolean): Complex[] {
  const n = arr.length;
  if (n === 1) {
    return arr;
  }
  const even = new Array(n / 2).fill(0).map((_, i) => arr[2 * i]);
  const odd = new Array(n / 2).fill(0).map((_, i) => arr[2 * i + 1]);
  const fftEven = fft(even, invert);
  const fftOdd = fft(odd, invert);
  const result = new Array(n).fill(0);
  for (let i = 0; i < n / 2; i++) {
    const angle = 2 * PI * i / n;
    const w = invert ? new Complex(Math.cos(angle), -Math.sin(angle)) : new Complex(Math.cos(angle), Math.sin(angle));
    result[i] = fftEven[i].add(w.mul(fftOdd[i]));
    result[i + n / 2] = fftEven[i].sub(w.mul(fftOdd[i]));
  }
  return result;
}

// Main FFT function
export function fftTransform(arr: number[]): Complex[] {
  const n = arr.length;
  const result = new Array(n).fill(0).map((_, i) => new Complex(arr[i], 0));
  return fft(result, false);
}

// Inverse FFT function
export function ifftTransform(arr: Complex[]): Complex[] {
  const n = arr.length;
  const result = fft(arr, true);
  return new Array(n).fill(0).map((_, i) => result[i].div(n));
}
