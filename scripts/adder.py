import sys
from subprocess import Popen, DEVNULL, STDOUT

from template import TEMPLATE_ADD

BASH = "bash"
SCRIPTS_DIR = "scripts/adder/"
TESTBENCH_PATH = 'testbench/adder/fa_tb.vhdl'

def store_file(testbench):

    with open(TESTBENCH_PATH, 'w') as f:
        f.write(testbench)

def generate_testbench(args, exp_size, mant_size, operation):

    a, b, expected = args

    word_size = 1 + exp_size + mant_size

    testbench = TEMPLATE_ADD.format(word_size, exp_size, a, b, expected, operation)

    return testbench

def run_adder(exp_size, mant_size, operation_name, test_file_name, offset):

    op_code = {'add': 0, 'sub': 1}

    operation = op_code[operation_name]

    # read from test file
    with open(test_file_name) as f:
        lines = f.readlines()
    
    lines = list(map(lambda line: line.strip().split(' '), lines))

    for num, line in enumerate(lines[offset:]):

        testbench = generate_testbench(line, exp_size, mant_size, operation)

        store_file(testbench)

        p = Popen([BASH,
                   SCRIPTS_DIR + "compile"])
        p.wait()

        p = Popen([BASH,
                   SCRIPTS_DIR + "simul"], stderr=STDOUT, stdout=DEVNULL)
        p.wait()
        
        if p.returncode > 0:
            print("L: {} - a: {}, b: {}, expected: {} - ERROR".format(num + offset, line[0], line[1], line[2]))
            sys.exit(0)
        else:
            print("L: {} - a: {}, b: {}, expected: {} - OK".format(num + offset, line[0], line[1], line[2]))

    print("Fin de la simulación")
