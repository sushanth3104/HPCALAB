import re

def convert_to_big_endian(input_file, output_file):
    with open(input_file, 'r') as infile, open(output_file, 'w') as outfile:
        for line in infile:
            match = re.search(r'([01]{32})$', line.strip())  # Extract 32-bit binary
            if not match:
                continue  # Skip lines without binary data
            
            binary_str = match.group(1)
            
            # Split into 8-bit chunks (no reversing for big-endian)
            big_endian_bytes = [binary_str[i:i+8] for i in range(0, 32, 8)]
            
            # Write each 8-bit chunk in a new line
            for byte in big_endian_bytes:
                outfile.write(byte + '\n')

def main():
    print("\nRunnning --> Script for conversion for 32-Bit Instructions to Big Endian Format\n")
    input_file = 'TestInstructions32Bit.dat'  # Change as needed
    output_file = 'TestInstructions.dat'  # Change as needed
    convert_to_big_endian(input_file, output_file)
    print(f"\nConversion complete. Output written to  --> {output_file}\n")

if __name__ == "__main__":
    main()
