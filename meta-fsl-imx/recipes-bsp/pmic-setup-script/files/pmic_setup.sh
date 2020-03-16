#!/bin/sh
#Due to GPU issue, we set gpu volt from 0.9v to 1.0v 
i2cset -f -y 0 0x08 0x20 0x1c
