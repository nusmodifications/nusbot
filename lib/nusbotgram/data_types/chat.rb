module NUSBotgram
  module DataTypes
    class Chat < NUSBotgram::DataTypes::Base
      attribute :id, Integer
      attribute :type, String
      attribute :title, String
      attribute :username, String
      attribute :first_name, String
      attribute :last_name, String
    end
  end
end