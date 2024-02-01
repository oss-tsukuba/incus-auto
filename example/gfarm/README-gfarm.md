# Gfarm on Incus

- see incus-auto.yaml
- create incus-auto.override.yaml to override incus-auto.yaml
- see parameters of SCRIPT/lib.sh
- create CONF/config.sh to override parameters

- install pigz
- run `incus config set images.compression_algorithm pigz`
- run `./git-clone-pull.sh`
- run `incus-auto build -a`
- run `./REBUILD.sh ALL`
- run `./SETUP.sh`  # TODO
- run `ia shell client1` # TODO
