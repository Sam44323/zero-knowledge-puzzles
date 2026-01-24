pragma circom 2.1.4;

// Input : 'in',array of length 2 .
// Output : 'c 
// Using a forLoop , add a[0] and a[1] , 4 times in a row .

template ForLoop() {
    signal input in[2];
    signal output c;

    signal acc[5];

    acc[0] <== 0;

    for (var i = 0; i < 4; i++) {
        acc[i + 1] <== acc[i] + in[0] + in[1];
    }

    c <== acc[4];

}  

component main = ForLoop();
