// CSE141L
import definitions::*;
// control decoder (combinational, not clocked)
// inputs from instrROM, ALU flags
// outputs to program_counter (fetch unit)
module Ctrl (
  input[ 8:0] Instruction,	   // machine code
  output logic BranchEn,
					GenRegEn
  );

// decide whether instruction is a branch instruction based on op and func bits
always_comb
	if(Instruction[7:6] == kRTYPE && Instruction[5:4] == kEQ)
		BranchEn = 1;
	else
		BranchEn = 0;

// decides whether to write to operational register or a general register
// when GenRegEn = 0, we write to op register
// when GenRegEn = 1, we write to general register
always_comb 
	if(Instruction[7:6] == kGROP && Instruction[5:4] != kFIG)
		GenRegEn = 0;
	else
		GenRegEn = 1;

endmodule

