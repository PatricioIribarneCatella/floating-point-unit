import sys
from subprocess import Popen, DEVNULL, STDOUT

from template import TEMPLATE_MUL

BASH = "bash"
SCRIPTS_DIR = "scripts/multiplier/"
TESTBENCH_PATH = 'testbench/multiplier/fm_tb.vhdl'

def store_file(testbench):

    with open(TESTBENCH_PATH, 'w') as f:
        f.write(testbench)

def generate_testbench(exp_size, mant_size, file_path):

    word_size = 1 + exp_size + mant_size

    testbench = TEMPLATE_MUL.format(word_size, exp_size, file_path)

    return testbench

def run_multiplier(exp_size, mant_size, test_file_name):

    testbench = generate_testbench(exp_size, mant_size, test_file_name)

    store_file(testbench)

    p = Popen([BASH,
               SCRIPTS_DIR + "compile"])
    p.wait()

    p = Popen([BASH,
               SCRIPTS_DIR + "simul"])
    p.wait()
