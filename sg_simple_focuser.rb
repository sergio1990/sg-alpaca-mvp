require 'alpaca_device'
require 'stepper_rpi'
require 'raspi-gpio'

class RpiGPIOAdapter < StepperRpi::GPIOAdapter
  def initialize
    @pins = {}
  end

  def setup_pin(pin)
    gpio_pin = GPIO.new(pin, OUT)
    # Give some time for the system to create needed files
    # and set proper permissions
    sleep(0.5)
    gpio_pin.set_mode(OUT)
    @pins[pin] = gpio_pin
  end

  def set_pin_value(pin, value)
    gpio_pin = @pins[pin]
    gpio_value = value == 1 ? HIGH : LOW
    gpio_pin.set_value(gpio_value)
  end
end

class SGSimpleFocuser < AlpacaDevice::AscomDevices::BaseFocuser
  def initialize
    super(name: 'SG Simple Focuser', uuid: '72149a61-4f75-405b-8b3a-8573b76f5f5a')

    @position = 0
    @description = "SG Simple Focuser"
    @driverinfo = "The driver for the SG Simple Focuser"
    @driverversion = "1.0.beta1"
    @interfaceversion = 3
    @supportedactions = []
    @absolute = false
    @ismoving = false
    @maxincrement = 100
    @maxstep = 65535
    @stepsize = 4
    @tempcomp = false
    @tempcompavailable = false
    @temperature = 20
  end

  def set_tempcomp(tempcomp:)
  end

  def set_halt
  end

  def set_move(position:)
  end

  def set_action(action:, parameters:)
  end

  def set_commandblind(command:, raw:)
  end

  def set_commandbool(command:, raw:)
    false
  end

  def set_commandstring(command:, raw:)
    ""
  end

  def set_connected(connected:)
  end
end
