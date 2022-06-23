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
