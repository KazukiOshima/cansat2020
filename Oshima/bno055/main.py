import logging
import sys
import time

import BNO055
import bno055

Bno = bno055.Bno055()

Bno.setupBno()

while True:
    Bno.readlinearaccel()
    print('Ax=',Bno.Ax,',Ay=',Bno.Ay,',Az=',Bno.Az)
    Bno.readgravity()
    print('gx=',Bno.gx,',gy=',Bno.gy,',gz=',Bno.gz)
    time.sleep(1)
