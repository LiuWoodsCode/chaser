#!/usr/bin/env python3

import re
import subprocess

completedProc: subprocess.CompletedProcess[bytes] = subprocess.run("xcrun simctl list devices", shell=True, capture_output=True)
# completedProc.returncode             # int
# completedProc.stdout                 # output is bytes b''
# completedProc.stdout.decode("utf-8") # decode text
# completedProc.stderr                 # output is bytes b''
pattern = r"[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}"

# print(completedProc.stdout.decode("utf8"))
for line in completedProc.stdout.decode("utf8").splitlines():
    match: re.Match[str] | None = re.search(pattern, line)
    if match:
        iden: str = match.group(0)
        print("xcrun simctl delete", iden)
    else:
        print(line)
