module NUSBotgram
  module DataTypes
    # Telegram InlineKeyboardButton data type
    #
    # @attr [Array of Array InlineKeyboardButton] Array of button rows, each represented by an Array of InlineKeyboardButton objects
    #
    # See more at https://core.telegram.org/bots/api#inlinekeyboardmarkup
    class InlineKeyboardMarkup < NUSBotgram::DataTypes::Base
      attribute :inline_keyboard, Array[Array[InlineKeyboardButton]]

      def to_hash
        _hash = super
        _hash[:inline_keyboard].map! do |ary|
          ary.map do |item|
            item.is_a?(InlineKeyboardButton) ? item.to_compact_hash : item
          end
        end

        _hash
      end
    end
  end
end