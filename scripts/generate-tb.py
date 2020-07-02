#!/usr/bin/env python3

import sys

from template import PROLOGUE, EPILOGUE

TESTBENCH_PATH = 'testbench/float_multiplier_tb.vhdl'

def parse_args():

    test_file_name = sys.argv[1]

    _, mant_size_str, exp_size_str = test_file_name.split("_")

    mant_size = int(mant_size_str)
    exp_size = int(exp_size_str.split(".")[0])

    return exp_size, mant_size, test_file_name

def store_file(testbench):

    with open(TESTBENCH_PATH, 'w') as f:
        f.write(testbench)

def generate_testbench(exp_size, mant_size, file_path):

    word_size = 1 + exp_size + mant_size

    testbench = PROLOGUE + EPILOGUE.format(word_size, exp_size, file_path)

    return testbench

def main():

    exp_size, mant_size, file_path = parse_args()

    testbench = generate_testbench(exp_size, mant_size, file_path)

    store_file(testbench)

if __name__ == '__main__':
    main()
