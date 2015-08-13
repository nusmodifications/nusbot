require 'yaml'
require_relative 'lib/nus_botgram'

module NUSBotgram
  class Maintenance
    engine = NUSBotgram::Core.new
    notify = NUSBotgram::Notifications.new
    telegram_ids = engine.get_all_users

    telegram_ids.each do |users|
      notify.send_notify(users, Global::SEND_MESSAGE, Global::BOT_MAINTENANCE_MESSAGE)
    end
  end
end