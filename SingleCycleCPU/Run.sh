#!/bin/bash

echo "Starting the task..."
# Add your commands here, for example:

python3 BigEndianConversion.py
iverilog -o output tb_riscv_sc.v
vvp output
surfer tb.vcd

echo "Done!"