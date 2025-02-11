module ArithmeticLogicUnit (A, B, Clock , FunSel , ALUOut , FlagsOut);
input wire [15:0] A;
input wire [15:0] B;
input wire Clock;
input wire [4:0] FunSel ;

output reg [15:0] ALUOut ;
output reg [3:0] FlagsOut; // {Z, C, N, O}

reg [15:0] temp;

always@ (posedge Clock) begin
    // Reset flags
    FlagsOut <= 4'b0; // {Z, C, N, O}
    temp <= 16'b0;
    
    // Perform the operation based on FunSel
     case(FunSel)
           5'b00000: temp <= {8'b0, A[7:0]}; // Pass-through A (8-bit)
           5'b00001: temp <= {8'b0, B[7:0]}; // Pass-through B (8-bit)
           5'b00010: temp <= {8'b0, ~A[7:0]}; // NOT A (8-bit)
           5'b00011: temp <= {8'b0, ~B[7:0]}; // NOT B (8-bit)
           5'b00100: {FlagsOut[2], temp} <= {1'b0, A[7:0]} + {1'b0, B[7:0]}; // A + B (8-bit)
           5'b00101: {FlagsOut[2], temp} <= {1'b0, A[7:0]} + {1'b0, B[7:0]} + FlagsOut[2]; // A + B + Carry (8-bit)
           5'b00110: {FlagsOut[2], temp} <= {1'b0, A[7:0]} - {1'b0, B[7:0]}; // A - B (8-bit)
           5'b00111: temp <= {8'b0, A[7:0] & B[7:0]}; // AND (8-bit)
           5'b01000: temp <= {8'b0, A[7:0] | B[7:0]}; // OR (8-bit)
           5'b01001: temp <= {8'b0, A[7:0] ^ B[7:0]}; // XOR (8-bit)
           5'b01010: temp <= {8'b0, ~(A[7:0] & B[7:0])}; // NAND (8-bit)
           5'b01011: temp <= {7'b0, A[7:0]} << 1; // LSL A (8-bit)
           5'b01100: temp <= {7'b0, A[7:0]} >> 1; // LSR A (8-bit)
           5'b01101: temp <= {8'b0, A[7] , A[7:1]}; // ASR A (8-bit)
           5'b01110: temp <= {A[6:0], FlagsOut[2]}; // CSL A (8-bit)
           5'b01111: temp <= {FlagsOut[2], A[7], A[6:1]}; // CSR A (8-bit)
           5'b10000: temp <= A; // Pass-through A (16-bit)
           5'b10001: temp <= B; // Pass-through B (16-bit)
           5'b10010: temp <= ~A; // NOT A (16-bit)
           5'b10011: temp <= ~B; // NOT B (16-bit)
           5'b10100: {FlagsOut[2], temp} <= A + B; // A + B (16-bit)
           5'b10101: {FlagsOut[2], temp} <= A + B + FlagsOut[2]; // A + B + Carry (16-bit)
           5'b10110: {FlagsOut[2], temp} <= A - B; // A - B (16-bit)
           5'b10111: temp <= A & B; // AND (16-bit)
           5'b11000: temp <= A | B; // OR (16-bit)
           5'b11001: temp <= A ^ B; // XOR (16-bit)
           5'b11010: temp <= ~(A & B); // NAND (16-bit)
           5'b11011: temp <= A << 1; // LSL A (16-bit)
           5'b11100: temp <= A >> 1; // LSR A (16-bit)
           5'b11101: temp <= $signed(A) >>> 1; // ASR A (16-bit)
           5'b11110: temp <= {A[14:0], FlagsOut[2]}; // CSL A (16-bit)
           5'b11111: temp <= {FlagsOut[2], A[15], A[14:1]}; // CSR A (16-bit)
           default: temp <= 16'bx; // Undefined operation
       endcase

    
       // Update ALUOut with the result
       ALUOut <= temp;
       // Update flags
       FlagsOut[3] <= (temp == 16'b0); // Zero flag
       FlagsOut[1] <= temp[15]; // Negative flag
       
       // Note: Overflow flag is not meaningful for logical operations and shift/rotate
       if (FunSel == 5'b00100 || FunSel == 5'b10100) begin // A + B
           FlagsOut[0] <= (A[15] ~^ B[15]) & (A[15] ^ temp[15]);
       end
       if (FunSel == 5'b00101 || FunSel == 5'b10101) begin // A + B + Carry
           FlagsOut[0] <= (A[15] ~^ B[15] ~^ FlagsOut[2]) & (A[15] ^ temp[15]);
       end
       if (FunSel == 5'b00110 || FunSel == 5'b10110) begin // A - B
           FlagsOut[0] <= (A[15] ^ B[15]) & (A[15] ^ temp[15]);
       end

       // Overflow for 8-bit operations is determined by the MSB of the lower 8 bits
       if (FunSel >= 5'b00000 && FunSel <= 5'b00110) begin
           FlagsOut[0] <= (A[7] ~^ B[7]) & (A[7] ^ temp[7]);
       end

       // Set the overflow flag to 0 for logical operations, shifts and rotates
       if (FunSel >= 5'b00111 && FunSel <= 5'b01111 || FunSel >= 5'b10111 && FunSel <= 5'b11111) begin
           FlagsOut[0] <= 0;
       end
   end
endmodule