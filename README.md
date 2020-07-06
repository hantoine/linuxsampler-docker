# Docker image for Linux Sampler

## Usage
  1. Clone this repos
  2. Execute `docker build -t linuxsampler linuxsampler` inside the repos to build the Docker image
  3. Launch with:
    
```bash
    docker run -ti \
        --rm \
        -p 8888:8888 \
        --privileged \
        --ulimit rtprio=95 \
        --ulimit memlock=-1 \
        --shm-size=256m \
        --group-add audio \
        --env DOCKERHOST=$(ip -4 addr show docker0 | grep -Po 'inet \K[\d.]+') \
        --mount "type=bind,src=/usr/share/sounds,dst=/usr/share/sounds,readonly" \
        --name linuxsampler \
        linuxsampler
```
  4. Control using a GUI such as QSampler (available in Ubuntu repos)
  
  To extract the DEB files from the Docker image, use:  
  ```
  docker run -d --name linuxsampler linuxsampler \
    && docker cp linuxsampler:/workdir linuxsampler \
    && docker rm -f linuxsampler
  ```
  
  
