import sys

year = sys.argv[1]
day = sys.argv[2]

inputfile = f"{year}/day{day}/input.txt"
outputfile = f"{year}/day{day}/input.asm"

with open(inputfile) as f:
    input_str = f.read()

s = input_str.splitlines()
s = ",10,".join(f'"{s}"' for s in s)

output_str = f"""
input:
    .db {s},0
"""

with open(outputfile, "w") as f:
    f.write(output_str)
