#!/usr/bin/env python3

import sys
from subprocess import Popen, DEVNULL, STDOUT

from template import TEMPLATE_ADD

BASH = "bash"
SCRIPTS_DIR = "scripts/"
TESTBENCH_PATH = 'testbench/adder/fa_tb.vhdl'

def parse_args():

    operation_str = sys.argv[1]

    if operation_str not in ['add', 'sub']:
        print("operation must be: `add` or `sub`")
        sys.exit(1)
    else:
        operation = 0 if operation_str == "add" else 1

    test_file_name = sys.argv[2]

    if len(sys.argv) < 4:
        offset = 0
    else:
        offset = int(sys.argv[3])

    _, mant_size_str, exp_size_str = test_file_name.split("_")

    mant_size = int(mant_size_str)
    exp_size = int(exp_size_str.split(".")[0])

    return exp_size, mant_size, test_file_name, offset, operation

def store_file(testbench):

    with open(TESTBENCH_PATH, 'w') as f:
        f.write(testbench)

def generate_testbench(args, exp_size, mant_size, operation):

    a, b, expected = args

    word_size = 1 + exp_size + mant_size

    testbench = TEMPLATE_ADD.format(word_size, exp_size, a, b, expected, operation)

    return testbench

def main():

    exp_size, mant_size, test_file_name, offset, operation = parse_args()

    # lectura del archivo
    with open(test_file_name) as f:
        lines = f.readlines()
    
    lines = list(map(lambda line: line.strip().split(' '), lines))

    for num, line in enumerate(lines[offset:]):
        # generar el archivo de testbench
        testbench = generate_testbench(line, exp_size, mant_size, operation)

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
            print("L: {} - a: {}, b: {}, expected: {} - ERROR".format(num + offset, line[0], line[1], line[2]))
            sys.exit(0)
        else:
            print("L: {} - a: {}, b: {}, expected: {} - OK".format(num + offset, line[0], line[1], line[2]))


if __name__ == '__main__':
    main()
