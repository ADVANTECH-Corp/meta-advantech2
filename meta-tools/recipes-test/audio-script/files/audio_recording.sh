#!/bin/sh

amixer -c 0 cset iface=MIXER,name='DEC1 MUX' 'ADC2'
amixer -c 0 cset iface=MIXER,name='ADC2 Volume' 70
amixer -c 0 cset iface=MIXER,name='ADC2 MUX' 'INP2'
#arecord -D plughw:0,2 -r 16000 -f S16_LE ./f-16000.wav
