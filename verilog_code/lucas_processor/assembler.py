import os.path
import sys


if(len(sys.argv) > 1):
  filename = sys.argv[1]
  file_exists = True
else:
  print("ERROR: path to assembly code not passed as arg. Usage: assembler path/assembly.txt")
  sys.exit()

assembly_file = open(filename, 'r')
lines = assembly_file.readlines()

for line in lines:
  line = line.strip()
  instruction = line.split()

if instruction[0] == "is":
  op = 1

if instruction[0] == "add":
  op = 00
  func = 00
  if instruction[1] == "r5":
    rt = 101

