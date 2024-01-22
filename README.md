# incus-auto

incus-auto is automating deployment system by Incus or LXD.

## Example

./example/gfarm-lustre

## Install

instlal `bin/incus-auto` to any directory. (PATH)

example:

```
install bin/incus-auto /usr/local/bin/
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

## Usage

- Create incus-auto.yaml

- TRGET_IMAGE_NAME or TARGET_INSTANCE_NAME
  - all names when `--all` is specified

- Build or rebuild images

```
incus-auto build TARGET_IMAGE_NAME
```

- Launch containers or virtual machines

```
incus-auto launch TARGET_INSTANCE_NAME
```

- Other commands
  - Usage: incus-auto COMMAND TARGET_INSTANCE_NAME
  - COMMAND
    - ps: List containers or virtual machines
    - ls: List by incus list
    - stop: Stop containers or virtual machines
    - start: Start containers or virtual machines
    - restart: Restart containers or virtual machines
    - delete: Delete containers or virtual machines
      - stopped instance only

## incus-auto.yml

TODO
