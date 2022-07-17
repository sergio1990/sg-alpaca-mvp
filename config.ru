require 'bundler/setup'
require 'alpaca_device'

require_relative './sg_simple_focuser'

speed = ENV.fetch('STEPPER_SPEED', 100).to_i

AlpacaDevice.configure do |config|
  config.alpaca_port = ENV['API_PORT']

  config.description_name = "SG Alpaca Device Beta"
  config.description_creator = "Sergey Gernyak <sergeg1990@gmail.com>"
  config.description_version = "v0.1.0.beta1"
  config.description_location = "Kyiv, UA"

  config.register_ascom_device SGSimpleFocuser.new(speed: speed)
end

run AlpacaDevice::Api
