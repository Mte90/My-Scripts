#!/usr/bin/env python
import os
import sys
from pynvim import attach


if len(sys.argv) == 1:
    os.system('/usr/local/bin/nvim-qt')
    exit(1)

os.environ["NVIM_LISTEN_ADDRESS"] = '/tmp/nvim-socket'

if not os.path.exists(os.environ.get("NVIM_LISTEN_ADDRESS", '')):
    if os.path.isdir(os.path.abspath(os.getcwd()) + '/.venv/bin/'):
        print("Venv found")
        activate_this_file = os.path.abspath(os.getcwd()) + "/.venv/bin/activate_this.py"
        exec(compile(open(activate_this_file, "rb").read(), activate_this_file, 'exec'), dict(__file__=activate_this_file))
        print("Venv executed")
    sys.argv.pop(0)
    os.system('/usr/local/bin/nvim-qt ' + os.path.abspath(" ".join(sys.argv)))
else:
    try:
        nvim = attach("socket", path=os.environ.get("NVIM_LISTEN_ADDRESS", None))
    except:
        os.unlink(os.environ["NVIM_LISTEN_ADDRESS"])
        print("Retry!")
        sys.exit()
    nvim.command("tabnew " + os.path.abspath(sys.argv[1]))
