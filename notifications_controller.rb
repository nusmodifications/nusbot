require 'yaml'
require_relative 'lib/nus_botgram'

module NUSBotgram
  class NotificationsController
    # Configuration & setup
    CONFIG = YAML.load_file("lib/config/config.yml")

    engine = NUSBotgram::Core.new
    notify = NUSBotgram::Notifications.new
    redis_scheduler = Redis.new(:host => CONFIG[3][:SCHEDULER_REDIS_HOST], :port => CONFIG[3][:SCHEDULER_REDIS_PORT], :db => CONFIG[3][:SCHEDULER_REDIS_DB_DEFAULT])
    scheduler_engine = NUSBotgram::RedisScheduler.new(redis_scheduler, blocking: true)

    scheduler_engine.each do |identifier, at|
      telegram_id = identifier.split(':').first
      message_id = identifier.split(':').last

      tasks = engine.get_alert_transactions(telegram_id, message_id)
      notify.send_notify(telegram_id, Global::SEND_MESSAGE, tasks)
      engine.remove_alert_transactions(telegram_id, message_id)
    end
  end
end