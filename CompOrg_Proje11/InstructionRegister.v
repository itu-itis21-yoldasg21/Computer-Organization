module InstructionRegister (
    input wire Clock,      // Clock signal
    input wire Write,    // Write enable signal
    input wire LH,       // Load High/Low byte select signal (1 for high, 0 for low)
    input wire [7:0] I,  // 8-bit input data bus
    output reg [15:0] IROut // 16-bit Instruction Register output
);

    // IR register operation
    always @(posedge Clock) begin
        if (Write) begin
            if (LH) begin
                // Load I into the high byte of IR
                IROut[15:8] <= I;
            end
            else begin
                // Load I into the low byte of IR
                IROut[7:0] <= I;
            end
        end
        // If write is not enabled, IR retains its value, so no else part is needed
    end
endmodule