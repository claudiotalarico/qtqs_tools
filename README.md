# QTQS-TOOLS
**qtqs-tools** is a docker container for running Quartus Lite (version 25.1) and Quartus FSE.  

The docker image is built on Ubuntu 24.04 LTS, and the CPU architecture supported is `x86_64/amd64`.

As of 2026, Intel/Altera does not natively support Quartus for ARM64 (aarch64) architecture.
There are currently no official roadmaps to release a native ARM64 version for machines like modern Mac (Apple Silicon), Windows on ARM laptops, or Linux ARM devices.

## How to use the tools

**Step 1: Clone/download this GitHub repository onto your computer**
```
cd ~
git clone --depth=1 https://github.com/claudiotalarico/qtqs_tools.git
```

**Step 2: Install and start Docker on your computer**
- [Docker Documentation](https://docs.docker.com/)
- [Get Docker](https://docs.docker.com/get-started/get-docker/)

**Step 3: Start and Use a Docker Container based on our qtqs_tools image**

- Before starting the Docker Container, note that Questa FSE requires a license. 

  Browse to the [Altera's Self-Service Licensing Center](https://www.altera.com/SSLC) and generate the license for Questa starter Edition for your Host NIC ID.
   
  Change the name of the license file into `questa.lic` and put it at `~/licenses/questa.lic`.<br>

- Start the docker using the following script:
  ```
  cd ~/qtqs_tools
  ./start_x.sh
  ```

  To override the default values for <mark>`DOCKER_TAG`</mark> (`25.1`) and <mark>`HOST_DESIGN_DIR`</mark> (`$HOME/fpga-designs`), define and export them in `start_x.sh`.

**NOTE:** By default, the `start_x.sh` script assumes the license file is located at `$HOME/licenses/questa.lic`

The docker has been tested on macOS Monterey 12.7.6, Linux Ubuntu 24.04 LTS, and WSL2. 





## Installed tools and devices

- Quartus Lite 25.1
- Questa FSE
- Cyclone
- CycloneV

