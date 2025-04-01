#!/bin/bash

echo "Starting the task..."
# Add your commands here, for example:

python3 BigEndianConversion.py
iverilog -o output_RISCV tb.v
vvp output_RISCV
surfer tb.vcd

echo "Done!"