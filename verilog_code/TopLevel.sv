// Create Date:    2018.04.05
// Design Name:    BasicProcessor
// Module Name:    TopLevel 
// CSE141L
// partial only										   
module TopLevel(		   // you will have the same 3 ports
    input        Reset,	   // init/reset, active high
			     Start,    // start next program
	             Clk,	   // clock -- posedge used inside design
    output logic Ack	   // done flag from DUT
    );

wire [ 9:0] PgmCtr,        // program counter
			PCTarg;
wire [ 8:0] Instruction;   // our 9-bit opcode
wire [ 7:0] operator1, operator2, sourceReg;  // reg_file outputs
wire [7:0]  ReadA, ReadB, ReadC;
wire [ 7:0] InA, InB,  // ALU operand inputs
            ALU_out;       // ALU result
wire [ 7:0] RegWriteValue, // data in to reg file
            MemWriteValue, // data in to data_memory
	   	    MemReadValue;  // data out from data_memory
wire        MemWrite,	   // data_memory write enable
			RegWrEn,	   // reg_file write enable
			takeBranch,		   // ALU output = 0 flag
            Jump,	       // to program counter: jump 
            BranchEn,	   // to program counter: branch enable
				GenRegEn;		// to reg file: decides whether to write to
									// operational register or a general register
logic[15:0] CycleCt;	   // standalone; NOT PC!

// Fetch = Program Counter + Instruction ROM
// Program Counter
  InstFetch IF1 (
	.Reset       (Reset   ) , 
	.Start       (Start   ) ,  // SystemVerilg shorthand for .halt(halt), 
	.Clk         (Clk     ) ,  // (Clk) is required in Verilog, optional in SystemVerilog
	.BranchRelEn (BranchEn) ,  // branch enable
	.ALU_flag	 (takeBranch    ) ,
    .Target      (PCTarg  ) ,
	.ProgCtr     (PgmCtr  )	   // program count = index to instruction memory
	);					  

// Control decoder
  Ctrl Ctrl1 (
	.Instruction  (Instruction), // from instr_ROM
	.BranchEn     (BranchEn),		 // to PC
	.GenRegEn	  (GenRegEn)
  );
// instruction ROM
  InstROM #(.W(9)) IR1(
	.InstAddress   (PgmCtr), 
	.InstOut       (Instruction)
	);

  assign LoadInst = Instruction[7:6]==3'b01;  // calls out load specially
  assign Ack = &Instruction;
// reg file
	RegFile #(.W(8),.D(3)) RF1 (
		.Clk    				  ,
		.WriteEn   (RegWrEn)    , 
		.OpReg	 (Instruction[4]),
		.Function (Instruction[6:5]),
		.Regaddr    (Instruction[3:0]),         
		.Imm       (Instruction[7:0]), 	       
		.DataIn    (RegWriteValue) ,
		.DataOutA  (ReadA) , 
		.DataOutB  (ReadB),
		.DataOutC  (ReadC)
	);
// one pointer, two adjacent read accesses: (optional approach)
//	.raddrA ({Instruction[5:3],1'b0});
//	.raddrB ({Instruction[5:3],1'b1});

    assign InA = ReadA;						          // connect RF out to ALU in
	assign InB = ReadB;
	assign PCTarg = ReadC;
	assign MemWrite = (Instruction == 9'h111);       // mem_store command
	assign RegWriteValue = LoadInst? MemReadValue : ALU_out;  // 2:1 switch into reg_file
    ALU ALU1  (
	  .InputA  (InA),
	  .InputB  (InB),
	  .Function(Instruction[6:4]),
	  .Out     (ALU_out),//regWriteValue),
	  .takeBranch
	  );
  
	DataMem DM1(
		.DataAddress  (ReadA)    , 
		.WriteEn      (MemWrite), 
		.DataIn       (MemWriteValue), 
		.DataOut      (MemReadValue)  , 
		.Clk 		  		     ,
		.Reset		  (Reset)
	);
	
// count number of instructions executed
always_ff @(posedge Clk)
  if (Start == 1)	   // if(start)
  	CycleCt <= 0;
  else if(Ack == 0)   // if(!halt)
  	CycleCt <= CycleCt+16'b1;

endmodule