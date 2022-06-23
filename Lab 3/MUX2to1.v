module MUX2to1(
	input      src1,
	input      src2,
	input	   select,
	output     result
	);

	assign result = (src1 && (!select)) || (src2 && select);

endmodule
