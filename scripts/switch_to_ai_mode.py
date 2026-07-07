#!/usr/bin/env python3
"""
切换 G1 机器人为外部 AI 控制模式
运行一次即可，切换后 wbc_fsm 独占电机
"""
import sys
import time
from unitree_sdk2py.core.channel import ChannelFactoryInitialize
from unitree_sdk2py.comm.motion_switcher.motion_switcher_client import MotionSwitcherClient

NETWORK = sys.argv[1] if len(sys.argv) > 1 else "eth0"

ChannelFactoryInitialize(0, NETWORK)

msc = MotionSwitcherClient()
msc.SetTimeout(5.0)
msc.Init()

name = "ai"
print(f"Switching G1 motion mode to: {name}")
ret = msc.SelectMode(name)
print(f"Result: {ret}")
if ret == 0:
    print("SUCCESS: G1 is now in external AI control mode.")
else:
    print(f"WARNING: SelectMode returned {ret}, wbc_fsm may conflict with onboard controller.")
    sys.exit(1)
