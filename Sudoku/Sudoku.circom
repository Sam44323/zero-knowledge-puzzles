pragma circom 2.1.4;

include "../node_modules/circomlib/circuits/comparators.circom";

template Sudoku () {
    signal input  question[16];
    signal input solution[16];
    signal output out;
    
    // Step 1: Check if solution matches the question (given clues)
    for(var v = 0; v < 16; v++){
        assert(question[v] == solution[v] || question[v] == 0);
    }
    
    // Step 2: Verify question has exactly 3 zeros per row (not strictly needed for verification)
    var m = 0;
    component row1[4];
    for(var q = 0; q < 4; q++){
        row1[m] = IsEqual();
        row1[m].in[0] <== question[q];
        row1[m].in[1] <== 0;
        m++;
    }
    3 === row1[3].out + row1[2].out + row1[1].out + row1[0].out;

    m = 0;
    component row2[4];
    for(var q = 4; q < 8; q++){
        row2[m] = IsEqual();
        row2[m].in[0] <== question[q];
        row2[m].in[1] <== 0;
        m++;
    }
    3 === row2[3].out + row2[2].out + row2[1].out + row2[0].out; 

    m = 0;
    component row3[4];
    for(var q = 8; q < 12; q++){
        row3[m] = IsEqual();
        row3[m].in[0] <== question[q];
        row3[m].in[1] <== 0;
        m++;
    }
    3 === row3[3].out + row3[2].out + row3[1].out + row3[0].out; 

    m = 0;
    component row4[4];
    for(var q = 12; q < 16; q++){
        row4[m] = IsEqual();
        row4[m].in[0] <== question[q];
        row4[m].in[1] <== 0;
        m++;
    }
    3 === row4[3].out + row4[2].out + row4[1].out + row4[0].out; 

    // ============== SOLUTION STARTS HERE ==============
    
    // Step 3: Check all rows contain [1,2,3,4]
    // For a valid row, sum should be 1+2+3+4 = 10
    // And product should be 1*2*3*4 = 24
    component rowCheck[4];
    signal rowSum[4];
    signal rowProduct[4];
    signal rowProd1[4];
    signal rowProd2[4];
    
    for(var i = 0; i < 4; i++){
        var baseIdx = i * 4;
        rowSum[i] <== solution[baseIdx] + solution[baseIdx+1] + solution[baseIdx+2] + solution[baseIdx+3];
        rowProd1[i] <== solution[baseIdx] * solution[baseIdx+1];
        rowProd2[i] <== solution[baseIdx+2] * solution[baseIdx+3];
        rowProduct[i] <== rowProd1[i] * rowProd2[i];
        
        rowCheck[i] = IsEqual();
        rowCheck[i].in[0] <== rowSum[i] + rowProduct[i];
        rowCheck[i].in[1] <== 34; // 10 + 24
        rowCheck[i].out === 1;
    }
    
    // Step 4: Check all columns contain [1,2,3,4]
    component colCheck[4];
    signal colSum[4];
    signal colProduct[4];
    signal colProd1[4];
    signal colProd2[4];
    
    for(var j = 0; j < 4; j++){
        colSum[j] <== solution[j] + solution[j+4] + solution[j+8] + solution[j+12];
        colProd1[j] <== solution[j] * solution[j+4];
        colProd2[j] <== solution[j+8] * solution[j+12];
        colProduct[j] <== colProd1[j] * colProd2[j];
        
        colCheck[j] = IsEqual();
        colCheck[j].in[0] <== colSum[j] + colProduct[j];
        colCheck[j].in[1] <== 34;
        colCheck[j].out === 1;
    }
    
    // Step 5: Check all 2x2 boxes contain [1,2,3,4]
    // Box indices: Box1=[0,1,4,5], Box2=[2,3,6,7], Box3=[8,9,12,13], Box4=[10,11,14,15]
    component boxCheck[4];
    signal boxSum[4];
    signal boxProduct[4];
    signal boxProd1[4];
    signal boxProd2[4];
    
    // Box 1 (top-left): indices 0,1,4,5
    boxSum[0] <== solution[0] + solution[1] + solution[4] + solution[5];
    boxProd1[0] <== solution[0] * solution[1];
    boxProd2[0] <== solution[4] * solution[5];
    boxProduct[0] <== boxProd1[0] * boxProd2[0];
    boxCheck[0] = IsEqual();
    boxCheck[0].in[0] <== boxSum[0] + boxProduct[0];
    boxCheck[0].in[1] <== 34;
    boxCheck[0].out === 1;
    
    // Box 2 (top-right): indices 2,3,6,7
    boxSum[1] <== solution[2] + solution[3] + solution[6] + solution[7];
    boxProd1[1] <== solution[2] * solution[3];
    boxProd2[1] <== solution[6] * solution[7];
    boxProduct[1] <== boxProd1[1] * boxProd2[1];
    boxCheck[1] = IsEqual();
    boxCheck[1].in[0] <== boxSum[1] + boxProduct[1];
    boxCheck[1].in[1] <== 34;
    boxCheck[1].out === 1;
    
    // Box 3 (bottom-left): indices 8,9,12,13
    boxSum[2] <== solution[8] + solution[9] + solution[12] + solution[13];
    boxProd1[2] <== solution[8] * solution[9];
    boxProd2[2] <== solution[12] * solution[13];
    boxProduct[2] <== boxProd1[2] * boxProd2[2];
    boxCheck[2] = IsEqual();
    boxCheck[2].in[0] <== boxSum[2] + boxProduct[2];
    boxCheck[2].in[1] <== 34;
    boxCheck[2].out === 1;
    
    // Box 4 (bottom-right): indices 10,11,14,15
    boxSum[3] <== solution[10] + solution[11] + solution[14] + solution[15];
    boxProd1[3] <== solution[10] * solution[11];
    boxProd2[3] <== solution[14] * solution[15];
    boxProduct[3] <== boxProd1[3] * boxProd2[3];
    boxCheck[3] = IsEqual();
    boxCheck[3].in[0] <== boxSum[3] + boxProduct[3];
    boxCheck[3].in[1] <== 34;
    boxCheck[3].out === 1;
    
    // Step 6: All checks passed, output 1
    out <== 1;
}

component main = Sudoku();