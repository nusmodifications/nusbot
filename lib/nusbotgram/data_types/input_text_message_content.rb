module NUSBotgram
  module DataTypes
    class InputTextMessageContent < NUSBotgram::DataTypes::InputMessageContent
      attribute :message_text, String
      attribute :parse_mode, String
      attribute :disable_web_page_preview, Boolean
    end
  end
end