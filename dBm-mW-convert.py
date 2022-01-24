 ################################################################################
#
#Run example: Not intended for direct usage
#File:      dBm-mW-convert.py
#Date:      2022JAN21
#Author:    William Blair
#Contact:	williamblair333@gmail.com
#Tested on: Windows 10
#To test:   Debian 10+ | Ubuntu 14+
#
################################################################################
import os
import paramiko
import math
from robot.api.deco import keyword

#value_mW = 345

@keyword('dBm to mW Convert')
def dBm_to_mW_Convert(value_mW):
    value_mW = float(value_mW) * .001
    dBm = ((math.log10(value_mW))*10)
    return dBm

#dBm_to_mW_Convert(value_mW)