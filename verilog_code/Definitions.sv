//This file defines the parameters used in the alu
// CSE141L
package definitions;
    
// Instruction map
    const logic [2:0]kADD  = 3'b000;
    const logic [2:0]kOR = 3'b001;
	 const logic [2:0] kXOR = 3'b010;
	 const logic [2:0] kAND = 3'b011;
	 const logic [2:0] kLT = 3'b100;
	 const logic [2:0] kEQ = 3'b101;
	 const logic [2:0] kSLL = 3'b110;
	 const logic [2:0] kSRL = 3'b111;
	 const logic [1:0] kGROP  = 2'b01;
	 const logic [1:0] kGFN	= 2'b10;
	 //const logic [2:0]kLSH  = 3'b001;
    //const logic [2:0]kRSH  = 3'b010;
    //const logic [2:0]kXOR  = 3'b011;
    //const logic [2:0]kAND  = 3'b100;
	//const logic [2:0]kSUB  = 3'b101;
	//const logic [2:0]kCLR  = 3'b110;
// enum names will appear in timing diagram
    typedef enum logic[2:0] {
        ADD, OR, XOR, AND,
        LT, EQ, SLL, SRL } op_mne;
// note: kADD is of type logic[2:0] (3-bit binary)
//   ADD is of type enum -- equiv., but watch casting
//   see ALU.sv for how to handle this   
endpackage // definitions
