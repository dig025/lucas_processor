// CSE141L
// possible lookup table for PC target
// leverage a few-bit pointer to a wider number
// Lookup table acts like a function: here Target = f(Addr);
//  in general, Output = f(Input); 
module LUT(
  input        [3:0] ptrn_number,	  // from dat_mem[61][3:0]
  output logic [7:0] tap_ptrn);

  logic [7:0] LFSR_ptrn[16];

  assign LFSR_ptrn[ 0] = 8'h60;	
  assign LFSR_ptrn[ 1] = 8'h48;
  assign LFSR_ptrn[ 2] = 8'h78;
  assign LFSR_ptrn[ 3] = 8'h72;
  assign LFSR_ptrn[ 4] = 8'h6A;
  assign LFSR_ptrn[ 5] = 8'h69;
  assign LFSR_ptrn[ 6] = 8'h5C;
  assign LFSR_ptrn[ 7] = 8'h7E;
  assign LFSR_ptrn[ 8] = 8'h7B;
  assign LFSR_ptrn[ 9] = 8'h48;	      // repeat ptrns [1...7]
  assign LFSR_ptrn[10] = 8'h78;
  assign LFSR_ptrn[11] = 8'h72;
  assign LFSR_ptrn[12] = 8'h6A;
  assign LFSR_ptrn[13] = 8'h69;
  assign LFSR_ptrn[14] = 8'h5C;
  assign LFSR_ptrn[15] = 8'h7E;

  assign tap_ptrn = LFSR_ptrn[ptrn_number];

endmodule