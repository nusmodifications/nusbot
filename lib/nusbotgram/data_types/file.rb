module NUSBotgram
  module DataTypes
    class File < NUSBotgram::DataTypes::Base
      attribute :file_id, String
      attribute :file_size, Integer
      attribute :file_path, String
    end
  end
end