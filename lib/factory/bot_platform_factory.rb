require_relative 'bot_platform'

module NUSBotgram
  class BotPlatformFactory < BotPlatform
    def create(platform)
      if [:tbot, :wbot].include?(platform)
        self.class.const_get(platform.to_s.capitalize).new
      else
        raise "Unknown"
      end
    end
  end
end