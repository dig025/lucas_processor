// CSE141L
import definitions::*;
// control decoder (combinational, not clocked)
// inputs from instrROM, ALU flags
// outputs to program_counter (fetch unit)
module Ctrl (
  input[ 8:0] Instruction,	   // machine code
  output logic BranchEn,
					RegWriteEn,
					MemWriteEn
  );

// decide whether instruction is a branch instruction based on op and func bits
always_comb
	if(Instruction[7:6] == kRTYPE && Instruction[5:4] == kEQ)
		BranchEn = 1;
	else
		BranchEn = 0;

// wire to determine whether we will write to a register
always_comb
	if((Instruction[7:6] == kRTYPE && Instruction[5:4] == kEQ) || 
		(Instruction[7:6] == kLSTYPE && Instruction[5:4] == kSB))
		RegWriteEn = 0;
	else
		RegWriteEn = 1;

always_comb
	if(Instruction[7:6] == kLSTYPE && Instruction[5:4] == kSB)
		MemWriteEn = 1;
	else
		MemWriteEn = 0;
		
endmodule

