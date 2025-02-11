module Register (
    input wire [15:0] I,
    input wire E,
    input wire [2:0] FunSel,
    output reg [15:0] Q,
     input wire Clock
);

    always @(posedge Clock) begin
        if (E) begin
            case (FunSel)
                3'b000: Q <= Q - 1; // Decrement Q
                3'b001: Q <= Q + 1; // Increment Q
                3'b010: Q <= I;     // Load I into Q
                3'b011: Q <= 16'b0; // Clear Q
                3'b100: begin       // Clear upper 8 bits, write lower 8 bits from I
                    Q[15:8] <= 8'b0;
                    Q[7:0]  <= I[7:0];
                end
                3'b101: Q[7:0]  <= I[7:0]; // Only write lower 8 bits from I
                3'b110: Q[15:8] <= I[7:0]; // Only write upper 8 bits from lower 8 bits of I
                3'b111: begin       // Sign extend bit 7 of I to upper 8 bits, write lower 8 bits from I
                    Q[15:8] <= {8{I[7]}};
                    Q[7:0]  <= I[7:0];
                end
                default: Q <= Q ; // Do nothing, retain Q value
            endcase
        end
    end

endmodule