# incus-auto

incus-auto is automating deployment system using Incus.

## Requirement

- Incus (or LXD)
- (Option) Nested Virtualization
  - when using VM on VM

## Summary

- Install Incus
  - <https://linuxcontainers.org/incus/docs/main/installing/>
- Run `incus config set images.compression_algorithm pigz`
- Install python3-docopt, python3-schema, python3-yaml
  - Debian:
    - `apt-get install python3 python3-docopt python3-schema python3-yaml`
  - RHEL:
    - `yum install epel-release`
    - `yum install python3 python3-docopt python3-schema python3-pyyaml`
- Install incus-auto
  - Example:
    - `install -m 755 bin/incus-auto /usr/local/bin/`
- Create storage pool when using other than "default" pool
  - <https://linuxcontainers.org/incus/docs/main/howto/storage_pools/>
  - Example:
    - `mkdir /mnt/disk2/incus-mypool`
    - `incus storage create mypool dir source=/mnt/disk2/incus-mypool`
- Prepare remote server if needed
- Create `incus-auto.yaml` and `incus-auto.override.yaml`
  - Define config (profile, network, disk, ...)
    - Define `config`
      - (Option) Set `default_pool`
    - (Option) Define `buildimage`
    - Define `host`
  - Example: `./example/gfarm/incus-auto.*yaml`
    - Detail: `./example/gfarm/README-gfarm.md`
- (Recommendation) Install apt-cacher-ng and set http_proxy to accelerate
- Initialize profile and network
  - `incus-auto init`
- Build images
  - `incus-auto build -a`
- Launch containers or virtual machines
  - `incus-auto launch -a`

## Add remote Incus server

- client certificate
  - Incus
    - ~/.config/incus/client.crt
  - LXD
    - ~/snap/lxd/common/config/client.crt
- @server (for example)
  - Incus
    - incus config set core.https_address "[::]:8443"
    - incus config trust add-certificate client1-client.crt --name client1
  - LXD
    - lxc config set core.https_address "[::]:18443"
    - lxc config trust add client2-client.crt --name client2
- @client (for example)
  - Incus
    - incus remote add incus1 https://SERVERNAME:8443
    - incus ls incus1:
  - LXD
    - lxc remote add lxd1 https://SERVERNAME:18443
    - lxc ls lxd1:

## Using http_proxy (apt-cacher-ng, etc.)

Create `incus-auto.override.yaml`

```
config:
  envvar:
    http_proxy: http://<apt-cacher-ng IP address>:3142
    https_proxy: http://<apt-cacher-ng IP address>:3142
```

## Commands

See:

```
incus-auto -h
```

## Incus mirror servers

- https://discuss.linuxcontainers.org/t/image-server-infrastructure/16647
- https://status.images.linuxcontainers.org/
- download images directly from the primary server
  - `incus remote rename images images-orig`
  - `incus remote add images https://ca.images.linuxcontainers.org/ --protocol simplestreams`

## Firewall

- Incus
  - https://linuxcontainers.org/incus/docs/main/howto/network_bridge_firewalld/
- LXD
  - https://documentation.ubuntu.com/lxd/en/latest/howto/network_bridge_firewalld/

## WSL2

- When using VM
  - Windows 11 is required
    - for `nestedVirtualization=true` (default) (.wslconfig)
    - not work on Windows 10
  - `Error: Failed to run: modprobe -b vhost_vsock: exit status 1 (modprobe: FATAL: Module vhost_vsock not found in directory /lib/modules/5.15.146.1-microsoft-standard-WSL2)`
  - Build custom Linux Kernel (to enable vhost_vsock module)
    - See: https://gist.github.com/jacky9813/927261020bb1dacc1a7baedef657b732
    - (my operation log)
```
sudo apt update
sudo apt install git bc build-essential flex bison libssl-dev libelf-dev dwarves
uname -a
Linux DVL3-01 5.15.133.1-microsoft-standard-WSL2 #1 SMP Thu Oct 5 21:02:42 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux

# not set .1
KVER=5.15.133
wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-${KVER}.tar.xz
tar xf linux-${KVER}.tar.xz

pushd linux-${KVER}
wget -O arch/x86/configs/config-wsl \
https://raw.githubusercontent.com/microsoft/WSL2-Linux-Kernel/linux-msft-wsl-5.15.y/arch/x86/configs/config-wsl

# Create a duplicate to modify
cp arch/x86/configs/config-wsl arch/x86/configs/config-wsl-custom

sudo apt install libncurses-dev
make KCONFIG_CONFIG=arch/x86/configs/config-wsl-custom menuconfig
```
  - Device Drivers -> VHOST drivers -> <M> vhost virtio-vsock driver
```
make KCONFIG_CONFIG=arch/x86/configs/config-wsl-custom -j$(nproc)
sudo make KCONFIG_CONFIG=arch/x86/configs/config-wsl-custom modules_install

mkdir -p /mnt/c/Users/USERNAME/wsl2-kernel
cp arch/x86/boot/bzImage /mnt/c/Users/USERNAME/wsl2-kernel/bzImage-5.15.133-WSL2-custom

echo vhost_vsock | sudo tee -a /etc/modules

vi  /mnt/c/Users/USERNAME/.wslconfig
[wsl2]
kernel=C:\\\\Users\\\\USERNAME\\\\wsl2-kernel\\\\bzImage-5.15.133-WSL2-custom
```
- Start Ubuntu on WSL2
- in Ubuntu
  - `sudo iptables -P FORWARD ACCEPT`
  - Edit /etc/wsl.conf
  ```
  [boot]
  memory=16GB
  systemd=true
  ```
- `wsl --shutdown` at Windows Powershell
- Start Ubuntu on WSL2
- Install Incus
