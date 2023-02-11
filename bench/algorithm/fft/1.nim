import random
import math
import typing

type
  Complex = tuple[r: float, i: float]

proc fft(a: seq[Complex], invert: bool) =
  var n = a.len
  for i in 1..n:
    let j = i
    var bit = n shr 1
    while j >= bit:
      j -= bit
      bit shr= 1
    j += bit
    if i < j:
      a[i], a[j] = a[j], a[i]
  for len in 2..n:
    let ang = 2.0 * math.pi / len * (if invert: -1.0 else: 1.0)
    let wlen = (math.cos(ang), math.sin(ang))
    for i in 0..n:
      var w = (1.0, 0.0)
      for j in 0..len / 2:
        let u = a[i + j]
        let v = (a[i + j + len / 2].r * w[0] - a[i + j + len / 2].i * w[1], a[i + j + len / 2].r * w[1] + a[i + j + len / 2].i * w[0])
        a[i + j] = (u[0] + v[0], u[1] + v[1])
        a[i + j + len / 2] = (u[0] - v[0], u[1] - v[1])
        w = (w[0] * wlen[0] - w[1] * wlen[1], w[0] * wlen[1] + w[1] * wlen[0])
      if invert:
        for i in 0..n:
          a[i] = (a[i].r / n, a[i].i / n)

var
  a = [for i in 1..(1 shl 20): (random.randint(0, 1000), 0.0)]
  start = clock()
  fft(a, false)
  echo clock() - start, "ms"
  b = [for i in a: i[0]]
  for i in 0..a.len:
    assert abs(b[i] - a[i].r) < 1e-9


