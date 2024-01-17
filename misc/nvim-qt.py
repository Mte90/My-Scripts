#!/usr/bin/env python
import os
import sys
from pynvim import attach

if len(sys.argv) < 2:
    os.system('/usr/local/bin/nvim-qt')
    exit(1)

os.environ["NVIM_LISTEN_ADDRESS"] = '/tmp/nvim-socket'

if not os.path.exists(os.environ.get("NVIM_LISTEN_ADDRESS", '')):
    sys.argv.pop(0)
    os.system('/usr/local/bin/nvim-qt ' + os.path.abspath(" ".join(sys.argv)))
else:
    nvim = attach("socket", path=os.environ.get("NVIM_LISTEN_ADDRESS", None))
    nvim.command("tabnew " + os.path.abspath(sys.argv[1]))
