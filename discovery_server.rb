require 'alpaca_device'

AlpacaDevice.configure do |config|
  config.alpaca_port = ENV['API_PORT']
end

AlpacaDevice::DiscoveryService.new(configuration: AlpacaDevice.config).run
