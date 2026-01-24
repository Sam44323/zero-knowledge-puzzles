pragma circom 2.1.4;

include "../node_modules/circomlib/circuits/comparators.circom";

// Input 3 values using 'a'(array of length 3) and check if they all are equal.
// Return using signal 'c'.

template Equality() {
   signal input in[3];
   signal output c;

   component z1 = IsZero();
   component z2 = IsZero();

   z1.in <== in[0] - in[1];
   z2.in <== in[1] - in[2];

   // Here both must be zero overall
   c <== z1.out * z2.out;
   c === 1;
}

component main = Equality();