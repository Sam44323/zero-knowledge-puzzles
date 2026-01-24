pragma circom 2.1.4;

include "../node_modules/circomlib/circuits/comparators.circom";


// Input : a , length of 2 .
// Output : c .
// In this exercise , you have to check that a[0] is NOT equal to a[1], if not equal, output 1, else output 0.
// You are free to use any operator you may like . 

// HINT:NEGATION

template NotEqual() {

    // Your code here.
   signal input in[2];
   signal output c;

   component isEq = IsEqual();
    isEq.in[0] <== in[0];
    isEq.in[1] <== in[1];

    c <== 1 - isEq.out;

}

component main = NotEqual();