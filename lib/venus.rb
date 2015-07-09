require 'httparty'
require 'json'
require 'yaml'

require_relative 'nus_botgram'
require_relative 'model/models'

module NUSBotgram
  class Venus
    # Constant
    BOT_NAME = 'Venus'
    START_YEAR = 2015
    END_YEAR = 2016
    SEM = 1
    DAY_REGEX = /([a-zA-Z]{6,})/

    # Venus Bot's reply messages
    SEND_NUSMODS_URI_MESSAGE = "Okay! Please send me your NUSMods URL (eg. http://modsn.us/nusbots)"
    REGISTERED_NUSMODS_URI_MESSAGE = "Awesome! I have registered your NUSMods URL"
    INVALID_NUSMODS_URI_MESSAGE = "I'm afraid this is an invalid NUSMODS URL that I do not recognize."
    INVALID_NUSMODS_URI_CANCEL_MESSAGE = "I am cancelling this operation because I do not understand what to process."
    INVALID_NUSMODS_URI_RETRY_MESSAGE = "Please try again to '/setmodurl' with a correct NUSMods URL."
    RETRIEVE_TIMETABLE_MESSAGE = "Give me awhile, while I retrieve your timetable..."
    DISPLAY_MODULE_MESSAGE = "Alright! What module do you want me to display?"
    SEARCH_MODULES_MESSAGE = "Alright! What modules do you want to search?"
    GET_TIMETABLE_TODAY_MESSAGE = "Alright! Let's get you your schedule for today!"

    # Action types
    TYPING_ACTION = "typing"
    UNRECOGNIZED_COMMAND_RESPONSE = "Unrecognized command. Say what?"

    # Configuration & setup
    config = YAML.load_file("config/config.yml")
    sticker_collections = YAML.load_file("config/stickers.yml")
    bot = NUSBotgram::Bot.new(config[0][:T_BOT_APIKEY_DEV])
    engine = NUSBotgram::Core.new
    model = NUSBotgram::Models.new

    # Custom Regex Queries for dynamic command
    custom_today = ""

    bot.get_updates do |message|
      puts "In chat #{message.chat.id}, @#{message.from.first_name} > @#{message.from.id} said: #{message.text}"

      case message.text
        when /greet/i
          bot_reply = "Hello, #{message.from.first_name}!"

          bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: bot_reply)
        when /^hello$/
          bot_reply = "Hello, #{message.from.first_name}!"

          bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: bot_reply)
        when /^hi$/
          bot_reply = "Hello, #{message.from.first_name}!"

          bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: bot_reply)
        when /^hey$/
          bot_reply = "Hello, #{message.from.first_name}!"

          bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: bot_reply)
        when /^how is your day$/
          bot_reply = "I'm good. How about you?"

          bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: bot_reply)
        when /when is your birthday/i
          bot_reply = "30th June 2015"

          bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: bot_reply)
        when /^what do you want to do/i
          sticker_id = sticker_collections[0][:MARK_TWAIN_HUH]
          bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          bot_reply = "You tell me, what should I do?"

          bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: bot_reply)
        when /^you are awesome/i
          sticker_id = sticker_collections[0][:ABRAHAM_LINCOLN_APPROVES]
          bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          bot_reply = "Thanks! I know, my creator is awesome!"

          bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: bot_reply)
        when /who is your creator/i
          sticker_id = sticker_collections[0][:STEVE_JOBS_LAUGHS_OUT_LOUD]
          bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          bot_reply = "He is Kenneth Ham."

          bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: bot_reply)
        when /who built you/i
          sticker_id = sticker_collections[0][:STEVE_JOBS_LAUGHS_OUT_LOUD]
          bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          bot_reply = "He is Kenneth Ham."

          bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: bot_reply)
        when /^what time is it now/i
          now = Time.now.getlocal('+08:00').strftime("%H:%M GMT%z")

          bot_reply = "The time now is #{now}"

          bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: bot_reply)
        when /^what time now$/i
          now = Time.now.getlocal('+08:00').strftime("%H:%M GMT%z")

          bot_reply = "The time now is #{now}"

          bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: bot_reply)
        when /bye/i
          sticker_id = sticker_collections[0][:AUDREY_IS_ON_THE_VERGE_OF_TEARS]
          bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          bot_reply = "Bye? Will I see you again?"

          bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: bot_reply)
        when /ping$/i
          sticker_id = sticker_collections[0][:NIKOLA_TESLA_IS_UNIMPRESSED]
          bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          bot_reply = "[Sigh] Do I look like a computer to you?!"

          bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: bot_reply)
        when /shutdown$/i
          sticker_id = sticker_collections[0][:RICHARD_WAGNERS_TOLD_YOU]
          bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          bot_reply = "[Sigh] Tell me you didn't just try to shut me down..."

          bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: bot_reply)
        when /^\/time$/i
          now = Time.now.getlocal('+08:00').strftime("%H:%M GMT%z")

          bot_reply = "The time now is #{now}"

          bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: bot_reply)
        when /^\/now$/i
          now = Time.now.getlocal('+08:00').strftime("%H:%M GMT%z")

          bot_reply = "The time now is #{now}"

          bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: bot_reply)
        when /^\/poke$/i
          sticker_id = sticker_collections[0][:RICHARD_WAGNERS_TOLD_YOU]
          bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          bot_reply = "Aha- Don't try to be funny!"

          bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: bot_reply)
        when /^\/ping$/i
          sticker_id = sticker_collections[0][:NIKOLA_TESLA_IS_UNIMPRESSED]
          bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          bot_reply = "[Sigh] Do I look like a computer to you?!"

          bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: bot_reply)
        when /^\/crash$/i
          sticker_id = sticker_collections[0][:NIKOLA_TESLA_IS_UNIMPRESSED]
          bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          bot_reply = "Why do you have to be so mean?!"

          bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: bot_reply)
        when /^\/shutdown$/i
          sticker_id = sticker_collections[0][:RICHARD_WAGNERS_TOLD_YOU]
          bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          bot_reply = "[Sigh] Tell me you didn't just try to shut me down..."

          bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: bot_reply)
        when /^\/help$/i
          usage = "Hello! I am #{BOT_NAME}, I am your NUS personal assistant at your service! I can guide you around NUS, get your NUSMods timetable, and lots more!\n\nYou can control me by sending these commands:

                  /help - displays the usage commands
                  /setmodurl - sets your nusmods url
                  /listmods - find your modules
                  /getmod - retrieves a particular module
                  /today - retrieves today's timetable
                  /gettodaylec - retrieves today's lectures
                  /gettodaytut - retrieves today's tutorials
                  /gettodaylab - retrieves today's laboratory sessions
                  /gettodaysem - retrieves today's seminars
                  /nextclass - retrieves your next class
                  /setprivacy - protects your privacy
                  /cancel - cancel the current operation"

          bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: "#{usage}")
        when /^\/setmodurl$/i
          force_reply = NUSBotgram::DataTypes::ForceReply.new(force_reply: true, selective: true)
          bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: SEND_NUSMODS_URI_MESSAGE, reply_markup: force_reply)

          bot.update do |msg|
            mod_uri = msg.text
            telegram_id = msg.from.id

            status_code = engine.analyze_uri(mod_uri)

            if status_code == 200
              engine.set_mod(mod_uri, START_YEAR, END_YEAR, SEM, telegram_id)

              bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
              bot.send_message(chat_id: msg.chat.id, text: "#{REGISTERED_NUSMODS_URI_MESSAGE} @ #{mod_uri}", disable_web_page_preview: true)
            elsif status_code == 403 || status_code == 404
              bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
              bot.send_message(chat_id: msg.chat.id, text: INVALID_NUSMODS_URI_MESSAGE)

              bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
              bot.send_message(chat_id: msg.chat.id, text: INVALID_NUSMODS_URI_CANCEL_MESSAGE)

              bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
              bot.send_message(chat_id: msg.chat.id, text: INVALID_NUSMODS_URI_RETRY_MESSAGE)
            else
              bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
              bot.send_message(chat_id: msg.chat.id, text: INVALID_NUSMODS_URI_MESSAGE)

              bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
              bot.send_message(chat_id: msg.chat.id, text: INVALID_NUSMODS_URI_CANCEL_MESSAGE)

              bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
              bot.send_message(chat_id: msg.chat.id, text: INVALID_NUSMODS_URI_RETRY_MESSAGE)
            end
          end
        when /^\/listmods$/i
          if !engine.db_exist(message.from.id)
            force_reply = NUSBotgram::DataTypes::ForceReply.new(force_reply: true, selective: true)
            bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
            bot.send_message(chat_id: message.chat.id, text: SEND_NUSMODS_URI_MESSAGE, reply_markup: force_reply)

            bot.update do |msg|
              mod_uri = msg.text
              telegram_id = msg.from.id

              status_code = engine.analyze_uri(mod_uri)

              if status_code == 200
                engine.set_mod(mod_uri, START_YEAR, END_YEAR, SEM, telegram_id)

                bot.send_chat_action(chat_id: msg.chat.id, action: TYPING_ACTION)
                bot.send_message(chat_id: msg.chat.id, text: "#{REGISTERED_NUSMODS_URI_MESSAGE} @ #{mod_uri}", disable_web_page_preview: true)

                bot.send_chat_action(chat_id: msg.chat.id, action: TYPING_ACTION)
                bot.send_message(chat_id: msg.chat.id, text: RETRIEVE_TIMETABLE_MESSAGE)

                model.list_mods(telegram_id, bot, engine, msg)
              elsif status_code == 403 || status_code == 404
                bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
                bot.send_message(chat_id: msg.chat.id, text: INVALID_NUSMODS_URI_MESSAGE)

                bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
                bot.send_message(chat_id: msg.chat.id, text: INVALID_NUSMODS_URI_CANCEL_MESSAGE)

                bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
                bot.send_message(chat_id: msg.chat.id, text: INVALID_NUSMODS_URI_RETRY_MESSAGE)
              else
                bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
                bot.send_message(chat_id: msg.chat.id, text: INVALID_NUSMODS_URI_MESSAGE)

                bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
                bot.send_message(chat_id: msg.chat.id, text: INVALID_NUSMODS_URI_CANCEL_MESSAGE)

                bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
                bot.send_message(chat_id: msg.chat.id, text: INVALID_NUSMODS_URI_RETRY_MESSAGE)
              end
            end
          else
            telegram_id = message.from.id
            bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
            bot.send_message(chat_id: message.chat.id, text: RETRIEVE_TIMETABLE_MESSAGE)

            model.list_mods(telegram_id, bot, engine, message)
          end
        when /^\/getmod$/i
          mods_ary = Array.new

          if !engine.db_exist(message.from.id)
            force_reply = NUSBotgram::DataTypes::ForceReply.new(force_reply: true, selective: true)
            bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
            bot.send_message(chat_id: message.chat.id, text: SEND_NUSMODS_URI_MESSAGE, reply_markup: force_reply)

            bot.update do |msg|
              mod_uri = msg.text
              telegram_id = msg.from.id

              status_code = engine.analyze_uri(mod_uri)

              if status_code == 200
                engine.set_mod(mod_uri, START_YEAR, END_YEAR, SEM, telegram_id)

                bot.send_chat_action(chat_id: msg.chat.id, action: TYPING_ACTION)
                bot.send_message(chat_id: msg.chat.id, text: "#{REGISTERED_NUSMODS_URI_MESSAGE} @ #{mod_uri}", disable_web_page_preview: true)

                bot.send_chat_action(chat_id: msg.chat.id, action: TYPING_ACTION)
                bot.send_message(chat_id: msg.chat.id, text: DISPLAY_MODULE_MESSAGE, reply_markup: force_reply)

                bot.update do |mod|
                  model.get_mod(telegram_id, bot, engine, mods_ary, mod, sticker_collections)
                end
              elsif status_code == 403 || status_code == 404
                bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
                bot.send_message(chat_id: msg.chat.id, text: INVALID_NUSMODS_URI_MESSAGE)

                bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
                bot.send_message(chat_id: msg.chat.id, text: INVALID_NUSMODS_URI_CANCEL_MESSAGE)

                bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
                bot.send_message(chat_id: msg.chat.id, text: INVALID_NUSMODS_URI_RETRY_MESSAGE)
              else
                bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
                bot.send_message(chat_id: msg.chat.id, text: INVALID_NUSMODS_URI_MESSAGE)

                bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
                bot.send_message(chat_id: msg.chat.id, text: INVALID_NUSMODS_URI_CANCEL_MESSAGE)

                bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
                bot.send_message(chat_id: msg.chat.id, text: INVALID_NUSMODS_URI_RETRY_MESSAGE)
              end
            end
          else
            telegram_id = message.from.id
            force_reply = NUSBotgram::DataTypes::ForceReply.new(force_reply: true, selective: true)
            bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
            bot.send_message(chat_id: message.chat.id, text: SEARCH_MODULES_MESSAGE, reply_markup: force_reply)

            bot.update do |msg|
              model.get_mod(telegram_id, bot, engine, mods_ary, msg, sticker_collections)
            end
          end
        when /(^\/today$|^\/today #{custom_today})/
          custom_today = message.text.sub!("/today", "").strip

          if custom_today.eql?("") || custom_today == ""
            day_of_week_regex = /\b(Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)\b/
            day_today = Time.now.strftime("%A")
            days_ary = Array.new

            if !engine.db_exist(message.from.id)
              force_reply = NUSBotgram::DataTypes::ForceReply.new(force_reply: true, selective: true)
              bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
              bot.send_message(chat_id: message.chat.id, text: SEND_NUSMODS_URI_MESSAGE, reply_markup: force_reply)

              bot.update do |msg|
                mod_uri = msg.text
                telegram_id = msg.from.id

                status_code = engine.analyze_uri(mod_uri)

                if status_code == 200
                  engine.set_mod(mod_uri, START_YEAR, END_YEAR, SEM, telegram_id)

                  bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
                  bot.send_message(chat_id: msg.chat.id, text: "#{REGISTERED_NUSMODS_URI_MESSAGE} @ #{mod_uri}", disable_web_page_preview: true)

                  bot.send_chat_action(chat_id: msg.chat.id, action: TYPING_ACTION)
                  bot.send_message(chat_id: msg.chat.id, text: GET_TIMETABLE_TODAY_MESSAGE)

                  customized_message = "Yay! It's YOUR free day! Hang around and chill with me!"
                  model.get_today(telegram_id, bot, engine, day_today, days_ary, message, customized_message, sticker_collections)
                elsif status_code == 403 || status_code == 404
                  bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
                  bot.send_message(chat_id: msg.chat.id, text: INVALID_NUSMODS_URI_MESSAGE)

                  bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
                  bot.send_message(chat_id: msg.chat.id, text: INVALID_NUSMODS_URI_CANCEL_MESSAGE)

                  bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
                  bot.send_message(chat_id: msg.chat.id, text: INVALID_NUSMODS_URI_RETRY_MESSAGE)
                else
                  bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
                  bot.send_message(chat_id: msg.chat.id, text: INVALID_NUSMODS_URI_MESSAGE)

                  bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
                  bot.send_message(chat_id: msg.chat.id, text: INVALID_NUSMODS_URI_CANCEL_MESSAGE)

                  bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
                  bot.send_message(chat_id: msg.chat.id, text: INVALID_NUSMODS_URI_RETRY_MESSAGE)
                end
              end
            else
              telegram_id = message.from.id
              bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
              bot.send_message(chat_id: message.chat.id, text: GET_TIMETABLE_TODAY_MESSAGE)

              customized_message = "Yay! It's YOUR free day! Hang around and chill with me!"
              model.get_today(telegram_id, bot, engine, day_today, days_ary, message, customized_message, sticker_collections)
            end
          elsif custom_today.downcase.eql?("lec") || custom_today.downcase.eql?("lecture")
            day_today = Time.now.strftime("%A")
            days_ary = Array.new
            mods_ary = Array.new
            lesson_type = "Lecture"

            if !engine.db_exist(message.from.id)
              force_reply = NUSBotgram::DataTypes::ForceReply.new(force_reply: true, selective: true)
              bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
              bot.send_message(chat_id: message.chat.id, text: SEND_NUSMODS_URI_MESSAGE, reply_markup: force_reply)

              bot.update do |msg|
                mod_uri = msg.text
                telegram_id = msg.from.id

                status = engine.set_mod(mod_uri, START_YEAR, END_YEAR, SEM, telegram_id)

                if status == 404 || status.eql?("404")
                  bot.send_chat_action(chat_id: msg.chat.id, action: TYPING_ACTION)
                  bot.send_message(chat_id: msg.chat.id, text: INVALID_NUSMODS_URI_MESSAGE)
                else
                  bot.send_chat_action(chat_id: msg.chat.id, action: TYPING_ACTION)
                  bot.send_message(chat_id: msg.chat.id, text: "#{REGISTERED_NUSMODS_URI_MESSAGE} @ #{mod_uri}", disable_web_page_preview: true)

                  bot.send_chat_action(chat_id: msg.chat.id, action: TYPING_ACTION)
                  bot.send_message(chat_id: msg.chat.id, text: GET_TIMETABLE_TODAY_MESSAGE)

                  model.get_today_pattern(telegram_id, bot, engine, day_today, lesson_type, days_ary, mods_ary, msg, sticker_collections)
                end
              end
            else
              telegram_id = message.from.id
              bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
              bot.send_message(chat_id: message.chat.id, text: GET_TIMETABLE_TODAY_MESSAGE)

              model.get_today_pattern(telegram_id, bot, engine, day_today, lesson_type, days_ary, mods_ary, message, sticker_collections)
            end
          end
        when /^\/gettodaytut$/i
          bot.send_message(chat_id: message.chat.id, text: "Operation not implemented yet")
        when /^\/gettodaylab$/i
          bot.send_message(chat_id: message.chat.id, text: "Operation not implemented yet")
        when /^\/gettodaysem$/i
          bot.send_message(chat_id: message.chat.id, text: "Operation not implemented yet")
        when /^\/nextclass$/i
          bot.send_message(chat_id: message.chat.id, text: "Operation not implemented yet")
        when /^\/setprivacy$/i
          bot.send_message(chat_id: message.chat.id, text: "Operation not implemented yet")
        when /^\/cancel$/i
          bot.send_message(chat_id: message.chat.id, text: "Operation not implemented yet")
        when /^\/start$/i
          question = 'This is an awesome message?'
          answers = NUSBotgram::DataTypes::ReplyKeyboardMarkup.new(keyboard: [%w(YES), %w(NO)], one_time_keyboard: true)
          bot.send_message(chat_id: message.chat.id, text: question, reply_markup: answers)
        when /^\/stop$/i
          kb = NUSBotgram::DataTypes::ReplyKeyboardHide.new(hide_keyboard: true)
          bot.send_message(chat_id: message.chat.id, text: 'Thank you for your honesty!', reply_markup: kb)
        when /where is subway at utown/i
          loc = NUSBotgram::DataTypes::Location.new(latitude: 1.3036985632674172, longitude: 103.77380311489104)
          bot.send_location(chat_id: message.chat.id, latitude: loc.latitude, longitude: loc.longitude)
        when /^\/([a-zA-Z]|\d+)/
          sticker_id = sticker_collections[0][:THAT_FREUDIAN_SCOWL]
          bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          bot.send_chat_action(chat_id: message.chat.id, action: TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: UNRECOGNIZED_COMMAND_RESPONSE)
      end
    end
  end
end