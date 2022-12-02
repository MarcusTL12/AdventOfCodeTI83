import subprocess
import sys
import os

os.makedirs("build", exist_ok=True)

if sys.argv[1] == "test":
    testname = "test"
    if len(sys.argv) == 3:
        testname = sys.argv[2]

    asm_path = f"test/{testname}.asm"
    out_path = f"build/{testname}.83p"
else:
    year = sys.argv[1]
    day = sys.argv[2]
    part = sys.argv[3]

    asm_path = f"{year}/day{day}/d{day}p{part}.asm"
    out_path = f"build/{year}-{day}p{part}.83p"

subprocess.call(["brass", asm_path, out_path])
