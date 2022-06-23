
`timescale 1ns/1ps
module ALU_Ctrl(
    input       [4-1:0] instr,
    input       [2-1:0] ALUOp,
    output reg     [4-1:0] ALU_Ctrl_o
);
wire [2:0] func3;
assign func3 = instr[2:0];

    wire [6-1:0] allInputs; 
	assign allInputs = {ALUOp, instr};
	
	always @(*) begin
		casez (allInputs)
			6'b100000: ALU_Ctrl_o <= 4'b0010; //ADD
            6'b101000: ALU_Ctrl_o <= 4'b0110; //SUB
            6'b100100: ALU_Ctrl_o <= 4'b0101; //XOR
            6'b100110: ALU_Ctrl_o <= 4'b0001; //OR
            6'b100111: ALU_Ctrl_o <= 4'b0000; //AND
			6'b100010: ALU_Ctrl_o <= 4'b0111; //SLT
            6'b10?000: ALU_Ctrl_o <= 4'b0010; //ADDI
            6'b100001: ALU_Ctrl_o <= 4'b0100; //SLLI
            6'b10?010: ALU_Ctrl_o <= 4'b0111; //SLTI
            6'b00?010: ALU_Ctrl_o <= 4'b0010; //LW, SW
            6'b01?000: ALU_Ctrl_o <= 4'b0111; //BEQ
            default: ALU_Ctrl_o <= 4'b0000;
		endcase
	end

endmodule

/*
Instructions to be supported:
- R
    - add
    - sub
    - xor
    - or
    - and
    - slt
- I
    - addi
    - nop (addi x0 x0 0)
    - slli
    - slti
    - lw
- S
    - sw
- B
    - beq
- J
    - jal
*/