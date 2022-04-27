`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    15:15:11 08/18/2013
// Design Name:
// Module Name:    alu
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

module alu(
           clk,           // system clock              (input)
           rst_n,         // negative reset            (input)
           src1,          // 32 bits source 1          (input)
           src2,          // 32 bits source 2          (input)
           ALU_control,   // 4 bits ALU control input  (input)
           result,        // 32 bits result            (output)
           zero,          // 1 bit when the output is 0, zero must be set (output)
           cout,          // 1 bit carry out           (output)
           overflow       // 1 bit overflow            (output)
           );

input           clk;
input           rst_n;
input  [32-1:0] src1;
input  [32-1:0] src2;
input   [4-1:0] ALU_control;

output [32-1:0] result;
output          zero;
output          cout;
output          overflow;

reg    [32-1:0] result;
reg             zero;
reg             cout;
reg             overflow;

/*	mycode	*/
supply0 gnd;

wire    [2-1:0] op;
reg    [32-1:0] src1_tmp;
reg    [32-1:0] src2_tmp;

wire 			A_invert;
wire 			B_invert;
wire 			less;
wire 			cin;
wire   [32-1:0] result_tmp;
wire   [32-1:0] cout_tmp;



assign A_invert = 	ALU_control[4];  // nor
assign B_invert = 	// sub
					// nor
					// slt
assign cin 		= 	(ALU_control==4'b0110)|| // sub
					(ALU_control==4'b0111);  
assign op 		= 	(ALU_control==4'h0)? 2'b00:
					((ALU_control==4'h1||ALU_control==4'hc)? 2'b01:
					((ALU_control==4'h2||ALU_control==4'h6)? 2'b10:
					(((ALU_control==4'h7) ? 2'b11:2'b0))));

/*
assign A_invert = 	(ALU_control==4'b1100);  // nor
assign B_invert = 	(ALU_control==4'b0110 || // sub
					 ALU_control==4'b1100 || // nor
					 ALU_control==4'b0111);  // slt
assign cin 		= 	(ALU_control==4'b0110)|| // sub
					(ALU_control==4'b0111);  
assign op 		= 	(ALU_control==4'h0)? 2'b00:
					((ALU_control==4'h1||ALU_control==4'hc)? 2'b01:
					((ALU_control==4'h2||ALU_control==4'h6)? 2'b10:
					(((ALU_control==4'h7) ? 2'b11:2'b0))));
*/

genvar i;
generate
for(i=0;i<32;i=i+1)
	begin: gen_alu_top
		if(i==0)
			alu_top ALU_T(
						.src1(src1[i]),     //1 bit source 1 (input)
						.src2(src2[i]),     //1 bit source 2 (input)
						.less(less),      		//1 bit less     (input)
						.A_invert(A_invert),   		//1 bit A_invert (input)
						.B_invert(B_invert),   		//1 bit B_invert (input)
						.cin(cin),       		//1 bit carry in (input)
						.operation(op),  	//operation      (input)
						.result(result_tmp[i]), //1 bit result   (output)
						.cout(cout_tmp[i])       		//1 bit carry out(output)
						);
		else if(i==31)
			alu_btm ALU_B(
						.src1(src1[i]),       //1 bit source 1 (input)
						.src2(src2[i]),       //1 bit source 2 (input)
						.less(gnd),       //1 bit less     (input)
						.A_invert(A_invert),   //1 bit A_invert (input)
						.B_invert(B_invert),   //1 bit B_invert (input)
						.cin(cout_tmp[i-1]),        //1 bit carry in (input)
						.operation(op),  //operation      (input)
						.result(result_tmp[i]),     //1 bit result   (output)
						.cout(cout_tmp[i]),       //1 bit carry out(output)
						.set(less)	   //1 bit less than comparison set(output)
						);
		else
			alu_top ALU_T(
						.src1(src1[i]),     		//1 bit source 1 (input)
						.src2(src2[i]),     		//1 bit source 2 (input)
						.less(gnd),      		//1 bit less     (input)
						.A_invert(A_invert),   		//1 bit A_invert (input)
						.B_invert(B_invert),   		//1 bit B_invert (input)
						.cin(cout_tmp[i-1]),       	//1 bit carry in (input)
						.operation(op),  			//operation      (input)
						.result(result_tmp[i]), 		//1 bit result   (output)
						.cout(cout_tmp[i])       	//1 bit carry out(output)
						);
	end
endgenerate

/*			
case(ALU_control)
		4'b0000:assign op = 2'b00;	//And
		4'b0001:assign op = 2'b01;	//Or
		4'b0010:assign op = 2'b10;	//Addition
		4'b0110:assign op = 2'b10;	//Subtraction
		4'b1100:assign op = 2'b01;	//Nor
		4'b0111:assign op = 2'b11;	//Set less than
endcase
*/
/*end of my code*/
/*
always@( posedge clk or negedge rst_n ) 
begin
	if(!rst_n) begin
		src1_tmp <= 0;
		src2_tmp <= 0;
	end
	else begin
		src1_tmp <= src1;
		src2_tmp <= src2;
	end
end
*/
always@( posedge clk or negedge rst_n ) 
begin
	if(!rst_n) begin
		result <= 0;
	end
	else begin
		result <= result_tmp;
	end
/*
		$display("op:%d",op);
		$display("ALU_ctrl:%d",ALU_control);
		$display("rst:%d",rst_n);
		$display("src1:%h",src1);
		$display("src2:%h",src2);
		$display("A_invert:%d",A_invert);
		$display("B_invert:%d",B_invert);
		$display("result_tmp:%h",result_tmp);
*/
end

always@( posedge clk or negedge rst_n ) 
begin
	if(!rst_n) begin
		zero <= 0;
		cout <= 0;
		overflow <= 0;
	end
	else begin
		zero <= (result_tmp==0);
		cout <= (ALU_control==4'b0010||ALU_control==4'b0110)?	cout_tmp[31]:0;
		overflow <= (ALU_control==4'b0010||ALU_control==4'b0110)?	(cout_tmp[31]!=cout_tmp[30]):0;
	end
end

endmodule
