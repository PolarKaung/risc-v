# risc-v
risc v implementation
This is my implementation of risc v, RV32I. 
It currently runs on de10-lite board.
It does not have complete instruction set yet.
This is not the end version, I will make it more usable, like variable naming, signal names, etc.
If I have my motivation, I will try to make an IP for it as well.

# Instruction set supported
lui
auipc
jal
jalr
beq
bne
blt
bge
bltu
bgeu
lw
sw
addi
slti
sltiu
xori
ori
andi
slli
srli
srai
add
sub
sll
slt
sltu
xor
srl
sra
or
and

and a custom instruction call "out"

# Assembly language structure
There are 32 internal registers, 32 words of instruction registers, 256 words of data memory
You can store and load data form data memory using lw, and sw commands
If you want to access internal register, you will need to write like 'x1, x2, etc'
you cannot change x0 register, it is hard wire to 0, even if you change it is still 'zero'.

###Language example
addi x1, x1, 10 # all registers are initialized to zeros, this command add 10 to register x1
sw x1, 0(x2)    # this store x1 value into data memory location 0
out x1          # this display the value of x1 from LEDs, if u connet them

# Instructions Definitions

### lui rd, immediate 
  x[rd] = sign_extended(immediate << 12)
### auipc rd, immediate 
  x[rd] = pc + sign_extended(immediate << 12)
### jal rd, label
  x[rd] = pc+4; pc += signed_extended(offset)
### jalr rd, rs1, offset
  x[rd] =pc+4; pc=(x[rs1]+sext(offset))
### beq rs1, rs2, label 
  if (rs1 == rs2) pc += sext(offset)
### bne rs1, rs2, label
  if (rs1 != rs2) pc+=sext(offset)
### blt rs1, rs2, label
  if (signed(rs1) < signed(rs2)) pc += sext(offset)
### bge rs1, rs2, label
  if (signed(rs1) > signed(rs2)) pc += sext(offset)
### bltu rs1, rs2, label
  if (unsigned(rs1) < unsigned(rs2)) pc += sext(offset)
### bgeu rs1, rs2, label
  if (unsigned(rs1) > unsigned(rs2)) pc += sext(offset)
### lw rd, offset(rs1) 
  x[rd] = sext(Memory[x[rs1] + sext(offset)])
### sw rs2, offset(rs1) 
  Memory[x[rs1] + sext(offset)] = x[rs2]
### addi rd, rs1, immediate
  x[rd] = x[rs1] + sext(immediate)
### slti rd, rs1, immediate
  x[rd] = 1 if (rs1 < immediate) else 0, for signed numbers
### sltiu rd, rs1, immediate
  x[rd] = 1 if (rs1 < immediate) else 0, for unsigned numbers
### xori rd, rs1, immediate
  x[rd] = rs1 xor immediate
### ori rd, rs1, immediate
  x[rd] = rs1 or immediate
### andi rd, rs1, immediate
  x[rd] = rs1 and immediate
### slli rd, rs1, immediate
  x[rd] = rs1 shifted left by immediate
### srli rd, rs1, immediate
  x[rd] = rs1 shifted right by immediate
### srai rd, rs1, immediate
  x[rd] = rd shifted right by immediate and sign extended
### add rd, rs1, rs2
  x[rd] = rs1 + rs2
### sub rd, rs1, rs2
  x[rd] = rs1 - rs2
### sll rd, rs1, rs2
  x[rd] = rs1 shift lefted by rs2
### slt rd, rs1, rs2
  x[rd] = 1 if (rs1 < rs2) else 0 for signed numbers
### sltu rd, rs1, rs2
  x[rd] = 1 if (rs1 < rs2) else 0 for unsigned numbers
### xor rd, rs1, rs2
  x[rd] = rs1 xor rs2
### srl rd, rs1, rs2
  x[rd] = rs1 shifted right by rs2
### sra rd, rs1, rs2
  x[rd] = rs1 shifted right by rs2, signed extended
### or rd, rs1, rs2
  x[rd] = rs1 or rs2
### and rd, rs1, rs2
  x[rd] = rs1 and rs2
### out rs
  output x[rs] to outside world, LEDs?
  
# Assembly language support
Comments are written with \#
However labels are to be written in line with the instruction to be executed
Example
here: addi x1, x2, 10
jal x2, here

This won't work:
here:
  addi x1, x2, 10
jal x2, here

you need to write it in txt file.

# Assembler
I wrote the assembler with python
Syntax: python assemble.py -f (assembly txt file) -o (output machine language txt file)

# Programmer
You can use any USB to UART converter like FTDI, CP210X.
You need to know the port that the converter connected.
Syntax: python program.py -p (port) -b (baudrate) -f (machine language txt file) -t (set this to 1)

Converter TX is connected to GPIO 0 of de10-Lite board.
Converter RX is connected to GPIO 1 of de10-Lite board.
Ground is connected to ground.

# Setup for programs
You need to install pyserial with the command "pip install pyserial"
