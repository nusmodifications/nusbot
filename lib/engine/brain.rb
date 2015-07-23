module NUSBotgram
  class Brain
    CONFIG = YAML.load_file("lib/config/config.yml")

    def initialize
      @@core = NUSBotgram::Wit::WitEngine.new(CONFIG[1][:WIT_CLIENT_ACCESS_TOKEN])
      @@processed_store = ""
    end

    public

    def learn(query)
      @@processed_store = @@core.message(query)
    end

    def message_id
      @@processed_store['msg_id']
    end

    def message_body
      @@processed_store['msg_body']
    end

    def intentions
      @@processed_store['outcomes'][0]['intent']
    end

    def confidence
      @@processed_store['outcomes'][0]['confidence']
    end

    def entities
      @@processed_store['outcomes'][0]['entities']
    end
  end
end
