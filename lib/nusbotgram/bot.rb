module NUSBotgram
  class Bot
    API_ENDPOINT = 'https://api.telegram.org'

    attr_reader :me

    def initialize(api_token)
      @api_token = api_token
      @offset = 0
      @timeout = 60

      @me = get_me
    end

    def get_updates(&block)
      loop do
        response = api_request("getUpdates", {offset: @offset, timeout: @timeout}, nil)

        response.result.each do |raw_update|
          update = NUSBotgram::DataTypes::Update.new(raw_update)

          @offset = update.update_id + 1
          yield update.message
        end
      end
    end

    def set_webhook(url)
      api_request("setWebhook", {url: url}, nil)
    end

    def get_me
      response = api_request("getMe", nil, nil)

      NUSBotgram::DataTypes::User.new(response.result)
    end

    def send_message(params)
      params_validation = {
          chat_id: { required: true, class: [Fixnum] },
          text: { required: true, class: [String] },
          disable_web_page_preview: { required: false, class: [TrueClass, FalseClass] },
          reply_to_message_id: { required: false, class: [Fixnum] },
          reply_markup: { required: false, class: [
              NUSBotgram::DataTypes::ReplyKeyboardMarkup,
              NUSBotgram::DataTypes::ReplyKeyboardHide,
              NUSBotgram::DataTypes::ForceReply,
          ]}
      }

      response = api_request("sendMessage", params, params_validation)

      NUSBotgram::DataTypes::Message.new(response.result)
    end

    def forward_message(params)
      params_validation = {
          chat_id: { required: true, class: [Fixnum] },
          from_chat_id: { required: true, class: [String] },
          message_id: { required: true, class: [Fixnum] }
      }

      response = api_request("forwardMessage", params, params_validation)

      NUSBotgram::DataTypes::Message.new(response.result)
    end

    def send_photo(params)
      params_validation = {
          chat_id: { required: true, class: [Fixnum] },
          photo: { required: true, class: [File, String] },
          caption: { required: false, class: [String] },
          reply_to_message_id: { required: false, class: [String] },
          reply_markup: { required: false, class: [
              NUSBotgram::DataTypes::ReplyKeyboardMarkup,
              NUSBotgram::DataTypes::ReplyKeyboardHide,
              NUSBotgram::DataTypes::ForceReply,
          ]}
      }

      response = api_request("sendPhoto", params, params_validation)

      NUSBotgram::DataTypes::Message.new(response.result)
    end

    def send_audio(params)
      params_validation = {
          chat_id: { required: true, class: [Fixnum] },
          audio: { required: true, class: [File, String] },
          reply_to_message_id: { required: false, class: [String] },
          reply_markup: { required: false, class: [
              NUSBotgram::DataTypes::ReplyKeyboardMarkup,
              NUSBotgram::DataTypes::ReplyKeyboardHide,
              NUSBotgram::DataTypes::ForceReply,
          ]}
      }

      response = api_request("sendAudio", params, params_validation)

      NUSBotgram::DataTypes::Message.new(response.result)
    end

    def send_document(params)
      params_validation = {
          chat_id: { required: true, class: [Fixnum] },
          document: { required: false, class: [File, String] },
          reply_to_message_id: { required: false, class: [String] },
          reply_markup: { required: false, class: [
              NUSBotgram::DataTypes::ReplyKeyboardMarkup,
              NUSBotgram::DataTypes::ReplyKeyboardHide,
              NUSBotgram::DataTypes::ForceReply,
          ]}
      }

      response = api_request("sendDocument", params, params_validation)

      NUSBotgram::DataTypes::Message.new(response.result)
    end

    def send_sticker(params)
      params_validation = {
          chat_id: { required: true, class: [Fixnum] },
          sticker: { required: true, class: [File, String] },
          reply_to_message_id: { required: false, class: [String] },
          reply_markup: { required: false, class: [
              NUSBotgram::DataTypes::ReplyKeyboardMarkup,
              NUSBotgram::DataTypes::ReplyKeyboardHide,
              NUSBotgram::DataTypes::ForceReply,
          ]}
      }

      response = api_request("sendSticker", params, params_validation)

      NUSBotgram::DataTypes::Message.new(response.result)
    end

    def send_video(params)
      params_validation = {
          chat_id: { required: true, class: [Fixnum] },
          video: { required: true, class: [File, String] },
          reply_to_message_id: { required: false, class: [String] },
          reply_markup: { required: false, class: [
              NUSBotgram::DataTypes::ReplyKeyboardMarkup,
              NUSBotgram::DataTypes::ReplyKeyboardHide,
              NUSBotgram::DataTypes::ForceReply,
          ]}
      }

      response = api_request("sendVideo", params, params_validation)

      NUSBotgram::DataTypes::Message.new(response.result)
    end

    def send_location(params)
      params_validation = {
          chat_id: { required: true, class: [Fixnum] },
          latitude: { required: true, class: [Float] },
          longitude: { required: true, class: [Float] },
          reply_to_message_id: { required: false, class: [String] },
          reply_markup: { required: false, class: [
              NUSBotgram::DataTypes::ReplyKeyboardMarkup,
              NUSBotgram::DataTypes::ReplyKeyboardHide,
              NUSBotgram::DataTypes::ForceReply,
          ]}
      }

      response = api_request("sendLocation", params, params_validation)

      NUSBotgram::DataTypes::Message.new(response.result)
    end

    def send_chat_action(params)
      params_validation = {
          chat_id: { required: true, class: [Fixnum] },
          action: { required: true, class: [String] }
      }

      api_request("sendChatAction", params, params_validation)
    end

    def get_user_profile_photos(params)
      params_validation = {
          user_id: { required: true, class: [Fixnum] },
          offset: { required: false, class: [Fixnum] },
          limit: { required: false, class: [Fixnum] }
      }

      response = api_request("getUserProfilePhotos", params, params_validation)

      NUSBotgram::DataTypes::UserProfilePhotos.new(response.result)
    end

    private

    def api_request(action, params, params_validation)
      api_uri = "bot#{@api_token}/#{action}"

      if params_validation.nil?
        validated_params = params
      else
        # Delete params not accepted by the API
        validated_params = params.delete_if {|k, v| !params_validation.has_key?(k) }

        # Check all required params by the action are present
        params_validation.each do |key, value|
          if params_validation[key][:required] && !params.has_key?(key)
            raise NUSBotgram::Errors::MissingParamsError.new(key, action)
          end
        end

        params.each do |key, value|
          # Check param types
          if !params_validation[key][:class].include?(value.class)
            raise NUSBotgram::Errors::InvalidParamTypeError.new(key, value.class, params_validation[key][:class])
          end

          # Prepare params for sending in Typhoeus post body request
          params[key] = value.to_s if value.class == Fixnum
          params[key] = value.to_h.to_json if [
              NUSBotgram::DataTypes::ReplyKeyboardMarkup,
              NUSBotgram::DataTypes::ReplyKeyboardHide,
              NUSBotgram::DataTypes::ForceReply
          ].include?(value.class)
        end
      end

      response = Typhoeus.post(
          "#{API_ENDPOINT}/#{api_uri}",
          body: validated_params,
          headers: {
              "User-Agent" => "NUSBotgram/#{NUSBotgram::VERSION}",
              "Accept" => "application/json"
          }
      )

      ApiResponse.new(response)
    end
  end
end
