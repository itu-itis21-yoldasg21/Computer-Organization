module AddressRegisterFile(I, OutCSel , OutDSel , FunSel , RegSel , OutC , OutD , Clock);
input wire Clock;
input wire [15:0] I;
input wire [1:0] OutCSel ;
input wire [1:0] OutDSel ;
input wire [2:0] FunSel ;
input wire [2:0] RegSel ;
output wire [15:0] OutC ;
output wire [15:0] OutD ;
wire [15:0] PC;
wire [15:0] AR;
wire [15:0] SP;
reg[15:0] TempOutC =0;
reg[15:0] TempOutD =0;

Register A(I, FunSel, ~RegSel[0], Clock, SP);
Register B(I, FunSel, ~RegSel[1], Clock, AR);
Register C(I, FunSel, ~RegSel[2], Clock, PC);

    always @(posedge Clock) begin
        case(OutCSel)
            2'b00: TempOutC=PC;
            2'b01: TempOutC=PC;
            2'b10: TempOutC=AR;
            2'b11: TempOutC=SP;
        endcase
        case(OutDSel)
            2'b00: TempOutD=PC;
            2'b01: TempOutD=PC;
            2'b10: TempOutD=AR;
            2'b11: TempOutD=SP;
        endcase
    end

assign OutC = TempOutC;
assign OutD = TempOutD;

endmodule
