// Create Date:    2018.10.15
// Module Name:    ALU 
// Project Name:   CSE141L
//
// Revision 2018.01.27
// Additional Comments: 
//   combinational (unclocked) ALU
import definitions::*;			         // includes package "definitions"
module ALU(
  input        [7:0] InputA,             // data inputs
                     InputB,
  input        [2:0] Function,		         // ALU opcode, part of microcode
  output logic [7:0] Out,		         // or:  output reg [7:0] OUT,
  output logic       takeBranch        // output = 1 when beq is true 0 when false
    );								    
	 
  op_mne op_mnemonic;			         // type enum: used for convenient waveform viewing
	
  always_comb begin
    Out = 0;                             // No Op = default
    case(Function)
      kADD : Out = InputA + InputB;      // add 
		kOR  : Out = InputA | InputB;
		kXOR : Out = InputA ^ InputB;
		kAND : Out = InputA & InputB;
		kLT  : Out = InputA < InputB;
		kEQ  : Out = InputA == InputB;
		kSLL : Out = InputA << InputB;
		kSRL : Out = {1'b0, InputA[7:1]};
    endcase
  end

  assign takeBranch = Out;
//  always_comb										
//    case(Out)
//      1'b0   : takeBranch = 1'b1;
//	  default : takeBranch = 1'b0;
//    endcase

  always_comb
    op_mnemonic = op_mne'(Function);			 // displays operation name in waveform viewer

endmodule