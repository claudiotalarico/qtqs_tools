# QTQS-TOOLS
**qtqs-tools** is a docker container for running Questa Lite (version 25.1) and Quartus FSE.  

The docker image is built on Ubuntu 24.04 LTS, and the CPU architecture supported is `x86_64/amd64`.

As of 2026, Intel does not natively support Quartus for ARM64 (aarch64) architecture.
There are currently no official roadmaps to release a native ARM64 version for machines like modern Mac (Apple Silicon), Windows on ARM laptops, or Linux ARM devices.

## How to use the tools

**Step 1: Clone/download this GitHub repository onto your computer**
```
git clone --depth=1 https://github.com/ctalarico/qtqs_tools.git
```

**Step 2: Install and start Docker on your computer**
