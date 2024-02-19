# Gfarm on Incus

- see incus-auto.yaml
- (optional) create incus-auto.override.yaml to override incus-auto.yaml
- see parameters of SCRIPT/lib.sh
- (optional) create CONF/config.sh to override parameters
- install incus
- install pigz
- run `mkdir /mnt/diskX/incus-mypool`
- run `incus storage create mypool dir source=/mnt/diskX/incus-mypool`
- run `incus config set images.compression_algorithm pigz`
- run `./git-clone-pull.sh`
- run `make init`
- run `make build-gfarm`
- run `make launch-gfarm`
- run `make setup-gfarm`
- run `make gfclient`
  - or run `make` (login to the manage container) and `ssh gfclient1`
- enjoy Gfarm operations ...
- ctrl-d (exit from gfclient1)
- ctrl-d (exit from manage)

## Lustre HSM for Gfarm

- run `make build-lustre`
- run `make launch-lustre`
- (Another terminal) run `make start-lustre-hsm` (foregroud, ctrl-c to stop)
- run `make lclient` and `cd /mnt/lustre` (Please wait for automount)
- enjoy Lustre operations ...
  - sudo mkdir tmp
  - sudo chmod 1777 tmp
  - ...
  - sudo lfs hsm_archive FILENAME
  - sudo lfs hsm_release FILENAME
  - sudo lfs hsm_restore FILENAME
  - sudo lfs hsm_remove FILENAME
  - sudo lfs setstripe -c 2 .
- ctrl-d (exit from lclient1)

## Good-bye

- run `make down` to remove only containers
- run `make CLEAN` to destroy the environemnt
