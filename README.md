# incus-auto

incus-auto is automating deployment system by Incus or LXD.

## Usage Summary

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
- Prepare storage pool
  - <https://linuxcontainers.org/incus/docs/main/howto/storage_pools/>
  - Example:
    - `mkdir /mnt/disk2/incus-mypool`
    - `incus storage create mypool dir source=/mnt/disk2/incus-mypool`
- Prepare remote server if needed
- Create `incus-auto.yaml`
  - Define config (profile, network, disk, ...)
  - (Optional) Define buildimage
  - Define host
  - Example: `./example/gfarm/incus-auto.*yaml`
    - Detail: `./example/gfarm/README-gfarm.md`
- (Recommendation) Install apt-cacher-ng and set http_proxy to accelerate
- Initialize profile and network
  - `incus-auto init`
- Build images
  - `incus-auto build -a`
- Launch containers or virtual machines
  - `incus-auto launch -a`

## Install incus-auto

install `bin/incus-auto` to the directory set in PATH.

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