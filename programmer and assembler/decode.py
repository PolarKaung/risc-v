def idOps(opsList,opcodes):
    OpsId = []
    for i in opcodes:
        OpsId.append(opsList[i])
    return OpsId

def decode(opsList, inst, labels):
    inst_count = 0
    opcodes = []
    codes = []
    for i in inst:
        opcodes.append(i.split(' ', 1)[0])
    opType = idOps(opsList, opcodes)
    
    for i, Type in enumerate(opType):
        opEnd = inst[i].find(' ')
        code = ""
        if ( Type == 0):
            registers= []
            opcode = "0110011"
            func3 = '000'; func7 = '0000000'
            
            registers = ['{0:05b}'.format(int(j.strip()[1:])) for j in inst[i][opEnd+1:].split(',')]
            if ( opcodes[i] == "add"):
                func3 = '000'
                func7 = '0000000'
            elif (opcodes[i] == "sub"):
                func3 = '000'
                func7 = '0100000'
            elif (opcodes[i] == "mul"):
                func3 = '000'
                func7 = '0000001'
            elif (opcodes[i] == "mulh"):
                func3 = '001'
                func7 = '0000001'
            elif (opcodes[i] == "sll"):
                func3 = '001'
            elif (opcodes[i] == "mulhsu"):
                func3 = '010'
                func7 = '0000001'
            elif (opcodes[i] == "slt"):
                func3 = '010'
            elif (opcodes[i] == "mulhu"):
                func3 = '011'
                func7 = '0000001'
            elif (opcodes[i] == "sltu"):
                func3 = '011'
            elif (opcodes[i] == "div"):
                func3 = '100'
                func7 = '0000001'
            elif (opcodes[i] == "xor"):
                func3 = '100'
            elif (opcodes[i] == "srl"):
                func3 = '101'
            elif (opcodes[i] == "sra"):
                func3 = '101'
                func7 = '0100000'
            elif (opcodes[i] == "divu"):
                func3 = '101'
                func7 = '0000001'
            elif (opcodes[i] == "rem"):
                func3 = '110'
                func7 = '0000001'
            elif (opcodes[i] == "or"):
                func3 = '110'
            elif (opcodes[i] == "remu"):
                func3 = '111'
                func7 = '0000001'
            elif (opcodes[i] == "and"):
                func3 = '111'
            code = func7+registers[2]+registers[1]+func3+registers[0]+opcode
            codes.append(code)
            inst_count += 4
        elif ( Type == 1 ):
            if ( opcodes[i] == 'jalr'):
                opcode = '1100111'
            elif (opcodes[i] == 'lw'):
                opcode = '0000011'
            else:
                opcode = '0010011'
            argument =[j.strip() for j in inst[i][opEnd+1:].split(',')]
            rd = '{0:05b}'.format(int(argument[0][1:]))
            if ( opcodes[i] == 'lw'):
                argument2 = argument[1].split('(',1)
                immediate = int(argument2[0])
                rs1 = '{0:05b}'.format(int(argument2[1][1:-1]))
            else:
                rs1 = '{0:05b}'.format(int(argument[1][1:]))
                immediate = int(argument[2])
            if (immediate < 0):
                immediate1 = bin(immediate % (1<<12))[2:]
                immediateShift = bin(immediate % (1<<5))[2:]
            else:
                immediate1 = '{0:012b}'.format(immediate)
                immediateShift = '{0:05b}'.format(immediate)
            func3 = '000'
            func7 = '0000000'
            if (opcodes[i] == "addi"):
                func3 = '000'
            elif (opcodes[i] == "slli"):
                func3 = '001'
            elif (opcodes[i] == "slti"):
                func3 = '010'
            elif (opcodes[i] == "xori"):
                func3 = '100'
            elif (opcodes[i] == "sltiu"):
                func3 = '011'
            elif (opcodes[i] == "srli"):
                func3 = '101'
            elif (opcodes[i] == "srai"):
                func3 = '101'
                func7 = '0100000'
            elif (opcodes[i] == "ori"):
                func3 = '110'
            elif (opcodes[i] == "andi"):
                func3 = '111'
            elif (opcodes[i] == 'jalr'):
                func3 = '000'
            elif (opcodes[i] == 'lw'):
                func3 = '010'
            if ( opcodes[i]=="slli" or opcodes[i]=="srli" or opcode[i]=="srai"):
                code = func7+immediateShift+rs1+func3+rd+opcode
            else:
                code = immediate1+rs1+func3+rd+opcode
            codes.append(code)
            inst_count += 4
        elif ( Type == 2 ):
            pointer = 0
            opcode = '1100011'
            func3 = '000'
            argument = [j.strip() for j in inst[i][opEnd+1:].split(',')]
            pointer = labels[argument[2]] - inst_count
            if (pointer < 0):
                pointer = bin(pointer % (1 <<13))[2:]
            else:
                pointer = '{0:013b}'.format(pointer)
            immediate1 = pointer[8:12]+pointer[1]
            immediate2 = pointer[0]+pointer[2:8]
            rs1 = '{0:05b}'.format(int(argument[0][1:]))
            rs2 = '{0:05b}'.format(int(argument[1][1:]))
            if (opcodes[i] == 'beq'):
                func3 = '000'
            elif (fields[0] == "bne"):
                func3 = '001'
            elif (fields[0] == "blt"):
                func3 = '100'
            elif (fields[0] == "bge"):
                func3 = '101'
            elif (fields[0] == "bltu"):
                func3 = '110'
            elif (fields[0] == "bgeu"):
                func3 = '111'
            code = immediate2+rs2+rs1+func3+immediate1+opcode
            codes.append(code)
            inst_count += 4
        elif ( Type == 3):
            opcode = '0100011'
            func3 = '000'
            argument = [j.strip() for j in inst[i][opEnd+1:].split(',')]
            rs2 = '{0:05b}'.format(int(argument[0][1:]))
            argument2 = argument[1].split('(',1)
            offset = int(argument2[0])
            if (offset < 0):
                offset = bin(offset % (1<<12))[2:]
            else:
                offset = "{0:012b}".format(offset)
            rs1 = "{0:05b}".format(int(argument2[1][1:-1]))
            if (opcodes[i] == 'sw'):
                func3 = '010'
            code = offset[0:7]+rs2+rs1+func3+offset[7:12]+opcode
            codes.append(code)
            inst_count += 4
        elif ( Type == 4):
            opcode = '1101111'
            argument = [j.strip() for j in inst[i][opEnd+1:].split(',')]
            rd = '{0:05b}'.format(int(argument[0][1:]))
            offset = labels[argument[1]] - inst_count
            if ( offset < 0):
                offset = bin(offset %(1<<21))[2:]
            else:
                offset = '{0:021b}'.format(offset)
            code = offset[0]+offset[10:20]+offset[9]+offset[1:9]+rd+opcode
            codes.append(code)
            inst_count += 4
        elif (Type == 5):
            if (opcodes[i] == 'auipc'):
                opcode = '0010111'
            elif (opcodes[i]=='lui'):
                opcode = '0110111'
            argument = [j.strip() for j in inst[i][opEnd+1:].split(',')]
            rd = '{0:05b}'.format(int(argument[0][1:]))
            offset = int(argument[1])
            if (offset < 0):
                offset = bin(offset % (1 << 20))[2:]
            else:
                offset = '{0:020b}'.format(offset)
            code = offset+rd+opcode
            codes.append(code)
            inst_count += 4
        elif (Type == 10):
            if (opcodes[i] == 'out'):
                opcode = '1011010'
                func7 = '0000000'; func3 = '000'; rd = '00000'; rs2 = '00000'
                argument = [j.strip() for j in inst[i][opEnd+1:].split(',')]
                #rs1 = '{0:05b}'.format(int(argument[0][1:]))
                code = func7 + rs2+rs1+func3+rd+opcode
            codes.append(inst[i])
            inst_count += 4
            
    return codes
