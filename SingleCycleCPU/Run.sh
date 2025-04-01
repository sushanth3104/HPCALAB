#!/bin/bash

echo "Starting the task..."
# Add your commands here, for example:

python3 BigEndianConversion.py
iverilog -o output tb.v
vvp output
surfer tb.vcd

echo "Done!"