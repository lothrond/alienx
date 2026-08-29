Changes (current)
---

* `make` is a single incantation

* Build targets are defined as profiles in `config.mk`

* Profiles are defined with `PROFILE`

* Profiles are configured in `config`

* `ansible` playbook system installs profiles

* The `assets` directory contains ansible assets

* Custom desktop backgrounds (will be) in `assets/backgrounds`

* `install` writes ISO image to a configured USB drive

* `install-dvd` writes ISO image to a configured DVD disk

* Set OUTPUT_ISO and GRUB_ENTRY statically in config, able to override

## Building/Making

	`make`

## Project structure

- Profile is set in `config.mk`
- Profile configuration directory is `./config`
- Working build directory is `./work`
- Ansible is `./assets`
- Custom desktop backgrounds to be continued in `assets/backrounds`
- Override most things


### Why?
- Just ignore any `.letitgo` things.
	* 👍

### Still broken?
- Probably

### Backgrounds?
- Removed custom backgrounds until i disclaim ownership of steam/valve/alienware
    * I do not own these logos

### Future?

    * ChromeOS device instruction
    * Maybe define `server` profile
        * Also `server-gui` profile
    * Finish Ansible
