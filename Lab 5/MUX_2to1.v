
`timescale 1ns/1ps

module MUX_2to1(
    input  [31:0] data0_i,
    input  [31:0] data1_i,
    input         select_i,
    output reg [31:0] data_o
);

always @(*) begin
    case (select_i)
        2'b00: data_o <= data0_i;
        2'b01: data_o <= data1_i;
        default: data_o <= 32'b0;
    endcase
end

endmodule
