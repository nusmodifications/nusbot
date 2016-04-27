module NUSBotgram
  module DataTypes
    # Telegram InlineQueryResultVideo data type
    #
    # @attr [String] type Type of the result, must be video
    # @attr [String] id Unique identifier for this result, 1-64 Bytes
    # @attr [String] video_url A valid URL for the embedded video player or video file
    # @attr [String] mime_type Mime type of the content of video url, “text/html” or “video/mp4”
    # @attr [String] thumb_url URL of the thumbnail (jpeg only) for the video
    # @attr [Stinrg] title 	Optional. Title for the result
    # @attr [String] caption Optional. Caption of the MPEG-4 file to be sent, 0-200 characters
    # @attr [Integer] video_width Optional. Video width
    # @attr [Integer] video_height Optional. Video height
    # @attr [Integer] video_duration Optional. Video duration in seconds
    # @attr [String] description Optional. Short description of the result
    # @attr [InlineKeyboardMarkup] reply_markup Optional. Inline keyboard attached to the message
    # @attr [InputMessageContent] input_message_content Content of the message to be sent
    #
    # See more at https://core.telegram.org/bots/api#inlinequeryresultvideo
    class InlineQueryResultVideo < NUSBotgram::DataTypes::Base
      attribute :type, String, default: 'video'
      attribute :id, String
      attribute :video_url, String
      attribute :mime_type, String
      attribute :thumb_url, String
      attribute :title, String
      attribute :caption, String
      attribute :video_width, Integer
      attribute :video_height, Integer
      attribute :video_duration, Integer
      attribute :description, String
      attribute :reply_markup, InlineKeyboardMarkup
      attribute :input_message_content, InputMessageContent
    end
  end
end