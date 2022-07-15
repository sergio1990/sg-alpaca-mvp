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

# Basically, the implementation of this focuser class
# should conform to the ASCOM device interface defined here:
# https://ascom-standards.org/Help/Developer/html/T_ASCOM_DeviceInterface_IFocuserV3.htm
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

    driver = StepperRpi::Drivers::ULN2003.new(
      mode: StepperRpi::Drivers::ULN2003::Mode::HALF_STEP,
      pins: [14, 15, 18, 23],
      gpio_adapter: RpiGPIOAdapter.new
    )

    @motor = StepperRpi.motor(
      driver: driver
    )
    @motor.speed = 70
  end

  def connected
    motor.is_connected
  end

  def ismoving
    motor.is_running
  end

  def position
    motor.position
  end

  def set_tempcomp(tempcomp:)
  end

  def set_halt
    motor.stop
  end

  def set_move(position:)
    # since this focuser is the relative positioning one,
    # the position parameter it's a number of steps the focuser needs to move
    # and the value should be between -maxincrement..+maxincrement
    motor.do_steps(position)
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
    if connected
      motor.connect
    else
      motor.disconnect
    end
  end

  private

  attr_reader :motor
end
