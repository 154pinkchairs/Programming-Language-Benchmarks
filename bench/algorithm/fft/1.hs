module Main where

import Data.Complex
import Data.List
import System.Environment

-- The FFT algorithm

fft :: [Complex Double] -> [Complex Double]
fft [] = []
fft [x] = [x]
fft xs = zipWith (+) (fft es) (map (*w) (fft os))
    where
    (es,os) = unzip (zipWith (\i x -> (x, xs !! (i + half))) [0,2..] xs)
    half = length xs `div` 2
    w = exp (2 * pi * i / fromIntegral (length xs))

-- The benchmark

main = do
    [n] <- getArgs
    let ns = [0..2^read n-1] :: [Double]
    let xs = map (\n -> cos n + sin n * i) ns
    print (fft xs)

-- The benchmark program should be compiled with -O2 to get reasonable
-- performance.  It can be compiled with ghc, or with the ghc in-place
-- compiler, ghc-stage2.  The latter is much faster, but it is not
-- installed by default, so you may have to build it yourself.  The
-- in-place compiler is used by default in the Makefile.

-- To build the benchmark program, run:
--
--   ghc -O2 -o fft1 fft/1.hs

-- To run the benchmark program, run:
--
--   ./fft1 1
