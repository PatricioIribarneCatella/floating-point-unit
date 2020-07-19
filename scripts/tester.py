#!/usr/bin/env python3

import sys
from subprocess import Popen, DEVNULL, STDOUT

from template import TEMPLATE_ADD

BASH = "bash"
SCRIPTS_DIR = "scripts/"
TESTBENCH_PATH = 'testbench/adder/fa_tb.vhdl'

def parse_args():

    test_file_name = sys.argv[1]

    _, mant_size_str, exp_size_str = test_file_name.split("_")

    mant_size = int(mant_size_str)
    exp_size = int(exp_size_str.split(".")[0])

    return exp_size, mant_size, test_file_name

def store_file(testbench):

    with open(TESTBENCH_PATH, 'w') as f:
        f.write(testbench)

def generate_testbench(args, exp_size, mant_size):

    a, b, expected = args

    word_size = 1 + exp_size + mant_size

    testbench = TEMPLATE_ADD.format(word_size, exp_size, a, b, expected)

    return testbench

def main():

    exp_size, mant_size, test_file_name = parse_args()

    # lectura del archivo
    with open(test_file_name) as f:
        lines = f.readlines()
    
    lines = list(map(lambda line: line.strip().split(' '), lines))

    for line in lines:
        # generar el archivo de testbench
        testbench = generate_testbench(line, exp_size, mant_size)

        # guardar el archivo
        store_file(testbench)

        # compilar el testbench
        p = Popen([BASH,
                   SCRIPTS_DIR + "compile-fa"])
        p.wait()

        # correr la simulacion con subprocess
        p = Popen([BASH,
                   SCRIPTS_DIR + "simul-fa"], stderr=STDOUT, stdout=DEVNULL)
        p.wait()
        
        if p.returncode > 0:
            print("a: {}, b: {}, expected: {} - ERROR".format(line[0], line[1], line[2]))
            sys.exit(0)
        else:
            print("a: {}, b: {}, expected: {} - OK".format(line[0], line[1], line[2]))


if __name__ == '__main__':
    main()
