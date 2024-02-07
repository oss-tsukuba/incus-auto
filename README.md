# incus-auto

incus-auto is automating deployment system by Incus or LXD.

## Usage Summary

- Install Incus
  - <https://linuxcontainers.org/incus/docs/main/installing/>
- Prepare storage pool
  - <https://linuxcontainers.org/incus/docs/main/howto/storage_pools/>
- Prepare remote server if needed
- Create `incus-auto.yaml`
  - define config (profile, network, disk, ...)
  - (optional) define buildimage
  - define host
- Initialize profile and network
  - `incus-auto init`
- Build images
  - `incus-auto build -a`
- Launch containers or virtual machines
  - `incus-auto launch -a`

## Install

install `bin/incus-auto` to the directory set in PATH.

example:

```
install -m 755 bin/incus-auto /usr/local/bin/
```

### Prepare storage pool

```
### Example
$ mkdir /mnt/disk2/incus-mypool
$ incus storage create mypool dir source=/mnt/disk2/incus-mypool
```

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

## Commands

See:

```
incus-auto -h
```

## Format of incus-auto.yml

- Example: ./example/gfarm/incus-auto.yml
