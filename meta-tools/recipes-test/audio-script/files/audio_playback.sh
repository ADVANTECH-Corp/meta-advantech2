#!/bin/sh

amixer -c 0 cset iface=MIXER,name='RX1 MIX1 INP1' 'RX1'
amixer -c 0 cset iface=MIXER,name='RX2 MIX1 INP1' 'RX2'
amixer -c 0 cset iface=MIXER,name='RDAC2 MUX' 'RX2'
amixer -c 0 cset iface=MIXER,name='HPHL' 1
amixer -c 0 cset iface=MIXER,name='HPHR' 1
amixer -c 0 cset iface=MIXER,name='RX1 Digital Volume' 127
amixer -c 0 cset iface=MIXER,name='RX2 Digital Volume' 127
#aplay -D plughw:0,1 Advantech.wav
