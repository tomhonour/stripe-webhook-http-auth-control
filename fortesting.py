#! /usr/bin/env python3.6

import subprocess
import os

email = "tom5@posteo.net" # get e-mail from json
cusemail = open(r'/tmp/cuse-mail', 'w')
cusemail.write(email)
cusemail.close()
subprocess.call('./fortesting.sh')
os.remove("/tmp/cuse-mail")
