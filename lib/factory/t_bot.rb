require_relative '../config/global'
require_relative 'base_bot'

module NUSBotgram
  class TBot < BaseBot
    attr_reader :bot

    def initialize(bot)
      @bot = bot
    end

    public

    def submit_nusmods_url(envelope)
      force_reply = NUSBotgram::DataTypes::ForceReply.new(force_reply: true, selective: true)

      bot.send_chat_action(chat_id: envelope.chat.id, action: Global::TYPING_ACTION)
      bot.send_message(chat_id: envelope.chat.id, text: Global::SEND_NUSMODS_URI_MESSAGE, reply_markup: force_reply)
    end

    public

    def cancel_nusmods_submit(envelope)
      bot.send_chat_action(chat_id: envelope.chat.id, action: Global::TYPING_ACTION)
      bot.send_message(chat_id: envelope.chat.id, text: Global::BOT_SETMODURL_CANCEL)

      bot.send_chat_action(chat_id: envelope.chat.id, action: Global::TYPING_ACTION)
      bot.send_message(chat_id: envelope.chat.id, text: Global::BOT_CANCEL_MESSAGE)
    end

    public

    def registered_nusmods(envelope, mod_uri)
      bot.send_chat_action(chat_id: envelope.chat.id, action: Global::TYPING_ACTION)
      bot.send_message(chat_id: envelope.chat.id, text: "#{Global::REGISTERED_NUSMODS_URI_MESSAGE} @ #{mod_uri}", disable_web_page_preview: true)


      bot.send_chat_action(chat_id: envelope.chat.id, action: Global::TYPING_ACTION)
      bot.send_message(chat_id: envelope.chat.id, text: Global::GET_TIMETABLE_TODAY_MESSAGE)
    end

    public

    def retry_nusmods_message(envelope)
      bot.send_chat_action(chat_id: envelope.chat.id, action: Global::TYPING_ACTION)
      bot.send_message(chat_id: envelope.chat.id, text: Global::INVALID_NUSMODS_URI_MESSAGE)

      bot.send_chat_action(chat_id: envelope.chat.id, action: Global::TYPING_ACTION)
      bot.send_message(chat_id: envelope.chat.id, text: Global::NUSMODS_URI_CANCEL_MESSAGE)

      bot.send_chat_action(chat_id: envelope.chat.id, action: Global::TYPING_ACTION)
      bot.send_message(chat_id: envelope.chat.id, text: Global::NUSMODS_URI_RETRY_MESSAGE)
    end

    public

    def normal_reply_message(envelope, message)
      bot.send_chat_action(chat_id: envelope.chat.id, action: Global::TYPING_ACTION)
      bot.send_message(chat_id: envelope.chat.id, text: "#{message}")
    end

    public

    def completed_task_message(envelope)
      bot.send_chat_action(chat_id: envelope.chat.id, action: Global::TYPING_ACTION)
      bot.send_message(chat_id: envelope.chat.id, text: "There you go, #{envelope.from.first_name}!")
    end

    public

    def invalid_url_message(enevelope, sticker_collections)
      bot.send_chat_action(chat_id: enevelope.chat.id, action: Global::TYPING_ACTION)
      sticker_id = sticker_collections[0][:NIKOLA_TESLA_IS_UNIMPRESSED]
      bot.send_sticker(chat_id: enevelope.chat.id, sticker: sticker_id)

      bot.send_chat_action(chat_id: enevelope.chat.id, action: Global::TYPING_ACTION)
      bot.send_message(chat_id: enevelope.chat.id, text: Global::INVALID_NUSMODS_URI_MESSAGE)

      bot.send_chat_action(chat_id: enevelope.chat.id, action: Global::TYPING_ACTION)
      bot.send_message(chat_id: enevelope.chat.id, text: Global::NUSMODS_URI_CANCEL_MESSAGE)

      bot.send_chat_action(chat_id: enevelope.chat.id, action: Global::TYPING_ACTION)
      bot.send_message(chat_id: enevelope.chat.id, text: Global::NUSMODS_URI_RETRY_MESSAGE)

      bot.send_chat_action(chat_id: enevelope.chat.id, action: Global::TYPING_ACTION)
      bot.send_message(chat_id: enevelope.chat.id, text: "Please try again, #{enevelope.from.first_name}!")
    end

    public

    def today_saturday_message(envelope, sticker_collections)
      close_keyboard = NUSBotgram::DataTypes::ReplyKeyboardHide.new(hide_keyboard: true)

      bot.send_chat_action(chat_id: envelope.chat.id, action: Global::TYPING_ACTION)
      sticker_id = sticker_collections[0][:ONE_DOESNT_SIMPLY_SEND_A_TOLKIEN_STICKER]
      bot.send_sticker(chat_id: envelope.chat.id, sticker: sticker_id)

      bot.send_chat_action(chat_id: envelope.chat.id, action: Global::TYPING_ACTION)
      bot.send_message(chat_id: envelope.chat.id, text: Global::NSATURDAY_RESPONSE, reply_markup: close_keyboard)
    end

    public

    def today_sunday_message(envelope, sticker_collections)
      close_keyboard = NUSBotgram::DataTypes::ReplyKeyboardHide.new(hide_keyboard: true)

      bot.send_chat_action(chat_id: envelope.chat.id, action: Global::TYPING_ACTION)
      sticker_id = sticker_collections[0][:NIKOLA_TESLA_IS_UNIMPRESSED]
      bot.send_sticker(chat_id: envelope.chat.id, sticker: sticker_id)

      bot.send_chat_action(chat_id: envelope.chat.id, action: Global::TYPING_ACTION)
      bot.send_message(chat_id: envelope.chat.id, text: Global::NSUNDAY_RESPONSE)

      bot.send_chat_action(chat_id: envelope.chat.id, action: Global::TYPING_ACTION)
      bot.send_message(chat_id: envelope.chat.id, text: Global::NSUNDAY_RESPONSE_END, reply_markup: close_keyboard)
    end

    public

    def today_freeday_message(envelope, sticker_collections)
      close_keyboard = NUSBotgram::DataTypes::ReplyKeyboardHide.new(hide_keyboard: true)

      bot.send_chat_action(chat_id: envelope.chat.id, action: Global::TYPING_ACTION)
      sticker_id = sticker_collections[0][:ABRAHAM_LINCOLN_APPROVES]
      bot.send_sticker(chat_id: envelope.chat.id, sticker: sticker_id)

      bot.send_chat_action(chat_id: envelope.chat.id, action: Global::TYPING_ACTION)
      bot.send_message(chat_id: envelope.chat.id, text: Global::FREEDAY_RESPONSE, reply_markup: close_keyboard)
    end

    public

    def today_completed_ckb_message(envelope)
      close_keyboard = NUSBotgram::DataTypes::ReplyKeyboardHide.new(hide_keyboard: true)

      bot.send_chat_action(chat_id: envelope.chat.id, action: Global::TYPING_ACTION)
      bot.send_message(chat_id: envelope.chat.id, text: "There you go, #{envelope.from.first_name}!", reply_markup: close_keyboard)
    end

    public

    def today_freeclass_message(envelope, message, sticker_collections)
      close_keyboard = NUSBotgram::DataTypes::ReplyKeyboardHide.new(hide_keyboard: true)

      bot.send_chat_action(chat_id: envelope.chat.id, action: Global::TYPING_ACTION)
      sticker_id = sticker_collections[0][:ABRAHAM_LINCOLN_APPROVES]
      bot.send_sticker(chat_id: envelope.chat.id, sticker: sticker_id)

      bot.send_chat_action(chat_id: envelope.chat.id, action: Global::TYPING_ACTION)
      bot.send_message(chat_id: envelope.chat.id, text: message, reply_markup: close_keyboard)
    end

    public

    def get_today_timetable_message(envelope)
      bot.send_chat_action(chat_id: envelope.chat.id, action: Global::TYPING_ACTION)
      bot.send_message(chat_id: envelope.chat.id, text: Global::GET_TIMETABLE_TODAY_MESSAGE)
    end

    public

    def no_class_message(envelope, sticker_collections)
      sticker_id = sticker_collections[0][:LOL_MARLEY]
      bot.send_sticker(chat_id: envelope.chat.id, sticker: sticker_id)

      bot.send_chat_action(chat_id: envelope.chat.id, action: Global::TYPING_ACTION)
      bot.send_message(chat_id: envelope.chat.id, text: Global::NEXT_CLASS_NULL_MESSAGE)
    end
  end
end