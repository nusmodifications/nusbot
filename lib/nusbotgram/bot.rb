module NUSBotgram
  class Bot
    API_ENDPOINT = 'https://api.telegram.org'

    attr_reader :me

    def initialize(api_token)
      @api_token = api_token
      @offset = 0
      @timeout = 60
      @connection = HTTPClient.new
      # @connection = Excon.new(API_ENDPOINT, :persistent => true)

      @me = get_me
    end

    def update(&block)
      response = api_request("getUpdates", { offset: @offset, timeout: @timeout }, nil)

      response.result.each do |raw_update|
        update = NUSBotgram::DataTypes::Update.new(raw_update)

        @offset = update.update_id + 1
        yield update.message
      end
    end

    def get_updates(&block)
      loop do
        response = api_request("getUpdates", { offset: @offset, timeout: @timeout }, nil)

        response.result.each do |raw_update|
          update = NUSBotgram::DataTypes::Update.new(raw_update)

          @offset = update.update_id + 1
          yield update.message
        end
      end
    end

    def set_webhook(url)
      api_request("setWebhook", { url: url }, nil)
    end

    def get_me
      response = api_request("getMe", nil, nil)

      NUSBotgram::DataTypes::User.new(response.result)
    end

    def send_message(params)
      strict_params_validation = {
          text: { required: true, class: [String] },
          disable_web_page_preview: { required: false, class: [TrueClass, FalseClass] }
      }

      send_method(:message, params, strict_params_validation)
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
      strict_params_validation = {
          photo: { required: false, class: [File, String] },
          caption: { required: false, class: [String] }
      }

      send_method(:photo, params, strict_params_validation)
    end

    def send_audio(params)
      strict_params_validation = {
          audio: { required: false, class: [File, String] }
      }

      send_method(:audio, params, strict_params_validation)
    end

    def send_document(params)
      strict_params_validation = {
          document: { required: false, class: [File, String] }
      }

      send_method(:document, params, strict_params_validation)
    end

    def send_sticker(params)
      strict_params_validation = {
          sticker: { required: true, class: [File, String] }
      }

      send_method(:sticker, params, strict_params_validation)
    end

    def send_video(params)
      strict_params_validation = {
          video: { required: true, class: [File, String] }
      }

      send_method(:video, params, strict_params_validation)
    end

    def send_location(params)
      strict_params_validation = {
          latitude: { required: true, class: [Float] },
          longitude: { required: true, class: [Float] }
      }

      send_method(:location, params, strict_params_validation)
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
      api_uri = "/bot#{@api_token}/#{action}"

      if params_validation.nil?
        validated_params = params
      else
        # Delete params not accepted by the API
        validated_params = params.delete_if { |k, v| !params_validation.has_key?(k) }

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

      response = @connection.post("#{API_ENDPOINT}#{api_uri}",
                                  validated_params,
                                  { "User-Agent" => "NUSBotgram/#{NUSBotgram::VERSION}",
                                    "Accept" => "application/json" })

      # response = @connection.post(:path => api_uri,
      #                             :query => validated_params,
      #                             :headers => { "User-Agent" => "NUSBotgram/#{NUSBotgram::VERSION}",
      #                                           "Accept" => "application/json" })

      # response = Typhoeus.post(
      #     "#{API_ENDPOINT}/#{api_uri}",
      #     body: validated_params,
      #     headers: {
      #         "User-Agent" => "NUSBotgram/#{NUSBotgram::VERSION}",
      #         "Accept" => "application/json"
      #     }
      # )

      ApiResponse.new(response)
    end

    def send_method(object_kind, params, strict_params_validation = {})
      params_validation = {
          chat_id: { required: true, class: [Fixnum] },
          reply_to_message_id: { required: false, class: [String] },
          reply_markup: { required: false, class: [
              NUSBotgram::DataTypes::ReplyKeyboardMarkup,
              NUSBotgram::DataTypes::ReplyKeyboardHide,
              NUSBotgram::DataTypes::ForceReply,
          ] }
      }

      response = api_request("send#{object_kind.to_s.capitalize}", params, strict_params_validation.merge(params_validation))

      NUSBotgram::DataTypes::Message.new(response.result)
    end
  end
end
