module NUSBotgram
  module DataTypes
    class MessageEntity < NUSBotgram::DataTypes::Base
      attribute :type, String
      attribute :offset, Integer
      attribute :length, Integer
      attribute :url, String
    end
  end
end