import subprocess
import sys
import os

year = sys.argv[1]
day = sys.argv[2]
part = sys.argv[3]

asm_path = f"{year}/day{day}/d{day}p{part}.asm"
out_path = f"build/{year}-{day}p{part}.83p"

os.makedirs("build", exist_ok=True)

subprocess.call(["brass", asm_path, out_path])
