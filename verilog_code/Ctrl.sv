// CSE141L
import definitions::*;
// control decoder (combinational, not clocked)
// inputs from instrROM, ALU flags
// outputs to program_counter (fetch unit)
module Ctrl (
  input[ 8:0] Instruction,	   // machine code
  output logic Jump,
               BranchEn,
					GenRegEn
  );
// jump on right shift that generates a zero
always_comb
  if(Instruction[2:0] ==  kSRL)
    Jump = 1;
  else
    Jump = 0;

// branch every time ALU result LSB = 0 (even)
assign BranchEn = &Instruction[3:0];

// decides whether to write to operational register or a general register
// when GenRegEn = 0, we write to op register
// when GenRegEn = 1, we write to general register
always_comb 
	if(Instruction[7:6] == kGROP && Instruction[5:4] != kGFN)
		GenRegEn = 0;
	else
		GenRegEn = 1;

endmodule

