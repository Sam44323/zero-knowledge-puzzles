pragma circom 2.1.8;

// Create constraints that enforces all signals
// in `in` are binary, i.e. 0 or 1.

template AllBinary(n) {
    signal input in[n];

    for (var i = 0; i < n; i++) {
        // Enforce in[i] * (in[i] - 1) == 0
        // This is only true if in[i] is 0 or 1
        in[i] * (in[i] - 1) === 0;
    }
}

component main = AllBinary(4);
