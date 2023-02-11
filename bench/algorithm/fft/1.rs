use std::f64::consts::PI;
use std::iter::repeat;

fn fft(x: &[f64], inv: bool) -> Vec<f64> {
    let n = x.len();
    assert!(n.is_power_of_two());
    if n == 1 {
        return x.to_vec();
    }
    let mut even = fft(&x[0..n / 2], inv);
    let mut odd = fft(&x[n / 2..n], inv);
    let theta = 2.0 * PI / (n as f64);
    let mut w = 1.0;
    let wn = (theta.cos(), theta.sin());
    for i in 0..n / 2 {
        let (re, im) = (even[i], odd[i]);
        even[i] = re + w * im;
        odd[i] = re - w * im;
        w = w * wn.0 - wn.1 * w;
    }
    even.extend(odd);
    if inv {
        for x in &mut even {
            *x /= 2.0;
        }
    }
    even
}

fn main() {
    let x = vec![1.0, 2.0, 3.0, 4.0];
    let y = fft(&x, false);
    let z = fft(&y, true);
    println!("{:?}", y);
    println!("{:?}", z);
}
