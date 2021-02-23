import os.path
import sys

print('Assembling to machine code:')

if(len(sys.argv) > 1):
  filename = sys.argv[1]
  file_exists = True
else:
  print("ERROR: path to assembly code not passed as arg. Usage: assembler path/assembly.txt")
  sys.exit()

assembly_file = open(filename, 'r')

#w_file is the file we are writing to
w_file = open("machine_code.txt", "w")

#Open a file name and read each line
#to strip \n newline chars
#lines = [line.rstrip('\n') for line in open('filename')]  

#1. open the file
#2. for each line in the file,
#3. split the string by white spaces
#4. determine op code and func if exists
#5. if op = 1 then use is imm
#6. determine regs based on op and func
#7. finally add them up as a string and write to file
with open(filename, 'r') as f:
  for line in f:
    str_array = line.split()

    if(len(str_array) == 0):
      continue

    instruction = str_array[0]

    if(instruction[0] == "/"):
      #do nothing
      continue
    elif instruction == "is":
      opcode = "1"
      imm_num = int(str_array[1], 0)
      if(imm_num < 0):
        imm_num = imm_num + (1<<32)
      imm = '{0:08b}'.format(imm_num)
      imm = imm[-8:]
      machine_code = opcode + imm
    else:
      if instruction == "add":
        opcode = "00"
        func = "000"
      elif instruction == "xor":
        opcode = "00" 
        func = "001"
      elif instruction == "and":
        opcode = "00"
        func = "010"
      elif instruction == "sll":
        opcode = "00"
        func = "011"
      elif instruction == "slt":
        opcode = "00" 
        func = "100"
      elif instruction == "beq": 
        opcode = "00"
        func = "101"
      elif instruction == "or":
        opcode = "00"
        func = "110"
      elif instruction == "srl":
        opcode = "00" 
        func = "111"
      elif instruction == "lb":
        opcode = "01"
        func = "00"
      elif instruction == "sb":
        opcode = "01"
        func = "01"
      elif instruction == "fig":
        opcode = "01"
        func = "10"
      elif instruction == "fgo":
        opcode = "01"
        func = "11"
      else:
        opcode = "error: undefined opcode"
        print(opcode)

      if(opcode == "00"):
        reg_str = str_array[1]
        reg_str = reg_str[1:]
        gen_reg = '{0:04b}'.format(int(reg_str))
        machine_code = opcode + func + gen_reg
      else:
        if func == "10":
          op_reg = "0"    #fig does not use op reg so default to 0

          reg_str = str_array[1]
          reg_str = reg_str[1:]
          gen_reg = '{0:04b}'.format(int(reg_str))
        elif func == "11":
          op_str = str_array[2]
          op_str = op_str[1:]
          op_num = (int(op_str))
          op_reg = "0" if op_num == 1 else "1"

          reg_str = str_array[1]
          reg_str = reg_str[1:]
          gen_reg = '{0:04b}'.format(int(reg_str))
        else:
          op_str = str_array[1]
          op_str = op_str[1:]
          op_num = (int(op_str))
          op_reg = "0" if op_num == 1 else "1"

          reg_str = str_array[2]
          reg_str = reg_str[1:]
          gen_reg = '{0:04b}'.format(int(reg_str))
        
        machine_code = opcode + func + op_reg + gen_reg

    print(machine_code)
    w_file.write(machine_code + '\n' )

  w_file.close()
   

      


