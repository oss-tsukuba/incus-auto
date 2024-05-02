# Gfarm development environment with Docker

## Get Gfarm source to ~/gfarm

SEE ALSO:

- (gfarm)/docker/dev/README.en
- (incus-auto)/example/gfarm/git-clone-pull.sh

## Configuration

Default configuration is for LXD.

Example of `incus-auto.override.yaml` for Incus.

```yaml
config:
  incus_command: incus
  profile:
    prof:
      devices:
        eth0:
          network: incusbr0
          type: nic
  #envvar:
  #  http_proxy: http://192.168.1.11:3142
  #  https_proxy: http://192.168.1.11:3142

host:
  work:
    image: images:ubuntu/24.04
```

## Launch and use shell

- incus-auto init
- incus-auto launch -a
- incus-auto shell work

Development environment with Docker

- cd ~/gfarm/docker/dist
- (or) cd ~/gfarm/docker/dev


## Destroy

- incus-auto stop -a
- incus-auto delete -a
- incus-auto destroy

## One liner

```bash
incus-auto stop -a; incus-auto delete -a; incus-auto destroy && incus-auto init && incus-auto launch -a && incus-auto shell work
```

## Synchronize ~/gfarm/*/* files

- incus-auto shell work
- sh /SCRIPT/setup-gfarm-docker-dev.sh

## How to use Web browser for jwt-server

TODO
