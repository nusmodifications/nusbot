require_relative 't_bot'

module NUSBotgram
  class BotFactory
    def create_tbot(bot)
      @bot = NUSBotgram::TBot.new(bot)
    end

    def create_wbot(bot)

    end

    def submit_nusmods_url(envelope)
      @bot.submit_nusmods_url(envelope)
    end

    def cancel_nusmods_submit(envelope)
      @bot.cancel_nusmods_submit(envelope)
    end

    def registered_nusmods(envelope, mod_uri)
      @bot.registered_nusmods(envelope, mod_uri)
    end

    def retry_nusmods_message(envelope)
      @bot.retry_nusmods_message(envelope)
    end

    def normal_reply_message(envelope, message)
      @bot.normal_reply_message(envelope, message)
    end

    def completed_task_message(envelope)
      @bot.completed_task_message(envelope)
    end

    def invalid_url_message(enevelope, sticker_collections)
      @bot.invalid_url_message(enevelope, sticker_collections)
    end

    def today_saturday_message(envelope, sticker_collections)
      @bot.today_saturday_message(envelope, sticker_collections)
    end

    def today_sunday_message(envelope, sticker_collections)
      @bot.today_sunday_message(envelope, sticker_collections)
    end

    def today_freeday_message(envelope, sticker_collections)
      @bot.today_freeday_message(envelope, sticker_collections)
    end

    def today_completed_ckb_message(envelope)
      @bot.today_completed_ckb_message(envelope)
    end

    def today_freeclass_message(envelope, message, sticker_collections)
      @bot.today_freeclass_message(envelope, message, sticker_collections)
    end

    def get_today_timetable_message(envelope)
      @bot.get_today_timetable_message(envelope)
    end

    def no_class_message(envelope, sticker_collections)
      @bot.no_class_message(envelope, sticker_collections)
    end
  end
end