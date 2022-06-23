`timescale 1ns/1ps

module Imm_Gen(
    input      [31:0] instr_i,
    output reg [31:0] Imm_Gen_o
);
wire  [6:0]opcode;
assign opcode = instr_i[6:0];
always @(*) begin
    case (opcode)
        7'b0110011 :begin // R type
            Imm_Gen_o <= 32'b0;
        end
        7'b0010011, 7'b0000011, 7'b1100111 :begin // I, load, jalr
            Imm_Gen_o <= {{20{instr_i[31]}}, instr_i[31:20]};
        end
        7'b0100011: begin // Store
            Imm_Gen_o <= {{21{instr_i[31]}}, instr_i[30:25], instr_i[11:8], instr_i[7]};
        end
        7'b1100011: begin // Branch
            Imm_Gen_o <= {{21{instr_i[31]}}, instr_i[7], instr_i[30:25], instr_i[11:8]};
        end
        7'b1101111: begin // Jump
            Imm_Gen_o <= {{12{instr_i[31]}}, instr_i[19:12], instr_i[20], instr_i[30:25], instr_i[24:21]};
        end
        default:begin
            Imm_Gen_o <= 32'b0;
        end
    endcase
end
endmodule
