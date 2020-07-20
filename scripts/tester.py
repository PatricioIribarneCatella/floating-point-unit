#!/usr/bin/env python3

import sys

from adder import run_adder
from multiplier import run_multiplier

def parse_args():

    operation = sys.argv[1]

    if operation not in ['add', 'sub', 'mul']:
        print("OPERATION must be: `add`, `sub` or `mul`")
        sys.exit(1)

    test_file_name = sys.argv[2]

    if len(sys.argv) < 4:
        offset = 0
    else:
        offset = int(sys.argv[3])

    _, mant_size_str, exp_size_str = test_file_name.split("_")

    mant_size = int(mant_size_str)
    exp_size = int(exp_size_str.split(".")[0])

    return exp_size, mant_size, operation, test_file_name, offset

def main():

    exp_size, mant_size, operation, test_file_name, offset = parse_args()

    if operation in ['add', 'sub']:
        run_adder(exp_size, mant_size, operation, test_file_name, offset)
    else:
        run_multiplier(exp_size, mant_size, test_file_name)

if __name__ == '__main__':

    if len(sys.argv) < 3:
        print("""
        Usage: ./tester.py OPERATION TEST_FILE [LINE]
        \tOPERATION: it could be `add`, `sub` or `mul`
        \tTEST_FILE: the file containing the inputs and expected outputs
        \tLINE: the line in test file to begin the simulation (available for add/sub, not mul)
        \t\tdefault: 0
        """)
        sys.exit(1)

    main()
