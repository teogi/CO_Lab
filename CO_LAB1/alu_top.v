`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:58:01 10/10/2013
// Design Name: 
// Module Name:    alu_top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module alu_top(
               src1,       //1 bit source 1 (input)
               src2,       //1 bit source 2 (input)
               less,       //1 bit less     (input)
               A_invert,   //1 bit A_invert (input)
               B_invert,   //1 bit B_invert (input)
               cin,        //1 bit carry in (input)
               operation,  //operation      (input)
               result,     //1 bit result   (output)
               cout        //1 bit carry out(output)
               );

input         src1;
input         src2;
input         less;
input         A_invert;
input         B_invert;
input         cin;
input [2-1:0] operation;

output        result;
output        cout;

reg           result;

wire src1_temp,src2_temp;

assign src1_temp=A_invert?~src1:src1;
assign src2_temp=B_invert?~src2:src2;

wire sum;

//assign {cout,sum}=src1_temp+src2_temp+cin;
assign sum = src1_temp^src2_temp^cin;
assign cout = (src1_temp&src2_temp)|(src1_temp&cin)|(src2_temp&cin);

//always@( src1_temp or src2_temp or operation)
always@(*)
begin
	case(operation)
		0:result <= src1_temp&src2_temp;
		1:result <= src1_temp|src2_temp;
		2:result <= sum;
		3:result <= less;
		default:result <= 0;
	endcase
end

endmodule