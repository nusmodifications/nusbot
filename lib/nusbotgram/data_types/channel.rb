module NUSBotgram
  module DataTypes
    # Custom attribute class to handle chat attribute in NUSBotgram::DataTypes::Message
    class Channel < Virtus::Attribute
      # Transforms a channel into a User object or GroupChat object
      def coerce(value)
        value.respond_to?(:first_name) ? User.new(value) : GroupChat.new(value)
      end
    end
  end
end
