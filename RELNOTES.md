# Release note for incus-auto

## Version ? (next)

- New command
  - update-dnsmasq
- New feature
  - use dnsmasq
  - incus-auto.yaml:/config/domain: new directive (default: test)
  - incus-auto.yaml:/config/network-default: new directive (default: first network name)
  - incus-auto.yaml:network-static:ipv4.gateway,domain,dns: can be set to __DEFAULT__
- Update feature
  - incus-auto.yaml:/config/update_etchosts: changed default value to false
  - example/gfarm: use "*.gfarm.test" domainname for hosts

## Version 0.9

- Initail version
