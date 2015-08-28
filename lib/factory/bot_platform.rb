module NUSBotgram
  class BotPlatform
    def initialize(factory)
      @factory = factory
    end

    def add_telegram(bot)
      @factory.create_tbot(bot)
    end

    def add_web(bot)
      @factory.create_wbot(bot)
    end

    def submit_nusmods_url(envelope)
      @factory.submit_nusmods_url(envelope)
    end

    def cancel_nusmods_submit(envelope)
      @factory.cancel_nusmods_submit(envelope)
    end

    def registered_nusmods(envelope, mod_uri)
      @factory.registered_nusmods(envelope, mod_uri)
    end

    def retry_nusmods_message(envelope)
      @factory.retry_nusmods_message(envelope)
    end

    def normal_reply_message(envelope, message)
      @factory.normal_reply_message(envelope, message)
    end

    def completed_task_message(envelope)
      @factory.completed_task_message(envelope)
    end

    def invalid_url_message(enevelope, sticker_collections)
      @factory.invalid_url_message(enevelope, sticker_collections)
    end

    def today_saturday_message(envelope, sticker_collections)
      @factory.today_saturday_message(envelope, sticker_collections)
    end

    def today_sunday_message(envelope, sticker_collections)
      @factory.today_sunday_message(envelope, sticker_collections)
    end

    def today_freeday_message(envelope, sticker_collections)
      @factory.today_freeday_message(envelope, sticker_collections)
    end

    def today_completed_ckb_message(envelope)
      @factory.today_completed_ckb_message(envelope)
    end

    def today_freeclass_message(envelope, message, sticker_collections)
      @factory.today_freeclass_message(envelope, message, sticker_collections)
    end

    def get_today_timetable_message(envelope)
      @factory.get_today_timetable_message(envelope)
    end

    def no_class_message(envelope, sticker_collections)
      @factory.no_class_message(envelope, sticker_collections)
    end
  end
end