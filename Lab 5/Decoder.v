`timescale 1ns/1ps

module Decoder(
    input [32-1:0]  instr_i,
    output reg         Branch,
    output reg         ALUSrc,
    output reg         RegWrite,
    output reg [2-1:0] ALUOp,
    output reg         MemRead,
    output reg         MemWrite,
    output reg         MemtoReg,
    output reg         Jump
);

//Internal Signals
wire    [7-1:0]     opcode = instr_i[6:0];
wire    [3-1:0]     funct3 = instr_i[14:12];
wire    [3-1:0]     Instr_field;
wire    [9:0]       Ctrl_o;

always @(*) begin
    case (opcode)
        7'b0110011: begin // R-type
            Branch <= 1'b0;
            ALUSrc <= 1'b0;
            RegWrite <= 1'b1;
            ALUOp <= 2'b10;
            MemRead <= 1'b0;
            MemWrite <= 1'b0;
            MemtoReg <= 1'b0;
            Jump <= 1'b0;
        end
        7'b0010011: begin // I-type
            Branch <= 1'b0;
            ALUSrc <= 1'b1;
            RegWrite <= 1'b1;
            ALUOp <= 2'b10;
            MemRead <= 1'b0;
            MemWrite <= 1'b0;
            MemtoReg <= 1'b0;
            Jump <= 1'b0;
        end
        7'b0000011: begin // LW
            Branch <= 1'b0;
            ALUSrc <= 1'b1;
            RegWrite <= 1'b1;
            ALUOp <= 2'b00;
            MemRead <= 1'b1;
            MemWrite <= 1'b0;
            MemtoReg <= 1'b1;
            Jump <= 1'b0;
        end
        7'b0100011: begin // SW
            Branch <= 1'b0;
            ALUSrc <= 1'b1;
            RegWrite <= 1'b0;
            ALUOp <= 2'b00;
            MemRead <= 1'b0;
            MemWrite <= 1'b1;
            MemtoReg <= 1'b0;
            Jump <= 1'b0;
        end
        7'b1100011: begin // BEQ
            Branch <= 1'b1;
            ALUSrc <= 1'b0;
            RegWrite <= 1'b0;
            ALUOp <= 2'b01;
            MemRead <= 1'b0;
            MemWrite <= 1'b0;
            MemtoReg <= 1'b0;
            Jump <= 1'b0;
        end
        7'b1101111: begin // JAL
            Branch <= 1'b0;
            ALUSrc <= 1'b0;
            RegWrite <= 1'b1;
            ALUOp <= 2'b11;
            MemRead <= 1'b0;
            MemWrite <= 1'b0;
            MemtoReg <= 1'b0;
            Jump <= 1'b1;
        end
        default: begin
            Branch <= 1'b0;
            ALUSrc <= 1'b0;
            RegWrite <= 1'b0;
            ALUOp <= 2'b00;
            MemRead <= 1'b0;
            MemWrite <= 1'b0;
            MemtoReg <= 1'b0;
            Jump <= 1'b0;
        end
    endcase

end
endmodule







