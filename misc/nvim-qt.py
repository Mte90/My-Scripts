#!/usr/bin/env python
import os
import sys
from pynvim import attach

if len(sys.argv) < 2:
    os.system('/usr/local/bin/nvim-qt')
    exit(1)

instances = [path for path in os.listdir("/tmp") if path.startswith("nvim")]
if len(instances) > 1:
    print("Multiple neovim instances running, can't decide which one should be used")
    exit(1)
elif len(instances) == 0:
    sys.argv.pop(0)
    os.system('/usr/local/bin/nvim-qt ' + os.path.abspath(" ".join(sys.argv)))
else:
    nvim = attach("socket", path=os.path.join("/tmp", instances[0], "0"))
    nvim.command("tabnew " + os.path.abspath(sys.argv[1]))
