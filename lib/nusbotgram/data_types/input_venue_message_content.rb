module NUSBotgram
  module DataTypes
    class InputVenueMessageContent < NUSBotgram::DataTypes::InputMessageContent
      attribute :latitude, Float
      attribute :longitude, Float
      attribute :title, String
      attribute :address, String
      attribute :foursquare_id, String
    end
  end
end