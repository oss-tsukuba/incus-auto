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
