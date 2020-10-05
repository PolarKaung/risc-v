import argparse
from instCleanUp import get_instruction
from decode import decode

parser = argparse.ArgumentParser()
parser.add_argument("--file", "-f", help="assembly file", required=True)
parser.add_argument("--out", "-o", help="output machine code", required = True)
args = parser.parse_args()

f = open(args.file,'r')
wf = open(args.out,'w')
instList = f.readlines()
print(instList)
instructions, labels = get_instruction(instList)

##0 : two registers
##1 : one register, one imm
##2 : branch instructions
##3 : store instructions
##4 : load instructions
##5 : jal instruction
##6 : jalr instruction
##7 : upper immediate instructions

##10: custom for debug
opsList = {"add" :0,
           "sub" :0,
           "sll" :0,
           'slt' :0,
           'sltu':0,
           'xor' :0,
           'srl' :0,
           'sra' :0,
           'or'  :0,
           'and' :0,
           "addi":1,
           "slli":1,
           'slti':1,
           'sltiu':1,
           'xori':1,
           'ori' :1,
           'andi':1,
           'srli':1,
           'srai':1,
           'lw'  :1,
           'jalr':1,
           'beq' :2,
           'bne' :2,
           'blt' :2,
           'bge' :2,
           'bltu':2,
           'bgeu':2,
           'sw'  :3,
           'jal' :4,
           'auipc':5,
           'lui'  :5,
           'out'  :10}
##print(labels)
codes = decode(opsList, instructions, labels)
print(codes)
for i in codes:
    wf.write(i+"\n")
wf.close()
