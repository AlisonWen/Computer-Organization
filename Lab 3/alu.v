module Full_adder (
	input A, input B, input cin, output sum, output cout
);

	assign sum = (A ^ B) ^ cin;
	assign cout = (A && B) || (cin && (A ^ B));

endmodule 

module MUX2to1(
	input      src1,
	input      src2,
	input	   select,
	output     result
	);

	assign result = (src1 && (!select)) || (src2 && select);

endmodule

module MUX4to1(
	input			src1,
	input			src2,
	input			src3,
	input			src4,
	input   [2-1:0] select, // input [1:0] select
	output  		result
	);
assign result = ((~select[0]) && (~select[1]) && src1) || (select[0] && (~select[1]) && src2) || ((~select[0]) && select[1] && src3) || (select[0] && select[1] && src4);
	
endmodule


module alu_1bit(
	input				src1,       //1 bit source 1  (input)
	input				src2,       //1 bit source 2  (input)
	input				less,       //1 bit less      (input)
	input 				Ainvert,    //1 bit A_invert  (input)
	input				Binvert,    //1 bit B_invert  (input)
	input 				cin,        //1 bit carry in  (input)
	input 	    [2-1:0] operation,  //2 bit operation (input)
	output              result,     //1 bit result    (output)
	output              cout        //1 bit carry out (output)
	);
	wire  a, b, ans1, ans2, ans3;
	MUX2to1 M1(src1, ~src1, Ainvert, a);
	MUX2to1 M2(src2, ~src2, Binvert, b);

	and G1(ans1, a, b);
	or G2(ans2, a, b);
	Full_adder FA(a, b, cin, ans3, cout);
	MUX4to1 M3(ans1, ans2, ans3, less, operation, result);
	
endmodule


module alu(
	input                   rst_n,         // negative reset            (input)
	input signed [32-1:0]   src1,          // 32 bits source 1          (input)
	input signed [32-1:0]	src2,          // 32 bits source 2          (input)
	input 	     [ 4-1:0] 	ALU_control,   // 4 bits ALU control input  (input)
	output reg   [32-1:0]	result,        // 32 bits result            (output)
	output reg              zero,          // 1 bit when the output is 0, zero must be set (output)
	output reg              cout,          // 1 bit carry out           (output)
	output reg              overflow       // 1 bit overflow            (output)
	);
	
	wire [31:0] sra, sll, exclusive_or;

	assign sra = src1 >>> src2;
	assign sll = src1 << src2;
	assign exclusive_or = src1 ^ src2;

	wire [32:0] carryOut;
	wire [31:0] buffer;
	wire set, dummy, tmp_zero, tmp_cout;
	genvar i;
	//assign carryOut[0] = ALU_control[2];

	alu_1bit ALU[31:1](
	    .src1(src1[31:1]),       //1 bit source 1 (input)
	    .src2(src2[31:1]),       //1 bit source 2 (input)
	    .less(1'b0),             //1 bit less     (input)
	    .Ainvert(ALU_control[3]),     //1 bit Ainvert (input)
	    .Binvert(ALU_control[2]),     //1 bit Binvert (input)
	    .cin(carryOut[31:1]),       //1 bit cin (input)
	    .operation(ALU_control[1:0]),  //operation      (input)
	    .result(buffer[31:1]),   //1 bit result   (output)
	    .cout(carryOut[32:2])       //1 bit cout(output)
	);

	Full_adder FA1(src1[31], ~src2[31], carryOut[31], set, tmp_cout);
	
	alu_1bit ALU1(src1[0], src2[0], set, ALU_control[3], ALU_control[2], ALU_control[2], ALU_control[1:0], buffer[0], carryOut[1]);
	
	assign dummy = (ALU_control[1] && (!ALU_control[0])) ? carryOut[32] ^ carryOut[31] : 1'b0;

	assign tmp_zero = buffer[0]|buffer[1]|buffer[2]|buffer[3]|buffer[4]|buffer[5]|buffer[6]|buffer[7]|
		buffer[8]|buffer[9]|buffer[10]|buffer[11]|buffer[12]|buffer[13]|buffer[14]|buffer[15]|
		buffer[16]|buffer[17]|buffer[18]|buffer[19]|buffer[20]|buffer[21]|buffer[22]|buffer[23]|
		buffer[24]|buffer[25]|buffer[26]|buffer[27]|buffer[28]|buffer[29]|buffer[30]|buffer[31];

	always @(*) begin	
		overflow = dummy;
		zero = ~tmp_zero;
		if (ALU_control[1] && !ALU_control[0]) 
			cout = carryOut[32];
		else cout = 1'b0;
		if (ALU_control == 4'b0011) result = sra;
		else if(ALU_control == 4'b0100) result = sll;
		else if(ALU_control == 4'b0101) result = exclusive_or;
		else result = buffer;
	end
	


endmodule
