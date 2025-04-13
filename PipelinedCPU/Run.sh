#!/bin/bash

echo "Starting the task..."

python3 BigEndianConversion.py
iverilog -o output tb_riscv_sc.v

vvp output
surfer tb.vcd

echo "Done!"