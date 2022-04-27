//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
`timescale 1ns/1ps
module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;

wire		   Rformat;
wire		   addi_ctrl;
wire		   slti_ctrl;
wire		   beq_ctrl;
//Parameter

//Main function
assign Rformat_ctrl = &(~instr_op_i);
assign beq_ctrl		= (instr_op_i== 6'd4);
assign addi_ctrl	= (instr_op_i== 6'd8);
assign slti_ctrl	= (instr_op_i==6'd10);

always @(instr_op_i)begin
	if(beq_ctrl)
		ALU_op_o <= 3'd1; //1 if it is beq
	else if(Rformat_ctrl)
		ALU_op_o <= 3'd2; //2 if it is R-format
	else if(addi_ctrl)
		ALU_op_o <= 3'd3; //3 if it is addi
	else if(slti_ctrl)
		ALU_op_o <= 3'd4; //4 if it is slti
	else
		ALU_op_o <= 3'b111;
end

always @(instr_op_i)begin
	ALUSrc_o <= addi_ctrl | slti_ctrl;
end

always @(instr_op_i)begin
	RegWrite_o <= Rformat_ctrl | addi_ctrl | slti_ctrl;
end

always @(instr_op_i)begin
	RegDst_o <= Rformat_ctrl;
end

always @(instr_op_i)begin
	Branch_o <= beq_ctrl;
end

endmodule





                    
                    