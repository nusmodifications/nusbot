module NUSBotgram
  module DataTypes
    class KeyboardButton < NUSBotgram::DataTypes::Base
      attribute :text, String
      attribute :request_contact, Boolean
      attribute :request_location, Boolean
    end
  end
end