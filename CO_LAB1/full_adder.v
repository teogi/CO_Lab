`timescale 1ns / 1ps

module Full_Adder(
    In_A, In_B, Carry_in, Sum, Carry_out
    );
    input In_A, In_B, Carry_in;
    output Sum, Carry_out;
    
	// implement full adder circuit, your code starts from here.
	// use half adder in this module, fulfill I/O ports connection.
    wire S1;
	wire C1,C2;
	Half_Adder HAD1 (.In_A(In_A),.In_B(In_B),
					.Sum(S1),.Carry_out(C1)
    );
	Half_Adder HAD2 (.In_A(S1),.In_B(Carry_in),
					.Sum(Sum),.Carry_out(C2)
    );
	or(Carry_out,C1,C2);
    
endmodule
