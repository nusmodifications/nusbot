module NUSBotgram
  module DataTypes
    # Telegram Callback Query data type
    #
    # @attr [String] id Unique identifier for this query
    # @attr [User] from Sender
    # @attr [Message] message Optional. Message with the callback button that originated the query. Note that message content and message date will not be available if the message is too old
    # @attr [String] inline_message_id Optional. Identifier of the message sent via the bot in inline mode, that originated the query
    # @attr [String] data Data associated with the callback button. Be aware that a bad client can send arbitrary data in this field
    #
    # See more at https://core.telegram.org/bots/api#callbackquery
    class CallbackQuery < NUSBotgram::DataTypes::Base
      attribute :id, String
      attribute :from, User
      attribute :message, Message
      attribute :inline_message_id, String
      attribute :data, String
    end
  end
end