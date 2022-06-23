
`timescale 1ns/1ps

module Imm_Gen(
    input  [31:0] instr_i,
    output reg[31:0] Imm_Gen_o
);

//Internal Signals
wire    [7-1:0] opcode;
wire    [2:0]   func3;
wire    [3-1:0] Instr_field;

assign opcode = instr_i[6:0];
assign func3  = instr_i[14:12];
integer i;

always @(*) begin
    case (opcode)
        7'b0110011: begin // R-type
            Imm_Gen_o = 32'b0;
        end
        7'b0010011, 7'b0000011, 7'b1100111: begin // I-type, Load, JALR
            Imm_Gen_o[10:0] = instr_i[30:20];
            for (i = 11; i <= 31; i = i + 1) Imm_Gen_o[i] = instr_i[31];
        end
        7'b0100011: begin // Store
            Imm_Gen_o[4:0] = instr_i[11:7];
            Imm_Gen_o[10:5] = instr_i[30:25];
            for (i = 11; i <= 31; i = i + 1) Imm_Gen_o[i] = instr_i[31];
        end
        7'b1100011: begin // Branch
            Imm_Gen_o[0] = 1'b0;
            Imm_Gen_o[4:1] = instr_i[11:8];
            Imm_Gen_o[10:5] = instr_i[30:25];
            Imm_Gen_o[11] = instr_i[7];
            for (i = 12; i <= 31; i = i + 1) Imm_Gen_o[i] = instr_i[31];
        end
        7'b1101111: begin // JAL
            Imm_Gen_o[0] = 1'b0;
            Imm_Gen_o[4:1] = instr_i[24:21];
            Imm_Gen_o[10:5] = instr_i[30:25];
            Imm_Gen_o[11] = instr_i[20];
            Imm_Gen_o[19:12] = instr_i[19:12];
            for (i = 20; i <= 31; i = i + 1) Imm_Gen_o[i] = instr_i[31];
        end
        default: begin
            Imm_Gen_o = 32'b0;
        end
    endcase
end

endmodule
