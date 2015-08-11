module NUSBotgram
  class Notifications
    API_ENDPOINT = 'https://api.telegram.org/bot'
    CONFIG = YAML.load_file("lib/config/config.yml")

    def initialize
      @connection = Excon.new(API_ENDPOINT, :persistent => true)
    end

    def send_notify(telegram_id, action, message)
      api_uri = "#{API_ENDPOINT}#{CONFIG[0][:T_BOT_APIKEY_PROD]}#{action}"
      query = { :chat_id => "#{telegram_id}", :text => "#{message}" }
      # HTTParty.post(api_uri, :query => query)
      @connection.post(:path => api_uri,
                       :query => query)
    end
  end
end
