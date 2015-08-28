module NUSBotgram
  class BaseBot
    def initialize
    end

    public

    def submit_nusmods_url(envelope)

    end

    public

    def cancel_nusmods_submit(envelope)

    end

    public

    def registered_nusmods(envelope, mod_uri)

    end

    public

    def retry_nusmods_message(envelope)

    end

    public

    def normal_reply_message(envelope, message)
      puts message
    end

    public

    def completed_task_message(envelope)

    end

    public

    def invalid_url_message(enevelope, sticker_collections)

    end

    public

    def today_saturday_message(envelope, sticker_collections)

    end

    public

    def today_sunday_message(envelope, sticker_collections)

    end

    public

    def today_freeday_message(envelope, sticker_collections)

    end

    public

    def today_completed_ckb_message(envelope)

    end

    public

    def today_freeclass_message(envelope, message, sticker_collections)

    end

    public

    def get_today_timetable_message(envelope)

    end

    public

    def no_class_message(message, sticker_collections)

    end
  end
end