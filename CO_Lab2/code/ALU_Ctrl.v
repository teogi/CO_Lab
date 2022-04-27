//Subject:     CO project 2 - ALU Controller
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
module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter

       
//Select exact operation
always @(*)begin
	case(ALUOp_i)
		1:	ALUCtrl_o <= 6; //beq
		2://R-type
			case(funct_i)
				32: ALUCtrl_o <= 2; //Addition
				34:	ALUCtrl_o <= 6; //Subtraction
				36:	ALUCtrl_o <= 0; //And
				37:	ALUCtrl_o <= 1; //Or
				42:	ALUCtrl_o <= 7; //Set on Less than
			endcase
		3: ALUCtrl_o <= 2;	//addi
		4: ALUCtrl_o <= 7;	//slti
		default: ALUCtrl_o <= 4'b1111;
	endcase
end

endmodule     





                    
                    