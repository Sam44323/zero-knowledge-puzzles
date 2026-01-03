pragma circom 2.1.4;

include "circomlib/bitify.circom";

template Pow() {
    signal input a[2];   // a[0] = base, a[1] = exponent
    signal output c;

    component bits = Num2Bits(8);
    bits.in <== a[1];

    signal acc[9];
    signal sq[8];

    acc[0] <== 1;

    for (var i = 0; i < 8; i++) {
        if (i == 0) {
            sq[i] <== a[0];
        } else {
            sq[i] <== sq[i-1] * sq[i-1];
        }

        acc[i+1] <== acc[i] * (bits.out[i] * sq[i] + (1 - bits.out[i]));
    }

    c <== acc[8];
}

component main = Pow();
