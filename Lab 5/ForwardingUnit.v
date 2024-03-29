`timescale 1ns/1ps
module ForwardingUnit (
    input [5-1:0] IDEXE_RS1,
    input [5-1:0] IDEXE_RS2,
    input [5-1:0] EXEMEM_RD,
    input [5-1:0] MEMWB_RD,
    input [2-1:0] EXEMEM_RegWrite,
    input [2-1:0] MEMWB_RegWrite,
    output reg [2-1:0] ForwardA,
    output reg [2-1:0] ForwardB
);

always @(*) begin
    if (EXEMEM_RegWrite && EXEMEM_RD != 0 && EXEMEM_RD == IDEXE_RS1)
        ForwardA <= 2'b10;
    else if (MEMWB_RegWrite && MEMWB_RD != 0 && EXEMEM_RD != IDEXE_RS1 && MEMWB_RD == IDEXE_RS1)
        ForwardA <= 2'b01;
    else ForwardA <= 2'b00;
    
    if (EXEMEM_RegWrite && EXEMEM_RD != 0 && EXEMEM_RD == IDEXE_RS2)
        ForwardB <= 2'b10;
    else if (MEMWB_RegWrite && MEMWB_RD != 0 && EXEMEM_RD != IDEXE_RS2 && MEMWB_RD == IDEXE_RS2)
        ForwardB <= 2'b01;
    else ForwardB <= 2'b00;
end

endmodule

