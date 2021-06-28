#!/usr/bin/python2.7
#
#    Build Latex tables of verilog module interface signals and registers
#

import sys
import os.path
import re
import string
import math

def swreg_parse(swreg_list, defines):
    program_out = []
    #generate software accessible register table
    if swreg_list:
        addr_w = int(math.ceil(math.log(len(swreg_list)*4)/math.log(2)/4))
        swreg_addr = 0
        for flds in swreg_list:
            flds_out = ['','','','','']
            flds_out[0] = re.sub('_','\_', flds[1]) #register name

            #register direction
            if '_RW' in flds[0]:
                flds_out[1] = 'R/W'
            elif 'W' in flds[1]:
                flds_out[1] = 'W'
            else:
                flds_out[1] = 'R'

            flds_out[2] = ("0x{:0" + str(addr_w) + "x}").format(swreg_addr) #register addr
            swreg_addr = swreg_addr+4
            for key, val in defines.items():
                if key in str(flds[2]):
                    flds[2] = eval(re.sub(str(key),str(val), flds[2]))
            flds_out[3] = str(int(flds[2])-1) + ":0" #register width

            flds_out[4] =  string.join(flds[3:]) #register description

            program_out.append(flds_out)
    return program_out

def parse (program, defines) :
    program_out = []
    swreg_list = []
    for line in program :
        flds_out = ['','','','']
        subline = re.sub('\[|\]|:|,|//|\;',' ', line)
        subline = re.sub('\(',' ',subline, 1)
        subline = re.sub('\)',' ', subline, 1)

        flds = subline.split()
        if not flds : continue #empty line
        #print flds[0]
        if (flds[0] == 'input') | (flds[0] == 'output') | (flds[0] == 'inout'): #IO
            #print flds
            flds_out[1] = flds[0] #signal direction

            flds_w = 1
            if (flds[1] == 'reg'):
                flds_w = flds_w+1
            if (flds[1] == 'signed'):
                flds_w = flds_w+1
            
            if not('[' in line):
                flds_out[0] = re.sub('_','\\_',flds[flds_w]) #signal name
                flds_out[2] = '1' #signal width
                flds_out[3] = string.join(flds[flds_w+1:]) #signal description
            else:
                flds_out[0] = re.sub('_','\_',flds[flds_w+2]) #signal name
                for key, val in defines.items():
                    if key in str(flds[flds_w]):
                        flds[flds_w] = eval(re.sub(str(key),str(val), flds[flds_w]))
                    if key in str(flds[flds_w+1]):
                        flds[flds_w+1] = eval(re.sub(str(key),str(val), flds[flds_w+1]))
                    pass
                flds_out[2] = str(int(flds[flds_w]) - int(flds[flds_w+1]) + 1)  #signal width
                flds_out[3] = string.join(flds[flds_w+3:]) #signal description

            program_out.append(flds_out)
        elif ('SWREG_' in flds[0]): #software accessible registers
            swreg_list.append(flds)
        else: continue #not a recognized macro/IO

    swreg_out = swreg_parse(swreg_list,defines)
    if swreg_out:
        for line in swreg_out:
            program_out.append(line)
    return program_out

def header_parse (f):
    defines = {}
    for line in f:
        #ignore leading spaces
        line = line.lstrip() 
        
        #replace $clog2 by clog2
        line = line.replace("$", "")
        
        #remove tabs
        line = line.replace("\t", "")
        
        #split line elements in array
        line = re.sub(' +', ' ', line)
        values = line.split("\n")
        values = values[0].split(" ")
        
        #parser
        lookup = {}
        if "`define" == values[0]:
            if(len(values) > 2):
                if values[2].isdigit() == False:
                    if "'d" in line:
                        const = line.split("'d")
                        const = const[1].split(" ")
                        const[0] = re.search(r'\d+', const[0]).group()
                        lookup["`" + values[1]] = int(const[0],10)
                    elif "'h" in line:
                        const = line.split("'h")
                        const = const[1].split(" ")
                        lookup["`" + values[1]] = int(const[0],16)
                    elif "'b" in line:
                        const = line.split("'b")
                        const = const[1].split(" ")
                        lookup["`" + values[1]] = int(const[0],2)
                    elif "(" in line:
                        line = re.sub('`', '', line)
                        if "'b" in line:
                            line = re.sub('1\'b', '', line)
                        if '**' in line:
                            line = re.sub('2\*\*', '(1<<', line)
                            line = re.sub(re.escape(' +'), ') +', line)
                            line = re.sub(re.escape('-1)'), ')-1', line)
                            line = re.sub(re.escape('-2)'), ')-2', line)
                        const = line.split("(", 1)
                        const = const[1].split("//")
                        const = const[0].split('\n')
                        const = "(" + const[0] 
                        lookup["`" + values[1]] = const
                    elif "{" in line:
                        continue
                    else:
                        const = values[2].split("`")
                        const = const[1].split("\n")
                        lookup["`" + values[1]] = lookup[const[0]]
                else:
                    lookup["`" + values[1]] = int(values[2])
            else:
                lookup[values[0] + " " + values[1]] = ""
        else:
            continue

        #Write to dictionary
        for key, val in lookup.items():
            if val:
                defines.update({key:int(val)})
    return defines

def main () :
    #parse command line
    if len(sys.argv) != 3 and len(sys.argv) != 4:
        print("Usage: ./v2tex.py infile outfile [header_file]")
        exit()
    else:
        infile = sys.argv[1]
        outfile = sys.argv[2]
        if len(sys.argv) == 4:
            vhfile = sys.argv[3]
        pass

    defines = {}
    if 'vhfile' in locals():
        #Create header dictionary
        fvh = open(vhfile, 'r')
        defines = header_parse(fvh)
        fvh.close()
        
    #parse input file
    fin = open (infile, 'r')
    program = fin.readlines()
    program = parse (program, defines)

    #print program
    #for line in range(len(program)):
     #   print program[line]

    #write output file
    fout = open (outfile, 'w')
    for i in range(len(program)):
        if ((i%2) != 0): fout.write("\\rowcolor{iob-blue}\n")
        line = program[i]
        line_out = str(line[0])
        for l in range(1,len(line)):
            line_out = line_out + (' & %s' % line[l])
        fout.write(line_out + ' \\\ \hline\n')

    #Close files
    fin.close()
    fout.close()

if __name__ == "__main__" : main ()
