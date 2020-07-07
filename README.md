# Docker image for LinuxSampler

## Usage
  1. Clone this repos
  2. Execute `docker build -t linuxsampler linuxsampler` inside the repos to build the Docker image
  3. Start JACK with `jack_control start` and execute `jack_load netmanager` to load the networking module.
  4. Launch LinuxSampler in a Docker container:
    
```bash
    docker run -d \
        --rm \
        -p 8888:8888 \
        --privileged \
        --ulimit rtprio=95 \
        --ulimit memlock=-1 \
        --shm-size=256m \
        --group-add audio \
        --env DOCKERHOST=$(ip -4 addr show docker0 | grep -Po 'inet \K[\d.]+') \
        --mount "type=bind,src=/usr/share/sounds/sf2,dst=/usr/share/sounds/sf2,readonly" \
        --name linuxsampler \
        linuxsampler
```
  5. Two new audio output port and a new midi input port will appear in JACK, connect them accordingly. 
  6. You can control LinuxSampler using a GUI like QSampler (available in Ubuntu repos).
  
  To extract the DEB files from the Docker image, use:  
  ```
  docker run -d --name linuxsampler linuxsampler \
    && docker cp linuxsampler:/workdir linuxsampler \
    && docker rm -f linuxsampler
  ```
  
  
