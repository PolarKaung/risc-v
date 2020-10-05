import serial
import argparse
import time
from bitarray import bitarray

parser = argparse.ArgumentParser()
parser.add_argument("--port", "-p", help="Port programmer is connected", required=True)
parser.add_argument("--baud", "-b", help="BaudRate of the programmer", required=True)
parser.add_argument("--file", "-f", help="machine code in txt or bin file", required=True)
parser.add_argument("--fileType","-t",help="1:txt, 2:bin", default=1, required = False) 
args = parser.parse_args()
ser = serial.Serial(args.port, args.baud)
##ser = serial.Serial('COM7', 9600)
if int(args.fileType) == 1:
    f = open(args.file,"r")
elif int(args.fileType) == 2:
    f = open(args.file, 'rb')
time.sleep(1)
if int(args.fileType) == 1:
    instructions = f.readlines()
    for inst in instructions:
        index = 0
        while index < 4:
            dataByte = inst[-9-(index*8):-1-(index*8)]
            a = bitarray(dataByte).tobytes()
            print(a)
            ser.write(a)
            index += 1
            time.sleep(0.05)
        index = 0
elif int(args.fileType) == 2:
    instructions = f.readlines()
    f.seek(0)
    index = 0
    while index < len(instructions[0]):
        a = hex(instructions[0][index])
        print(a)
        ser.write(f.read(1))
        index += 1
        time.sleep(0.2)
    index = 0
ser.close()
