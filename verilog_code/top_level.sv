// Create Date:    2018.04.05
// Design Name:    BasicProcessor
// Module Name:    TopLevel 
// CSE141L
// partial only
import definitions::*;			         // includes package "definitions"										   
module top_level(		   // you will have the same 3 ports
    input        init,	   // init/reset, active high
			        req,    // start next program
	              clk,	   // clock -- posedge used inside design
    output logic ack	   // done flag from DUT
    );

wire [ 9:0] PgmCtr,        // program counter
			PCTarg;
wire [ 8:0] Instruction;   // our 9-bit opcode
wire [ 7:0] operator1, operator2, sourceReg;  // reg_file outputs
wire [7:0]  ReadA, ReadB, ReadC;
wire [ 7:0] InA, InB;  // ALU operand inputs
          
wire [ 7:0] RegWriteValue, // data in to reg file
            MemWriteValue, // data in to data_memory
				ALU_Out,       // output from ALU
	   	    MemReadValue;  // data out from data_memory
wire        MemWriteEn,	   // data_memory write enable
			takeBranch,		   // ALU output = 0 flag
            BranchEn,	   // to program counter: branch enable
				RegWriteEn;			// Whether we are writing to register or not
logic[15:0] CycleCt;	   // standalone; NOT PC!
wire[7:0] test_reg[2**4];
wire[7:0] test_core[256];

// Fetch = Program Counter + Instruction ROM
// Program Counter
  InstFetch IF1 (
	.Reset       (init      ) , 
	.Start       (req       ) ,  // SystemVerilg shorthand for .halt(halt), 
	.Clk         (clk       ) ,  // (Clk) is required in Verilog, optional in SystemVerilog
	.BranchRelEn (BranchEn  ) ,  // branch enable
	.ALU_flag	 (takeBranch) ,
    .Target     (PCTarg    ) ,
	.ProgCtr     (PgmCtr    )	   // program count = index to instruction memory
	);					  

// Control decoder
  Ctrl Ctrl1 (
	.Instruction  (Instruction), // from instr_ROM
	.BranchEn     (BranchEn),		 // to PC
	.RegWriteEn   (RegWriteEn),
	.MemWriteEn   (MemWriteEn)
  );
// instruction ROM
  InstROM #(.W(9)) IR1(
	.InstAddress   (PgmCtr), 
	.InstOut       (Instruction)
	);

  assign ack = Instruction == 9'b0;
  
// reg file
	RegFile #(.W(8),.D(4)) RF1 (
		.Clk    			(clk)	  ,
		.RegWriteEn   (RegWriteEn)    , 
		.OpReg	 (Instruction[4]),
		.OpCode   (Instruction[8:7]),
		.Function (Instruction[6:5]),
		.Regaddr    (Instruction[3:0]),         
		.Imm       (Instruction[7:0]), 	       
		.DataIn    (RegWriteValue) ,
		.DataOutA  (ReadA) , 
		.DataOutB  (ReadB),
		.DataOutC  (ReadC),
		.test_reg (test_reg)
	);
	
// Mux to decide whether we use the value from ALU as RegWriteValue
// or the value from DataMem
	assign RegWriteValue = (Instruction[8:7] == kLSTYPE && Instruction[6:5] == kLB) ? MemReadValue : ALU_Out;
	
// Mux to decide which operation register is being written to memory
// ReadA and ReadB are always the operation registers
	assign MemWriteValue = Instruction[4] == 1'b0 ? ReadA : ReadB;
	
	
// one pointer, two adjacent read accesses: (optional approach)
//	.raddrA ({Instruction[5:3],1'b0});
//	.raddrB ({Instruction[5:3],1'b1});

   assign InA = ReadA;						          // connect RF out to ALU in
	assign InB = ReadB;
	assign PCTarg = $signed(ReadC);
	
    ALU ALU1  (
	  .InputA  (InA),
	  .InputB  (InB),
	  .Function(Instruction[6:4]),
	  .Out     (ALU_Out),//regWriteValue),
	  .takeBranch
	  );
  
	data_mem DM(
		.DataAddress  (ReadC)    , 
		.MemWriteEn   (MemWriteEn), 
		.DataIn       (MemWriteValue), 
		.DataOut      (MemReadValue)  , 
		.Clk 		  	  (clk)     ,
		.Reset		  (init),
		.core_out (test_core)
	);
	
// count number of instructions executed
always_ff @(posedge clk)
  if (req == 1)	   // if(start)
  	CycleCt <= 0;
  else if(ack == 0)   // if(!halt)
  	CycleCt <= CycleCt+16'b1;

endmodule