# incus-auto

incus-auto is automating deployment system by Incus or LXD.

## Usage Summary

- Prepare storage pool
- Prepare remote server if needed
- Create `incus-auto.yaml`
  - define profile
  - define network
  - define images to build
  - define hosts
  - define scripts to deploy
- Initialize profile and network
- Build images
- Launch containers or virtual machines

## Install

instlal `bin/incus-auto` to any directory. (PATH)

example:

```
install -m 755 bin/incus-auto /usr/local/bin/
```

### Prepare storage pool

See <https://linuxcontainers.org/incus/docs/main/howto/storage_pools/>

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
incus -h
```

## Format of incus-auto.yml

- Example: ./example/gfarm-lustre/

TODO
