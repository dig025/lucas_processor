# Lucas Processor
### architects: Kyung Lee and Diego Gomez

This document describes the architecture of the Lucas Processor

This CPU is a very reduced RISC architecture and uses MIPS as inspiration. The big difference is that it uses 9-bit instructions and not a bit more! It was designed to do specific tasks well and not much else. This is not a general purpose architecture. The way Lucas is able to operate with only 9 bits is by specifying three special registers. The first register, r0, is used only for loading immediate values. The next two registers, r1 and r2, are operation registers. All arithmetic is done using r1 and r2 as operands.

## <p align=center>INSTRUCTION SYNTAX</p>
What follows are the specifications for the three main types of instructions our CPU can handle:
- R-Type: any instruction which uses both operation registers for arithmetic (e.g. add, sub, etc.)
- LS-Type: load store type, any instruction which transfers data into or out of a register
- I-Type: storing an 8-bit immediate value in the designated immediate register

## R-Type

| op | func | rs/rt |
| :--: | :---: | :----: |
| 0 0 | _ _ _ | _ _ _ _|

The first two bits in an instruction represent an op-code,
with R-Type instructions always having an op-code of 00.
The func field selects which R-type operation is to be performed using the two operation registers.
rt/rs is the register in which the return value of the operation will be stored in.
However on beq it is used as the amount to branch relative to pc. 

### R-TYPE FUNC OPTIONS

    0 0 0 – ADD (add the contents of r1 and r2, then store result in rt)
    0 0 1 – XOR (bitwise XOR the contents of r1 and r2, then store result in rt)
    0 1 0 – AND (bitwise AND the contents of r1 and r2, then store the result in rt)
    0 1 1 – SLL (the contents of r1 is logically shifted left by the contents of r2, then store the result in rt)
    1 0 0 – SLT (if the contents of r1 is less than the contents of r2, store a 1 in rt, otherwise store 0 in rt)
    1 0 1 – BEQ (checks the contents of r1 and r2 for equality, then if true, branches to PC + contents of rs)
    1 1 0 – OR (bitwise OR the contents of r1 and r2, then store the result in rt)
    1 1 1 – SRL (the contents of r1 is logically shifted right by the contents of r2, then store the result in rt)

### Example R-Type Instructions

    00 000 0011 – ADD register 1 and 2 together and store the sum in register 3 
    00 010 1100 – bitwise AND register 1 and 2 and store the result in register 12
    00 101 1011 – check register 1 and 2 for equality, if they are equal branch to PC + register 11, else dont take branch

## LS-Type

| op | func  | op reg | rt/rs |
| :--: | :--: | :-: | :----: |
| 0 1 | _ _ |  _ | _ _ _ _ |

LS-Type instructions are load store instructions. They use op-code 01.
The func field tells us what kind of operation we are performing. 
This includes loading the contents of memory into one of the operation registers, storing data from an operation register into memory,
and moving data between registers. The op reg is 1 bit and specifies whether we use register 1 or 2 (the default operation registers).
rt/rs specifies a register which may contain a value or the address of a location in memory that we wish to use, it can also be used as a target to store data in.

### LS-TYPE FUNC OPTIONS

    0 0 – LB (load the byte at address rs, then store the data in op reg)
    0 1 – SB (store the byte in op reg in memory at the address rt)
    1 0 – FIG (store the contents of the immediate register (r0) in rt; note: FIG does not use op reg so set it to 0)
    1 1 – FGO (store the contents of rs in op reg)

### Example LS-Type Instructions

    01 00 1 0111 – load the contents of MEM(r7) and store it in r2
    01 10 0 1011 – store the contents of r0 in r11

## I-Type

| op | immediate |
| :-: | :--------: |
| 1 | _ _ _ _ _ _ _ _ |

If the first bit of any instruction is a 1 then we treat it as an I-Type. There is only one I-Type instruction, this is IS (immediate store) it stores the immediate field of the instruction into register 0.

### Example I-Type Instructions
    1 10110011 – load immediate value of 179 into register 0 
    1 00110010 – load immediate value of 50 into register 0 
