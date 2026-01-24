pragma circom 2.1.4;

include "../node_modules/circomlib/circuits/bitify.circom";

template Pow() {
    signal input a[2];   // a[0] = base, a[1] = exponent
    signal output c;

    component bits = Num2Bits(8);
    bits.in <== a[1];

    signal acc[9];
    signal sq[8];
    signal temp[8];  // intermediate signal

    acc[0] <== 1;
    sq[0] <== a[0];

    for (var i = 0; i < 8; i++) {
        if (i > 0) {
            sq[i] <== sq[i-1] * sq[i-1];
        }

        // Split into quadratic constraints
        temp[i] <== bits.out[i] * (sq[i] - 1);
        acc[i+1] <== acc[i] * (temp[i] + 1);
    }

    c <== acc[8];
}

component main = Pow();