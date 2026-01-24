pragma circom 2.1.4;

include "../node_modules/circomlib/circuits/bitify.circom";
include "../node_modules/circomlib/circuits/comparators.circom";

// In this exercise , we will learn how to check the range of a private variable and prove that 
// it is within the range . 

// For example we can prove that a certain person's income is within the range
// Declare 3 input signals `a`, `lowerbound` and `upperbound`.
// If 'a' is within the range, output 1 , else output 0 using 'out'


template Range() {
    // your code here
    signal input a;
    signal input lowerbound;
    signal input upperbound;
    signal output out;

    signal arr[2];

    component bits = Num2Bits(8);
    bits.in <== a;

    component lower_range_check = GreaterThan(8);
    lower_range_check.in[0] <== a;
    lower_range_check.in[1] <== lowerbound;

    arr[0] <== lower_range_check.out;

    component upper_range_check = LessThan(8);
    upper_range_check.in[0] <== a;
    upper_range_check.in[1] <== upperbound;

    arr[1] <== upper_range_check.out;

    out <== arr[0] * arr[1];
}

component main  = Range();


