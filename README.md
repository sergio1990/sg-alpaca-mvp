# SG Alpaca device - MVP version

The SG Alpaca device MVP version implements the [ASCOM
Alpaca](https://www.ascom-standards.org/Developer/Alpaca.htm) specifications in
order to control the manually built focuser through the ASCOM-compatible
astronomical software.

The MVP version was specifically built in order to check all the involved
pieces together by launching it on the RaspberryPi. Another pieces are the set
of libraries specifically built for creating ASCOM Alpaca devices:

- [alpaca-device](https://github.com/sergio1990/alpaca-device) - the ruby gem,
  which provides all needed ASCOM Alpaca-compatible APIs - discovery
API/management API/device API
- [stepper-rpi](https://github.com/sergio1990/stepper_rpi) - the ruby gem,
  which encapsulates all the logic needed to control the stepper motor from the
Raspberry Pi

The components diagram is presented below:

![components](imgs/components.png)

### Setup steps

1. Prepare the Raspberry Pi - configure wi-fi, install ruby
2. Edit `~/.profile` by adding asdf bin&shims folders into the PATH
3. Clone the repo
4. Open the repo root folder
5. Run `bin/setup` script
6. Update the `.env` file with own settings
7. Run `bin/export` script - it will generate systemd compatible config files
and put them into the corresponding system folder. The script  requires one
argument - the name of the user the alpaca device will be run under; I've used
just a user `pi` created automatically when setupping my Raspberry Pi.
8. Run `sudo systemctl daemon-reload` to pick up added files by the systemd
subsystem
9. Run `systemctl start sg-alpaca.target`

There are other useful commands:

- `systemctl status sg-alpaca.target` - to check the running status
- `systemctl status sg-alpaca-api.1.service` - to check the running status of
  the device API module
- `systemctl status sg-alpaca-discovery.1.service` - to check te running status
  of the discovery module

Ideally, after all the mentioned steps the sg-alpaca target will be
automatically run on system startup time. The `systemctl status ...` command as
well as `journalctl -u ...` one both can be used to get stdout&stderr outputs
of the desired service for debugging any issues.
