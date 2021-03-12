/* CSED273 lab1 experiment 2_iii */
/* lab1_2_iii.v */


module lab1_2_iii(outAND, outOR, outNOT, inA, inB);
    output wire outAND, outOR, outNOT;
    input wire inA, inB;

    AND andGate(outAND, inA, inB);
    OR orGate(outOR, inA, inB);
    NOT notGate(outNOT, inA);

endmodule


/* Implement AND, OR, and NOT modules with {NAND}
 * You are only allowed to wire modules below
 * i.e.) No and, or, not, etc. Only nand, AND, OR, NOT are available*/
module AND(outAND, inA, inB);
    output wire outAND;
    input wire inA, inB; 

    nand(temp, inA, inB);       // (AB)' = A'+B'
    NOT notGate(outAND, temp);          // ((AB)')' = AB

endmodule

module OR(outOR, inA, inB);
    output wire outOR;
    input wire inA, inB; 
    
    NOT notGate(notA, inA);             // A' 
    NOT notGate2(notB, inB);             // B'
    nand(outOR, notA, notB);    // (A'B')' = A+B

endmodule

module NOT(outNOT, inA);
    output wire outNOT;
    input wire inA; 

    nand(outNOT, inA, inA);     // (AA)' = A'

endmodule