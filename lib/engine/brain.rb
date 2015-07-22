require 'rest_client'
require 'json'

module NUSBotgram
  class Brain
    CONFIG = YAML.load_file("lib/config/config.yml")

    def initialize
      @@core = NUSBotgram::Wit::WitEngine.new(CONFIG[1][:WIT_CLIENT_ACCESS_TOKEN])
    end

    public

    def pre_process(query)
      result = @@core.message(query)

      result
    end
  end
end
