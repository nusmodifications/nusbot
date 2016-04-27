module NUSBotgram
  module DataTypes
    class ChosenInlineResult < NUSBotgram::DataTypes::Base
      attribute :result_id, String
      attribute :from, User
      attribute :location, Location
      attribute :inline_message_id, String
      attribute :query, String
    end
  end
end