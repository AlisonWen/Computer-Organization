`timescale 1ns/1ps

module alu(
    input                   rst_n,         // negative reset            (input)
    input signed       [32-1:0]   src1,          // 32 bits source 1          (input)
    input signed       [32-1:0]   src2,          // 32 bits source 2          (input)
    input        [ 4-1:0]   ALU_control,   // 4 bits ALU control input  (input)
    output reg   [32-1:0]   result,        // 32 bits result            (output)
    output reg              zero           // 1 bit when the output is 0, zero must be set (output)
);

always @(*) begin
    if (~rst_n) begin
        zero <= 1'b0;
        result <= 32'b0;
    end else begin
        zero <= src1 == src2;

        case (ALU_control)
            4'b0000: result <= src1 & src2; //AND
            4'b0001: result <= src1 | src2; //OR
            4'b0010: result <= src1 + src2; //ADD ADDI LW SW
            4'b0110: result <= src1 - src2; //SUB
            4'b0111: result <= src1 < src2; //SLT SLTI BEQ
            4'b0100: result <= src1 << src2; //SLLI
            4'b0101: result <= src1 ^ src2; //XOR
            default: result <= 32'b0;
        endcase
    end
end
endmodule
