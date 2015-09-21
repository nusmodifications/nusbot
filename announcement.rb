require 'yaml'
require_relative 'lib/nus_botgram'

module NUSBotgram
  class Announcement
    # Configuration & setup
    CONFIG = YAML.load_file("lib/config/config.yml")

    engine = NUSBotgram::Core.new
    notify = NUSBotgram::Notifications.new

    i = 0
    idle_users = engine.get_all_users(CONFIG[2][:REDIS_DB_HISTORY])
    idle_users.each do |telegram_id|
      name = engine.get_user_details(CONFIG[2][:REDIS_DB_HISTORY], telegram_id)

      if name.eql?("") || name.to_s.empty?
        notify.send_notify(telegram_id, Global::SEND_MESSAGE, "Hello there, have a great recess week! NUSBot wish you all the best for your Mid-Terms!!\n\nHappy studying!")
      else
        notify.send_notify(telegram_id, Global::SEND_MESSAGE, "Hello #{name}, have a great recess week! NUSBot wish you all the best for your Mid-Terms!!\n\nJiayou & Happy studying!")
      end
    end
  end
end