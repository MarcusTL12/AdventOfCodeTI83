import sys

year = sys.argv[1]
day = sys.argv[2]

inputfile = f"{year}/day{day}/input.txt"
outputfile = f"{year}/day{day}/input.asm"

with open(inputfile) as f:
    input_str = f.read()

output_str = f"""
input:
    .db "{input_str}",0
"""

with open(outputfile, "w") as f:
    f.write(output_str)
