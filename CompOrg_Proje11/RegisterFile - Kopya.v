module RegisterFile(I, OutASel , OutBSel , Clock, FunSel , RegSel , ScrSel , OutA ,OutB);
input wire Clock;
input wire [15:0] I;
input wire [2:0] OutASel ;
input wire [2:0] OutBSel ;
input wire [2:0] FunSel ;
input wire [3:0] RegSel ;
input wire [3:0] ScrSel ;
output wire [15:0] OutA;
output wire [15:0] OutB;

wire [3:0] ER;
wire [3:0] ES;

wire [15:0] Q_R[3:0];
wire [15:0] Q_S[3:0];

assign {ER[3], ER[2], ER[1], ER[0]} = RegSel;
assign {ES[3], ES[2], ES[1], ES[0]} = ScrSel;

Register R1(I, FunSel, ~ER[3], Clock, Q_R[0]);
Register R2(I, FunSel, ~ER[2], Clock, Q_R[1]);
Register R3(I, FunSel, ~ER[1], Clock, Q_R[2]);
Register R4(I, FunSel, ~ER[0], Clock, Q_R[3]);

Register S1(I, FunSel, ~ES[3], Clock, Q_S[0]);
Register S2(I, FunSel, ~ES[2], Clock, Q_S[1]);
Register S3(I, FunSel, ~ES[1], Clock, Q_S[2]);
Register S4(I, FunSel, ~ES[0], Clock, Q_S[3]);

reg [15:0] TempOutA = 0;
reg [15:0] TempOutB = 0;

always @(posedge Clock) begin
    case(OutASel)
        3'b000: TempOutA = Q_R[0];
        3'b001: TempOutA = Q_R[1];
        3'b010: TempOutA = Q_R[2];
        3'b011: TempOutA = Q_R[3];
        3'b100: TempOutA = Q_S[0];
        3'b101: TempOutA = Q_S[1];
        3'b110: TempOutA = Q_S[2];
        3'b111: TempOutA = Q_S[3];
    endcase
    case(OutBSel)
        3'b000: TempOutB = Q_R[0];
        3'b001: TempOutB = Q_R[1];
        3'b010: TempOutB = Q_R[2];
        3'b011: TempOutB = Q_R[3];
        3'b100: TempOutB = Q_S[0];
        3'b101: TempOutB = Q_S[1];
        3'b110: TempOutB = Q_S[2];
        3'b111: TempOutB = Q_S[3];
    endcase
end

assign OutA = TempOutA;
assign OutB = TempOutB;

endmodule