//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      0816192
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
`timescale 1ns/1ps
module Simple_Single_CPU(
        clk_i,
		rst_i
		);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signals
////Program Counter
wire [32-1:0] pc_in_i;
wire [32-1:0] pc_out_o;
////Adder1	 
wire [32-1:0] add1_out_o;
////Instr_Memory
wire [32-1:0] instr_o;
wire [ 6-1:0] op;
wire [ 5-1:0] ins_col2;		  
wire [ 5-1:0] ins_col3;		  
wire [ 5-1:0] ins_col4;
wire [15-1:0] ins_iform;
wire [ 6-1:0] funct;		  
////Mux_Write_Reg
wire  [5-1:0] mux_rw;
////Decoder
wire  [3-1:0] ALUOp;
wire		  ALUSrc;
wire		  Branch;
wire		  RegWrite;
wire		  RegDst;
////Reg_File
wire [32-1:0] RSdata_o;
wire [32-1:0] RTdata_o;
////ALU_Ctrl
wire  [4-1:0] ALUCtrl_o;
////Sign_Extend
wire [32-1:0] sign_extend_o;
////Mux_ALUSrc
wire [32-1:0] mux_alu_src;
////ALU
wire [32-1:0] ALU_result_o;
wire 		  zero_o;
////Adder2
wire [32-1:0] add2_out_o;
////Shift_Left_Two_32
wire [32-1:0] shift_left_o;
////Mux_PC_Source
wire [32-1:0] mux_pc_src;
wire 		  s_mux_pc_src;



//signal check
/*
always @(pc_in_i,pc_out_o)begin
	$display("\npc_i:%h",pc_in_i);
	$display("pc:%h",pc_out_o);
end
always @(add1_out_o)begin
	$display("add1:%h",add1_out_o);
end
always @(instr_o)begin
	$display("instr:%h",instr_o);
end
always @(RSdata_o)begin
	$display("rs:%h",RSdata_o);
end
always @(RTdata_o)begin
	$display("rt:%h",RTdata_o);
end
always @(mux_pc_src)begin
	$display("mux_pc:%h",instr_o);
end
always @(mux_alu_src)begin
	$display("mux_alu_src:%h",mux_alu_src);
end
*/

//Wire connection
assign pc_in_i 		= mux_pc_src;
assign op			= instr_o[31:26];
assign ins_col2		= instr_o[25:21];
assign ins_col3		= instr_o[20:16];
assign ins_col4		= instr_o[15:11];
assign ins_iform	= instr_o[15: 0];
assign funct		= instr_o[ 5: 0];
assign s_mux_pc_src = zero_o & Branch;

//Create componentes
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i(rst_i),     
	    .pc_in_i(pc_in_i),   
	    .pc_out_o(pc_out_o) 
	    );
	
Adder Adder1(
        .src1_i(32'd4),     
	    .src2_i(pc_out_o),     
	    .sum_o(add1_out_o)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(pc_out_o),  
	    .instr_o(instr_o)    
	    );

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr_o[20:16]),
        .data1_i(instr_o[15:11]),
        .select_i(RegDst),
        .data_o(mux_rw)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_i(rst_i),     
        .RSaddr_i(instr_o[25:21]),  
        .RTaddr_i(instr_o[20:16]),  
        .RDaddr_i(mux_rw) ,  
        .RDdata_i(ALU_result_o), 
        .RegWrite_i(RegWrite),
        .RSdata_o(RSdata_o),  
        .RTdata_o(RTdata_o)  
        );
	
Decoder Decoder(
        .instr_op_i(instr_o[31:26]), 
	    .RegWrite_o(RegWrite), 
	    .ALU_op_o(ALUOp),   
	    .ALUSrc_o(ALUSrc),   
	    .RegDst_o(RegDst),   
		.Branch_o(Branch)   
	    );

ALU_Ctrl AC(
        .funct_i(instr_o[5:0]), 
        .ALUOp_i(ALUOp),
        .ALUCtrl_o(ALUCtrl_o) 
        );
		
Sign_Extend SE(
        .data_i(instr_o[15:0]),
        .data_o(sign_extend_o)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(RTdata_o),
        .data1_i(sign_extend_o),
        .select_i(ALUSrc),
        .data_o(mux_alu_src)
        );	

ALU ALU(
        .src1_i(RSdata_o),
	    .src2_i(mux_alu_src),
	    .ctrl_i(ALUCtrl_o),
	    .result_o(ALU_result_o),
		.zero_o(zero_o)
	    );
		
Adder Adder2(
        .src1_i(add1_out_o),
	    .src2_i(shift_left_o),     
	    .sum_o(add2_out_o)      
	    );
		
Shift_Left_Two_32 Shifter(
        .data_i(sign_extend_o),
        .data_o(shift_left_o)
        ); 		
		
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(add1_out_o),
        .data1_i(add2_out_o),
        .select_i(s_mux_pc_src),
        .data_o(mux_pc_src)
        );	

endmodule
		  


