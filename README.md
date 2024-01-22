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
$ lxc storage create mypool dir source=/mnt/disk2/incus-mypool
```

## Add remote Incus server

```
### server
incus config set core.https_address "[::]"
incus config trust add client1 > token-client1.txt
##### (for LXD)
##### incus config trust add --name client1 > token-client1.txt

### client
incus remote add server1 `cat token-client1.txt`

### server
$ incus remote ls
+-----------------+------------------------------------------+---------------+-------------+--------+--------+--------+
|      NAME       |                   URL                    |   PROTOCOL    |  AUTH TYPE  | PUBLIC | STATIC | GLOBAL |
+-----------------+------------------------------------------+---------------+-------------+--------+--------+--------+
| images          | https://images.linuxcontainers.org       | simplestreams | none        | YES    | NO     | NO     |
+-----------------+------------------------------------------+---------------+-------------+--------+--------+--------+
| server1         | https://10.0.0.123:8443                  | incus         | tls         | NO     | NO     | NO     |
+-----------------+------------------------------------------+---------------+-------------+--------+--------+--------+
| local (current) | unix://                                  | incus         | file access | NO     | YES    | NO     |
+-----------------+------------------------------------------+---------------+-------------+--------+--------+--------+
```

## Commands

See:

```
incus -h
```

## Format of incus-auto.yml

- Example: ./example/gfarm-lustre/

TODO
