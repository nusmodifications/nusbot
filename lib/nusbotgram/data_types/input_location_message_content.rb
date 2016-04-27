module NUSBotgram
  module DataTypes
    class InputLocationMessageContent < NUSBotgram::DataTypes::InputMessageContent
      attribute :latitude, Float
      attribute :longitude, Float
    end
  end
end