require_relative 'lib/nus_botgram'

module NUSBotgram
  class NotificationsController
    scheduler = Rufus::Scheduler.new
    scheduler.join
  end
end