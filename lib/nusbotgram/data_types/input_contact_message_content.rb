module NUSBotgram
  module DataTypes
    class InputContactMessageContent < NUSBotgram::DataTypes::InputMessageContent
      attribute :phone_number, String
      attribute :first_name, String
      attribute :last_name, String
    end
  end
end