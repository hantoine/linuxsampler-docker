#!/bin/bash

set -m

# Start JackD
/usr/bin/jackd -R -d net -a $DOCKERHOST -n linuxsampler -i 1 -l 1 &

# Start LinuxSampelr
linuxsampler &

# Initialize Linux Sampler channels
sleep 1
cat initial_channels.lsp  | nc localhost 8888 &

# Connect LinuxSampler to local JACK
sleep 1
jack_connect LinuxSampler:0 system:playback_1
jack_connect LinuxSampler:1 system:playback_2
jack_connect system:midi_capture_1 LinuxSampler:midi_in_0

wait
