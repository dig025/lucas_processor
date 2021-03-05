// Create Date:    2017.01.25
// Design Name:    CSE141L
// Module Name:    reg_file 
//
// Additional Comments: 					  $clog2

/* parameters are compile time directives 
       this can be an any-size reg_file: just override the params!
*/
import definitions::*;			         // includes package "definitions"
module RegFile #(parameter W=8, D=4)(		  // W = data path width; D = pointer width
  input                Clk,
                       RegWriteEn,
  input        [D-1:0] Regaddr,				  // address pointers
  input			[7:0]   Imm,
  input logic      	  OpReg,
  input			[1:0]   Function,
  input 			[1:0]	  OpCode,
  input        [W-1:0] DataIn,
  output       [W-1:0] DataOutA,			  // showing two different ways to handle DataOutX, for
  output logic [W-1:0] DataOutB,  //   pedagogic reasons only
  output logic [W-1:0] DataOutC
    );

// W bits wide [W-1:0] and 2**4 registers deep 	 
logic [W-1:0] Registers[2**D];	  // or just registers[16] if we know D=4 always

// combinational reads 
/* can write always_comb in place of assign
    difference: assign is limited to one line of code, so
	always_comb is much more versatile     
*/
assign DataOutA = Registers[1];	  // can't read from addr 0, just like MIPS
assign DataOutB = Registers[2];    // can read from addr 0, just like ARM
assign DataOutC = Registers[Regaddr];


// sequential (clocked) writes 
always_ff @ (posedge Clk)
  if (RegWriteEn) begin	             // works just like data_memory writes
    if (OpCode[1] == 1'b1)
		Registers[0] <= Imm;
	 else if (OpCode == kLSTYPE && Function == kFIG)
		Registers[Regaddr] = Registers[0];
	 else if (OpCode == kLSTYPE && Function == kFGO)
		Registers[OpReg+2'b01] = Registers[Regaddr];
	 else
	   Registers[Regaddr] <= DataIn;
  end

endmodule
