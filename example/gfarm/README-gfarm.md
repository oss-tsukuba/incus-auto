# Gfarm development environment on Incus

## Host overview (Container and VM)

- Gfarm gfmd x 3
- Gfarm gfsd x 4
- Gfarm client x 1
- Lustre mds,mgs x 1
- Lustre oss x 1
- Lustre client x 1
  - Lustre HSM + gfarm2fs

## Requirements

- RAM: 16GB
- DISK: 100GB

## Setup Gfarm

- See incus-auto.yaml, incus-auto.gfarm.yaml and incus-auto.lustre.yaml
- (Optional) Create incus-auto.override.yaml if you need
  - Create pool if you need, and override `default_pool`
- See parameters of SCRIPT/lib.sh
- (Optional) Create CONF/config.sh to override parameters
- Install `incus, make and pigz`
  - Ex.: Run `sudo apt-get install incus make pigz`
- Run `incus config set images.compression_algorithm pigz`
- Run `make git-clone` to get Gfarm
- Run `make init`
- Run `make build-gfarm`
- Run `make launch-gfarm`
- Run `make setup-gfarm`
- Regression test:
  - Run `make send-ssh-privkey`
  - Run `make regress`
- Run `make gfclient`
  - or Run `make` (login to the manage container) and `ssh gfclient01`
  - Enjoy Gfarm operations ...
- ctrl-d (exit from gfclient01)
- ctrl-d (exit from manage)

## Setup Lustre

- Run `make build-lustre`
- Run `make launch-lustre`
- Run `make setup-gfarm-all`
- (Another terminal) run `make start-lustre-hsm`
  - foregroud
  - ctrl-c to stop
- Run `make lclient` and `cd /mnt/lustre` (Please wait for automount)
- Enjoy Lustre operations ...
  - sudo mkdir tmp
  - sudo chmod 1777 tmp
  - (file creation, Lustre operations, etc. ...)
    - (ex. sudo lfs setstripe -c 2 .)
  - sudo lfs hsm_archive FILENAME
  - sudo lfs hsm_state FILENAME
    - "exists archived"
  - find /tmp/gfarmsys/LustreHSM/shadow/
  - sudo lfs hsm_release FILENAME
  - sudo lfs hsm_state FILENAME
    - "released exists archived"
  - sudo lfs hsm_restore FILENAME
  - sudo lfs hsm_state FILENAME
    - "exists archived"
  - sudo lfs hsm_remove FILENAME
  - sudo lfs hsm_state FILENAME
    - "file: (0x00000000),"
  - Details: <https://doc.lustre.org/lustre_manual.xhtml#hsm_introduction>
- ctrl-d (exit from lclient1)

## Good-bye

- Run `make down` to remove only containers
- Run `make CLEAN` to destroy the environemnt
