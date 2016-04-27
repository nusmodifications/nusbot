module NUSBotgram
  module DataTypes
    # Telegram Inline Query data type
    #
    # @attr [String] id Unique identifier for this query
    # @attr [User] from Sender
    # @attr [Location] location Optional. Sender location, only for bots that request user location
    # @attr [String] query Text of the query
    # @attr [String] offset Offset of the results to be returned, can be controlled by the bot
    #
    # See more at https://core.telegram.org/bots/api#inline-mode
    class InlineQuery < NUSBotgram::DataTypes::Base
      attribute :id, String
      attribute :from, User
      attribute :location, Location
      attribute :query, String
      attribute :offset, String
    end
  end
end
