pragma circom 2.1.8;

include "../node_modules/circomlib/circuits/comparators.circom";

// Create a circuit that takes an array of signals `in[n]` and
// a signal k. The circuit should return 1 if `k` is in the list
// and 0 otherwise. This circuit should work for an arbitrary
// length of `in`.

template HasAtLeastOne(n) {
    signal input in[n];
    signal input k;
    signal output out;

    component eq[n];
    signal isEqual[n];
    signal partialSum[n+1];
    partialSum[0] <== 0;

    for(var i = 0; i < n; i++){
        eq[i] = IsEqual();
        eq[i].in[0] <== in[i];
        eq[i].in[1] <== k;
        isEqual[i] <== eq[i].out;
    }

    for(var i = 0; i < n; i++){
        partialSum[i+1] <== partialSum[i] + isEqual[i];
    }

    out <== partialSum[n];
}

component main = HasAtLeastOne(4);
