
`timescale 1ns/1ps
/*instr[30,14:12]*/
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
			6'b100000: ALU_Ctrl_o = 4'b0010; //ADD
			6'b100010: ALU_Ctrl_o = 4'b0111; //SLT
            6'b10?000: ALU_Ctrl_o = 4'b0010; //ADDI
            6'b00?010: ALU_Ctrl_o = 4'b0010; //LW, SW
            6'b01?000: ALU_Ctrl_o = 4'b0111; //BEQ
            default: ALU_Ctrl_o = 4'b0000; //NOP
		endcase
	end

endmodule

