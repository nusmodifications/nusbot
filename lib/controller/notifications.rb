module NUSBotgram
  class Notifications
    API_ENDPOINT = "https://api.telegram.org/bot"
    CONFIG = YAML.load_file("lib/config/config.yml")

    def initialize

    end

    def send_notify(telegram_id, action, message)
      query = { :chat_id => "#{telegram_id}", :text => "#{message}" }
      HTTParty.post("#{API_ENDPOINT}#{CONFIG[0][:T_BOT_APIKEY_DEV]}#{action}", :query => query)
    end
  end
end
