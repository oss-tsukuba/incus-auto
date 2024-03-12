# Gfarm on Incus

- See incus-auto.yaml, incus-auto.gfarm.yaml and incus-auto.lustre.yaml
- (Optional) Create incus-auto.override.yaml to override incus-auto.yaml
- See parameters of SCRIPT/lib.sh
- (Optional) Create CONF/config.sh to override parameters
- Install incus
- Install pigz
- Run `incus config set images.compression_algorithm pigz`
- Run `make git-clone` to get Gfarm
- Create incus-auto.override.yaml if you need
  - Create pool if you need, and override `default_pool`
- Run `make init`
- Run `make build-gfarm`
- Run `make launch-gfarm`
- Run `make setup-gfarm`
- Run `make gfclient`
  - or Run `make` (login to the manage container) and `ssh gfclient01`
- Enjoy Gfarm operations ...
- ctrl-d (exit from gfclient01)
- ctrl-d (exit from manage)

## Lustre HSM for Gfarm

- Run `make build-lustre`
- Run `make launch-lustre`
- Run `make setup-gfarm-all`
- (Another terminal) run `make start-lustre-hsm` (foregroud, ctrl-c to stop)
- Run `make lclient` and `cd /mnt/lustre` (Please wait for automount)
- Enjoy Lustre operations ...
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

- Run `make down` to remove only containers
- Run `make CLEAN` to destroy the environemnt
