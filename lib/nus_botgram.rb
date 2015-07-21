require 'excon'
require 'virtus'
require 'multi_json'

require_relative 'nusbotgram/version'

require_relative 'nusbotgram/data_types/base'
require_relative 'nusbotgram/data_types/audio'
require_relative 'nusbotgram/data_types/channel'
require_relative 'nusbotgram/data_types/contact'
require_relative 'nusbotgram/data_types/photo_size'
require_relative 'nusbotgram/data_types/user'
require_relative 'nusbotgram/data_types/sticker'
require_relative 'nusbotgram/data_types/video'

require_relative 'nusbotgram/data_types/document'
require_relative 'nusbotgram/data_types/force_reply'
require_relative 'nusbotgram/data_types/group_chat'
require_relative 'nusbotgram/data_types/location'
require_relative 'nusbotgram/data_types/message'
require_relative 'nusbotgram/data_types/reply_keyboard_hide'
require_relative 'nusbotgram/data_types/reply_keyboard_markup'
require_relative 'nusbotgram/data_types/update'
require_relative 'nusbotgram/data_types/user_profile_photos'

require_relative 'nusbotgram/bot'
require_relative 'nusbotgram/api_response'

require_relative 'engine/core'
require_relative 'config/global'
require_relative 'model/models'

require_relative 'common/algorithms'
require_relative 'common/query_pattern'

module NUSBotgram
  module Errors
    # Error returned when a required param is missing
    class MissingParamsError < StandardError
      def initialize(parameter, action)
        super("Missing parameter #{parameter} for action #{action}")
      end
    end

    # Error returned when a param type is invalid
    class InvalidParamTypeError < StandardError
      def initialize(parameter, current_type, allowed_types)
        super("Invalid parameter type: #{parameter}: #{current_type}. Allowed types: #{allowed_types.each {|type| type.class.to_s }.join(",")}.")
      end
    end

    # Error returned when something goes bad with your request to the Telegram API
    class BadRequestError < StandardError
      def initialize(error_code, message)
        super("Bad request. Error code: #{error_code} - Message: #{message}")
      end
    end

    # Error returned when Telegram API Service is unavailable
    class ServiceUnavailableError < StandardError
      def initialize(status_code)
        super("Telegram API Service unavailable (HTTP error code #{status_code})")
      end
    end
  end
end
