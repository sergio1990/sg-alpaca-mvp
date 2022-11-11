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

#### USB-gadget mode

Everything works just fine when the computer and the raspberry are both
connected to the same wi-fi network. But it could be the case when there is no
possibility to have some router nearby, hence, there should another way how to
connect the raspberry pi to the computer, so that the former is visible as a
appropriate Alpaca device. One of the such ways is to connect the raspberry pi
to the computer via the USB cable, but for this the raspberry pi has to be
configured in a specific way - there are a lot of resources over the internet
guiding how to make the raspberry pi to be a USB-gadget, some of them includes:

- [Turning your Raspberry Pi Zero into a USB Gadget](https://learn.adafruit.com/turning-your-raspberry-pi-zero-into-a-usb-gadget)
- [RASPBERRY PI ZERO USB/ETHERNET GADGET TUTORIAL](https://www.circuitbasics.com/raspberry-pi-zero-ethernet-gadget/)

Also, it's worth to mention that the raspberry pi in the USB-gadget mode can
have troubles with proper recognizing by the Windows system. Please, take a
look at [this](https://forums.raspberrypi.com/viewtopic.php?t=245184) forum
thread helping out how to overcome that issue.
