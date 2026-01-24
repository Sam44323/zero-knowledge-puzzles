pragma circom 2.1.4;

include "../node_modules/circomlib/circuits/bitify.circom";

template Pow() {
    // Input: a[0] = base, a[1] = exponent
    signal input a[2];
    
    // Output: c = base^exponent
    signal output c;

    // Convert the exponent to 8 bits (supports exponents 0-255)
    // bits.out[0] = LSB (least significant bit), bits.out[7] = MSB
    component bits = Num2Bits(8);
    bits.in <== a[1];

    // Accumulator array: stores intermediate results of multiplications
    // acc[0] = starting value, acc[8] = final result after 8 iterations
    signal acc[9];
    
    // Squares array: stores successive squares of the base
    // sq[0] = base^1, sq[1] = base^2, sq[2] = base^4, sq[3] = base^8, etc.
    signal sq[8];
    
    // Temporary signals: used to split non-quadratic constraints into quadratic ones
    // Needed because Circom requires all constraints to be at most degree 2
    signal temp[8];

    // Initialize accumulator to 1 (multiplicative identity)
    // Any number^0 = 1, so we start here
    acc[0] <== 1;
    
    // Initialize first square to the base itself (base^1)
    sq[0] <== a[0];

    // Process each bit of the exponent (from LSB to MSB)
    for (var i = 0; i < 8; i++) {
        
        // For i > 0: compute the next square by squaring the previous one
        // sq[1] = sq[0]^2 = base^2
        // sq[2] = sq[1]^2 = base^4
        // sq[3] = sq[2]^2 = base^8, and so on...
        if (i > 0) {
            sq[i] <== sq[i-1] * sq[i-1];
        }

        // QUADRATIC CONSTRAINT 1: Compute intermediate value based on current bit
        // If bits.out[i] = 0: temp[i] = 0 * (sq[i] - 1) = 0
        // If bits.out[i] = 1: temp[i] = 1 * (sq[i] - 1) = sq[i] - 1
        // this is used as a selector for whether to include sq[i] in the multiplication as conditional for constraints are not allowed in the circuits
        temp[i] <== bits.out[i] * (sq[i] - 1);
        
        // QUADRATIC CONSTRAINT 2: Update accumulator conditionally
        // If bits.out[i] = 0: acc[i+1] = acc[i] * (0 + 1) = acc[i] (skip this power)
        // If bits.out[i] = 1: acc[i+1] = acc[i] * (sq[i] - 1 + 1) = acc[i] * sq[i] (include this power)
        // This implements: "multiply by sq[i] only if bit i is set in the exponent"
        acc[i+1] <== acc[i] * (temp[i] + 1);
    }

    // After 8 iterations, acc[8] contains the final result: base^exponent
    c <== acc[8];
}

// Instantiate the Pow template as the main circuit entry point
component main = Pow();