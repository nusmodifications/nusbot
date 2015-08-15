require 'yaml'
require_relative 'lib/nus_botgram'

module NUSBotgram
  class TourGuide
    # Configuration & setup
    CONFIG = YAML.load_file("lib/config/config.yml")

    engine = NUSBotgram::Core.new
    notify = NUSBotgram::Notifications.new

    idle_users = engine.identify_idle_users(CONFIG[2][:REDIS_DB_HISTORY])
    idle_users.each do |telegram_id|
      notify.send_notify(telegram_id, Global::SEND_MESSAGE, Global::BOT_TOUR_MESSAGE)
    end
  end
end