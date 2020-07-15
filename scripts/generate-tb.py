#!/usr/bin/env python3

import sys

from template import PROLOGUE, EPILOGUE_MUL, EPILOGUE_ADD

TESTBENCH_PATH = 'testbench/{}/main_tb.vhdl'

def parse_args():

    component = sys.argv[1]
    
    if component not in ["adder", "multiplier"]:
        print("COMPONENT must be one of: `adder` or `multiplier`")
        sys.exit(1)

    test_file_name = sys.argv[2]

    _, mant_size_str, exp_size_str = test_file_name.split("_")

    mant_size = int(mant_size_str)
    exp_size = int(exp_size_str.split(".")[0])

    return exp_size, mant_size, component, test_file_name

def store_file(component, testbench):

    with open(TESTBENCH_PATH.format(component), 'w') as f:
        f.write(testbench)

def generate_testbench(exp_size, mant_size, component, file_path):

    word_size = 1 + exp_size + mant_size

    if component == "adder":
        epil = EPILOGUE_ADD
    else:
        epil = EPILOGUE_MUL

    testbench = PROLOGUE + epil.format(word_size, exp_size, file_path)

    return testbench

def main():

    exp_size, mant_size, component, file_path = parse_args()

    testbench = generate_testbench(exp_size, mant_size, component, file_path)

    store_file(component, testbench)

if __name__ == '__main__':

    if len(sys.argv) < 3:
        print("""
        Usage: ./generate-tb.py COMPONENT TEST_FILE
        \tCOMPONENT: it could be `adder` or `multiplier`
        \tTEST_FILE: the file containing the inputs and expected outputs
        """)
        sys.exit(1)

    main()
