module NUSBotgram
  module DataTypes
    class Venue < NUSBotgram::DataTypes::Base
      attribute :location, Location
      attribute :title, String
      attribute :address, String
      attribute :foursquare_id, String
    end
  end
end