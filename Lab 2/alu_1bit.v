`timescale 1ns/1ps

module Full_adder (
	input A, input B, input cin, output sum, output cout
);

	assign sum = (A ^ B) ^ cin;
	assign cout = (A && B) || (cin && (A ^ B));

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
