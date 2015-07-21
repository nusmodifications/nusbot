require 'httparty'
require 'json'
require 'yaml'

require_relative 'lib/nus_botgram'

module NUSBotgram
  class Venus
    # Configuration & setup
    CONFIG = YAML.load_file("lib/config/config.yml")
    STICKER_COLLECTIONS = YAML.load_file("lib/config/stickers.yml")

    bot = NUSBotgram::Bot.new(CONFIG[0][:T_BOT_APIKEY_DEV])
    engine = NUSBotgram::Core.new
    models = NUSBotgram::Models.new

    # Custom Regex Queries for dynamic command
    custom_today = ""
    custom_location = ""

    bot.get_updates do |message|
      time_now = Time.now.getlocal('+08:00')

      engine.save_message_history(message.from.id, 1, message.chat.id, message.message_id, message.from.first_name, message.from.last_name, message.from.username, message.from.id, message.date, message.text)
      puts "In chat #{message.chat.id}, @#{message.from.first_name} > @#{message.from.id} said: #{message.text}"

      engine.save_state_transactions(message.from.id, message.text, message.message_id)

      case message.text
        when /greet/i
          begin
            telegram_id = message.from.id
            command = message.text
            message_id = message.message_id
            recv_date = Time.parse(message.date.to_s)

            time_diff = (time_now.to_i - recv_date.to_i) / 60
            last_state = engine.get_state_transactions(telegram_id, command)

            if time_diff <= Global::X_MINUTES
              bot_reply = "Hello, #{message.from.first_name}!"

              bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
              bot.send_message(chat_id: message.chat.id, text: bot_reply)
              engine.save_state_transactions(telegram_id, command, message_id)
            elsif time_diff >= Global::X_MINUTES && time_diff <= Global::X_MINUTES_BUFFER
              bot_reply = "Hello, #{message.from.first_name}!"

              bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
              bot.send_message(chat_id: message.chat.id, text: bot_reply, reply_to_message_id: last_state.to_s)
              engine.remove_state_transactions(telegram_id, command)
            end
          rescue NUSBotgram::Errors::ServiceUnavailableError
            sticker_id = STICKER_COLLECTIONS[0][:NIKOLA_TESLA_IS_UNIMPRESSED]
            bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
            bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

            bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
            bot.send_message(chat_id: message.chat.id, text: Global::BOT_SERVICE_OFFLINE)
          end
        when /^hello$/
          bot_reply = "Hello, #{message.from.first_name}!"

          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: bot_reply)
        when /^hi$/
          bot_reply = "Hello, #{message.from.first_name}!"

          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: bot_reply)
        when /^hey$/
          bot_reply = "Hello, #{message.from.first_name}!"

          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: bot_reply)
        when /^how is your day$/
          bot_reply = "I'm good. How about you?"

          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: bot_reply)
        when /when is your birthday/i
          bot_reply = "30th June 2015"

          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: bot_reply)
        when /^what do you want to do/i
          sticker_id = STICKER_COLLECTIONS[0][:MARK_TWAIN_HUH]
          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          bot_reply = "You tell me, what should I do?"

          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: bot_reply)
        when /^you are awesome/i
          sticker_id = STICKER_COLLECTIONS[0][:ABRAHAM_LINCOLN_APPROVES]
          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          bot_reply = "Thanks! I know, my creator is awesome!"

          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: bot_reply)
        when /who is your creator/i
          sticker_id = STICKER_COLLECTIONS[0][:STEVE_JOBS_LAUGHS_OUT_LOUD]
          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          bot_reply = "He is Kenneth Ham."

          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: bot_reply)
        when /who built you/i
          sticker_id = STICKER_COLLECTIONS[0][:STEVE_JOBS_LAUGHS_OUT_LOUD]
          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          bot_reply = "He is Kenneth Ham."

          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: bot_reply)
        when /^what time is it now/i
          now = Time.now.getlocal('+08:00').strftime("%H:%M GMT%z")

          bot_reply = "The time now is #{now}"

          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: bot_reply)
        when /^what time now$/i
          now = Time.now.getlocal('+08:00').strftime("%H:%M GMT%z")

          bot_reply = "The time now is #{now}"

          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: bot_reply)
        when /bye/i
          sticker_id = STICKER_COLLECTIONS[0][:AUDREY_IS_ON_THE_VERGE_OF_TEARS]
          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          bot_reply = "Bye? Will I see you again?"

          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: bot_reply)
        when /ping$/i
          sticker_id = STICKER_COLLECTIONS[0][:NIKOLA_TESLA_IS_UNIMPRESSED]
          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          bot_reply = "[Sigh] Do I look like a computer to you?!"

          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: bot_reply)
        when /shutdown$/i
          sticker_id = STICKER_COLLECTIONS[0][:RICHARD_WAGNERS_TOLD_YOU]
          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          bot_reply = "[Sigh] Tell me you didn't just try to shut me down..."

          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: bot_reply)
        when /^\/time$/i
          now = Time.now.getlocal('+08:00').strftime("%H:%M GMT%z")

          bot_reply = "The time now is #{now}"

          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: bot_reply)
        when /^\/now$/i
          now = Time.now.getlocal('+08:00').strftime("%H:%M GMT%z")

          bot_reply = "The time now is #{now}"

          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: bot_reply)
        when /^\/poke$/i
          sticker_id = STICKER_COLLECTIONS[0][:RICHARD_WAGNERS_TOLD_YOU]
          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          bot_reply = "Aha- Don't try to be funny!"

          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: bot_reply)
        when /^\/ping$/i
          sticker_id = STICKER_COLLECTIONS[0][:NIKOLA_TESLA_IS_UNIMPRESSED]
          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          bot_reply = "[Sigh] Do I look like a computer to you?!"

          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: bot_reply)
        when /^\/crash$/i
          sticker_id = STICKER_COLLECTIONS[0][:NIKOLA_TESLA_IS_UNIMPRESSED]
          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          bot_reply = "Why do you have to be so mean?!"

          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: bot_reply)
        when /^\/shutdown$/i
          sticker_id = STICKER_COLLECTIONS[0][:RICHARD_WAGNERS_TOLD_YOU]
          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          bot_reply = "[Sigh] Tell me you didn't just try to shut me down..."

          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: bot_reply)
        when /^\/help$/i
          begin
            telegramid = message.from.id
            command = message.text
            message_id = message.message_id
            recv_date = Time.parse(message.date.to_s)
            usage = "Hello! I am #{Global::BOT_NAME}, I am your NUS personal assistant at your service! I can guide you around NUS, get your NUSMods timetable, and lots more!\n\nYou can control me by sending these commands:\n\n/setmodurl - sets your nusmods url\n/listmods - list your modules\n/getmod - get a particular module\n/today - get your schedule for today\n/todayme - guide to get today's schedule\n/nextclass - get your next class schedule\n/setprivacy - protects your privacy\n/cancel - cancel the current operation"

            time_diff = (time_now.to_i - recv_date.to_i) / 60
            last_state = engine.get_state_transactions(telegramid, command)

            if time_diff <= Global::X_MINUTES
              bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
              bot.send_message(chat_id: message.chat.id, text: "#{usage}")
            elsif time_diff > Global::X_MINUTES && time_diff <= Global::X_MINUTES_BUFFER
              bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
              bot.send_message(chat_id: message.chat.id, text: "#{usage}", reply_to_message_id: last_state.to_s)
            end
          rescue NUSBotgram::Errors::ServiceUnavailableError
            sticker_id = STICKER_COLLECTIONS[0][:NIKOLA_TESLA_IS_UNIMPRESSED]
            bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
            bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

            bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
            bot.send_message(chat_id: message.chat.id, text: Global::BOT_SERVICE_OFFLINE)
          end
        when /^\/setmodurl$/i
          begin
            telegramid = message.from.id
            command = message.text
            message_id = message.message_id
            recv_date = Time.parse(message.date.to_s)

            time_diff = (time_now.to_i - recv_date.to_i) / 60
            last_state = engine.get_state_transactions(telegramid, command)

            if time_diff <= Global::X_MINUTES
              engine.save_last_transaction(telegramid, message_id)

              force_reply = NUSBotgram::DataTypes::ForceReply.new(force_reply: true, selective: true)
              bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
              bot.send_message(chat_id: message.chat.id, text: Global::SEND_NUSMODS_URI_MESSAGE, reply_markup: force_reply)

              bot.update do |msg|
                mod_uri = msg.text
                telegram_id = msg.from.id

                if mod_uri =~ /^\/cancel$/i
                  engine.cancel_last_transaction(telegram_id)
                  engine.remove_state_transactions(telegram_id, Global::SETMODURL)

                  bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                  bot.send_message(chat_id: msg.chat.id, text: Global::BOT_SETMODURL_CANCEL)

                  bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                  bot.send_message(chat_id: msg.chat.id, text: Global::BOT_CANCEL_MESSAGE)
                else
                  status_code = engine.analyze_uri(mod_uri)

                  if status_code == 200
                    engine.set_mod(mod_uri, Global::START_YEAR, Global::END_YEAR, Global::SEM, telegram_id)

                    bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                    bot.send_message(chat_id: msg.chat.id, text: "#{Global::REGISTERED_NUSMODS_URI_MESSAGE} @ #{mod_uri}", disable_web_page_preview: true)

                    engine.remove_state_transactions(telegram_id, Global::SETMODURL)
                  elsif status_code == 403 || status_code == 404
                    bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                    bot.send_message(chat_id: msg.chat.id, text: Global::INVALID_NUSMODS_URI_MESSAGE)

                    bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                    bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_CANCEL_MESSAGE)

                    bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                    bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_RETRY_MESSAGE)
                  else
                    bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                    bot.send_message(chat_id: msg.chat.id, text: Global::INVALID_NUSMODS_URI_MESSAGE)

                    bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                    bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_CANCEL_MESSAGE)

                    bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                    bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_RETRY_MESSAGE)
                  end
                end
              end
            elsif time_diff > Global::X_MINUTES && time_diff <= Global::X_MINUTES_BUFFER
              engine.save_last_transaction(telegramid, message_id)

              force_reply = NUSBotgram::DataTypes::ForceReply.new(force_reply: true, selective: true)
              bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
              bot.send_message(chat_id: message.chat.id, text: Global::SEND_NUSMODS_URI_MESSAGE, reply_markup: force_reply, reply_to_message_id: last_state.to_s)

              bot.update do |msg|
                mod_uri = msg.text
                telegram_id = msg.from.id

                if mod_uri =~ /^\/cancel$/i
                  engine.cancel_last_transaction(telegram_id)
                  engine.remove_state_transactions(telegram_id, Global::SETMODURL)

                  bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                  bot.send_message(chat_id: msg.chat.id, text: Global::BOT_SETMODURL_CANCEL)

                  bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                  bot.send_message(chat_id: msg.chat.id, text: Global::BOT_CANCEL_MESSAGE)
                else
                  status_code = engine.analyze_uri(mod_uri)

                  if status_code == 200
                    engine.set_mod(mod_uri, Global::START_YEAR, Global::END_YEAR, Global::SEM, telegram_id)

                    bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                    bot.send_message(chat_id: msg.chat.id, text: "#{Global::REGISTERED_NUSMODS_URI_MESSAGE} @ #{mod_uri}", disable_web_page_preview: true, reply_to_message_id: last_state.to_s)

                    engine.remove_state_transactions(telegram_id, Global::SETMODURL)
                  elsif status_code == 403 || status_code == 404
                    bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                    bot.send_message(chat_id: msg.chat.id, text: Global::INVALID_NUSMODS_URI_MESSAGE, reply_to_message_id: last_state.to_s)

                    bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                    bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_CANCEL_MESSAGE, reply_to_message_id: last_state.to_s)

                    bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                    bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_RETRY_MESSAGE, reply_to_message_id: last_state.to_s)
                  else
                    bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                    bot.send_message(chat_id: msg.chat.id, text: Global::INVALID_NUSMODS_URI_MESSAGE, reply_to_message_id: last_state.to_s)

                    bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                    bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_CANCEL_MESSAGE, reply_to_message_id: last_state.to_s)

                    bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                    bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_RETRY_MESSAGE, reply_to_message_id: last_state.to_s)
                  end
                end
              end
            end
          rescue NUSBotgram::Errors::ServiceUnavailableError
            sticker_id = STICKER_COLLECTIONS[0][:NIKOLA_TESLA_IS_UNIMPRESSED]
            bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
            bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

            bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
            bot.send_message(chat_id: message.chat.id, text: Global::BOT_SERVICE_OFFLINE)
          end
        when /^\/listmods$/i
          begin
            telegramid = message.from.id
            command = message.text
            message_id = message.message_id
            recv_date = Time.parse(message.date.to_s)

            time_diff = (time_now.to_i - recv_date.to_i) / 60
            last_state = engine.get_state_transactions(telegramid, command)

            if time_diff <= Global::X_MINUTES
              if !engine.db_exist(telegramid)
                force_reply = NUSBotgram::DataTypes::ForceReply.new(force_reply: true, selective: true)
                bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
                bot.send_message(chat_id: message.chat.id, text: Global::SEND_NUSMODS_URI_MESSAGE, reply_markup: force_reply)

                bot.update do |msg|
                  mod_uri = msg.text
                  telegram_id = msg.from.id

                  if mod_uri =~ /^\/cancel$/i
                    engine.cancel_last_transaction(telegram_id)
                    engine.remove_state_transactions(telegram_id, Global::SETMODURL)

                    bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                    bot.send_message(chat_id: msg.chat.id, text: Global::BOT_SETMODURL_CANCEL)

                    bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                    bot.send_message(chat_id: msg.chat.id, text: Global::BOT_CANCEL_MESSAGE)
                  else
                    status_code = engine.analyze_uri(mod_uri)

                    if status_code == 200
                      engine.set_mod(mod_uri, Global::START_YEAR, Global::END_YEAR, Global::SEM, telegram_id)

                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: "#{Global::REGISTERED_NUSMODS_URI_MESSAGE} @ #{mod_uri}", disable_web_page_preview: true)

                      engine.remove_state_transactions(telegram_id, Global::SETMODURL)

                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::RETRIEVE_TIMETABLE_MESSAGE)

                      models.list_mods(telegram_id, bot, engine, msg)
                    elsif status_code == 403 || status_code == 404
                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::INVALID_NUSMODS_URI_MESSAGE)

                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_CANCEL_MESSAGE)

                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_RETRY_MESSAGE)
                    else
                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::INVALID_NUSMODS_URI_MESSAGE)

                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_CANCEL_MESSAGE)

                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_RETRY_MESSAGE)
                    end
                  end
                end
              else
                telegram_id = message.from.id
                bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
                bot.send_message(chat_id: message.chat.id, text: Global::RETRIEVE_TIMETABLE_MESSAGE)

                models.list_mods(telegram_id, bot, engine, message)
              end
            elsif time_diff > Global::X_MINUTES && time_diff <= Global::X_MINUTES_BUFFER
              if !engine.db_exist(telegramid)
                force_reply = NUSBotgram::DataTypes::ForceReply.new(force_reply: true, selective: true)
                bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
                bot.send_message(chat_id: message.chat.id, text: Global::SEND_NUSMODS_URI_MESSAGE, reply_markup: force_reply, reply_to_message_id: last_state.to_s)

                bot.update do |msg|
                  mod_uri = msg.text
                  telegram_id = msg.from.id

                  if mod_uri =~ /^\/cancel$/i
                    engine.cancel_last_transaction(telegram_id)
                    engine.remove_state_transactions(telegram_id, Global::SETMODURL)

                    bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                    bot.send_message(chat_id: msg.chat.id, text: Global::BOT_SETMODURL_CANCEL)

                    bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                    bot.send_message(chat_id: msg.chat.id, text: Global::BOT_CANCEL_MESSAGE)
                  else
                    status_code = engine.analyze_uri(mod_uri)

                    if status_code == 200
                      engine.set_mod(mod_uri, Global::START_YEAR, Global::END_YEAR, Global::SEM, telegram_id)

                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: "#{Global::REGISTERED_NUSMODS_URI_MESSAGE} @ #{mod_uri}", disable_web_page_preview: true, reply_to_message_id: last_state.to_s)

                      engine.remove_state_transactions(telegram_id, Global::SETMODURL)

                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::RETRIEVE_TIMETABLE_MESSAGE, reply_to_message_id: last_state.to_s)

                      models.list_mods(telegram_id, bot, engine, msg)
                    elsif status_code == 403 || status_code == 404
                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::INVALID_NUSMODS_URI_MESSAGE, reply_to_message_id: last_state.to_s)

                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_CANCEL_MESSAGE, reply_to_message_id: last_state.to_s)

                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_RETRY_MESSAGE, reply_to_message_id: last_state.to_s)
                    else
                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::INVALID_NUSMODS_URI_MESSAGE, reply_to_message_id: last_state.to_s)

                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_CANCEL_MESSAGE, reply_to_message_id: last_state.to_s)

                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_RETRY_MESSAGE, reply_to_message_id: last_state.to_s)
                    end
                  end
                end
              else
                bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
                bot.send_message(chat_id: message.chat.id, text: Global::RETRIEVE_TIMETABLE_MESSAGE, reply_to_message_id: last_state.to_s)

                models.list_mods(telegramid, bot, engine, message)
              end
            end
          rescue NUSBotgram::Errors::ServiceUnavailableError
            sticker_id = STICKER_COLLECTIONS[0][:NIKOLA_TESLA_IS_UNIMPRESSED]
            bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
            bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

            bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
            bot.send_message(chat_id: message.chat.id, text: Global::BOT_SERVICE_OFFLINE)
          end
        when /^\/getmod$/i
          begin
            telegramid = message.from.id
            command = message.text
            message_id = message.message_id
            recv_date = Time.parse(message.date.to_s)

            time_diff = (time_now.to_i - recv_date.to_i) / 60
            last_state = engine.get_state_transactions(telegramid, command)

            if time_diff <= Global::X_MINUTES
              if !engine.db_exist(telegramid)
                force_reply = NUSBotgram::DataTypes::ForceReply.new(force_reply: true, selective: true)
                bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
                bot.send_message(chat_id: message.chat.id, text: Global::SEND_NUSMODS_URI_MESSAGE, reply_markup: force_reply)

                bot.update do |msg|
                  mod_uri = msg.text
                  telegram_id = msg.from.id

                  if mod_uri =~ /^\/cancel$/i
                    engine.cancel_last_transaction(telegram_id)
                    engine.remove_state_transactions(telegram_id, Global::SETMODURL)

                    bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                    bot.send_message(chat_id: msg.chat.id, text: Global::BOT_GETMOD_CANCEL)

                    bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                    bot.send_message(chat_id: msg.chat.id, text: Global::BOT_CANCEL_MESSAGE)
                  else
                    status_code = engine.analyze_uri(mod_uri)

                    if status_code == 200
                      engine.set_mod(mod_uri, Global::START_YEAR, Global::END_YEAR, Global::SEM, telegram_id)

                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: "#{Global::REGISTERED_NUSMODS_URI_MESSAGE} @ #{mod_uri}", disable_web_page_preview: true)

                      engine.remove_state_transactions(telegram_id, Global::SETMODURL)

                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::DISPLAY_MODULE_MESSAGE, reply_markup: force_reply)

                      bot.update do |mod|
                        models.get_mod(telegram_id, bot, engine, mod, STICKER_COLLECTIONS)
                      end
                    elsif status_code == 403 || status_code == 404
                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::INVALID_NUSMODS_URI_MESSAGE)

                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_CANCEL_MESSAGE)

                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_RETRY_MESSAGE)
                    else
                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::INVALID_NUSMODS_URI_MESSAGE)

                      bot.send_chat_action(chat_id: msg.chat.id, action: TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: NUSMODS_URI_CANCEL_MESSAGE)

                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_RETRY_MESSAGE)
                    end
                  end
                end
              else
                force_reply = NUSBotgram::DataTypes::ForceReply.new(force_reply: true, selective: true)
                bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
                bot.send_message(chat_id: message.chat.id, text: Global::SEARCH_MODULES_MESSAGE, reply_markup: force_reply)

                bot.update do |msg|
                  if msg.text =~ /^\/cancel$/i
                    engine.cancel_last_transaction(telegram_id)
                    engine.remove_state_transactions(telegram_id, Global::GETMOD)

                    bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                    bot.send_message(chat_id: msg.chat.id, text: Global::BOT_GETMOD_CANCEL)

                    bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                    bot.send_message(chat_id: msg.chat.id, text: Global::BOT_CANCEL_MESSAGE)
                  else
                    models.get_mod(telegramid, bot, engine, msg, STICKER_COLLECTIONS)
                  end
                end
              end
            elsif time_diff > Global::X_MINUTES && time_diff <= Global::X_MINUTES_BUFFER
              if !engine.db_exist(telegramid)
                force_reply = NUSBotgram::DataTypes::ForceReply.new(force_reply: true, selective: true)
                bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
                bot.send_message(chat_id: message.chat.id, text: Global::SEND_NUSMODS_URI_MESSAGE, reply_markup: force_reply, reply_to_message_id: last_state.to_s)

                bot.update do |msg|
                  mod_uri = msg.text
                  telegram_id = msg.from.id

                  if mod_uri =~ /^\/cancel$/i
                    engine.cancel_last_transaction(telegram_id)
                    engine.remove_state_transactions(telegram_id, Global::SETMODURL)

                    bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                    bot.send_message(chat_id: msg.chat.id, text: Global::BOT_SETMODURL_CANCEL)

                    bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                    bot.send_message(chat_id: msg.chat.id, text: Global::BOT_CANCEL_MESSAGE)
                  else
                    status_code = engine.analyze_uri(mod_uri)

                    if status_code == 200
                      engine.set_mod(mod_uri, Global::START_YEAR, Global::END_YEAR, Global::SEM, telegram_id)

                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: "#{Global::REGISTERED_NUSMODS_URI_MESSAGE} @ #{mod_uri}", disable_web_page_preview: true, reply_to_message_id: last_state.to_s)

                      engine.remove_state_transactions(telegram_id, Global::SETMODURL)

                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::DISPLAY_MODULE_MESSAGE, reply_markup: force_reply, reply_to_message_id: last_state.to_s)

                      bot.update do |mod|
                        models.get_mod(telegram_id, bot, engine, mod, STICKER_COLLECTIONS)
                      end
                    elsif status_code == 403 || status_code == 404
                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::INVALID_NUSMODS_URI_MESSAGE, reply_to_message_id: last_state.to_s)

                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_CANCEL_MESSAGE, reply_to_message_id: last_state.to_s)

                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_RETRY_MESSAGE, reply_to_message_id: last_state.to_s)
                    else
                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::INVALID_NUSMODS_URI_MESSAGE, reply_to_message_id: last_state.to_s)

                      bot.send_chat_action(chat_id: msg.chat.id, action: TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: NUSMODS_URI_CANCEL_MESSAGE, reply_to_message_id: last_state.to_s)

                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_RETRY_MESSAGE, reply_to_message_id: last_state.to_s)
                    end
                  end
                end
              else
                telegram_id = message.from.id
                force_reply = NUSBotgram::DataTypes::ForceReply.new(force_reply: true, selective: true)
                bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
                bot.send_message(chat_id: message.chat.id, text: Global::SEARCH_MODULES_MESSAGE, reply_markup: force_reply, reply_to_message_id: last_state.to_s)

                bot.update do |msg|
                  if msg.text =~ /^\/cancel$/i
                    engine.cancel_last_transaction(telegram_id)
                    engine.remove_state_transactions(telegram_id, Global::GETMOD)

                    bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                    bot.send_message(chat_id: msg.chat.id, text: Global::BOT_GETMOD_CANCEL)

                    bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                    bot.send_message(chat_id: msg.chat.id, text: Global::BOT_CANCEL_MESSAGE)
                  else
                    models.get_mod(telegram_id, bot, engine, msg, STICKER_COLLECTIONS)
                  end
                end
              end
            end
          rescue NUSBotgram::Errors::ServiceUnavailableError
            sticker_id = STICKER_COLLECTIONS[0][:NIKOLA_TESLA_IS_UNIMPRESSED]
            bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
            bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

            bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
            bot.send_message(chat_id: message.chat.id, text: Global::BOT_SERVICE_OFFLINE)
          end
        when /^\/todayme$/
          begin
            telegramid = message.from.id
            command = message.text
            message_id = message.message_id
            recv_date = Time.parse(message.date.to_s)

            time_diff = (time_now.to_i - recv_date.to_i) / 60
            last_state = engine.get_state_transactions(telegramid, command)

            if time_diff <= Global::X_MINUTES
              question = 'What action do you want to search for today?'
              selection = NUSBotgram::DataTypes::ReplyKeyboardMarkup.new(keyboard: Global::CUSTOM_TODAY_KEYBOARD, one_time_keyboard: true)
              bot.send_message(chat_id: message.chat.id, text: question, reply_markup: selection)

              bot.update do |response|
                user_reply = response.text

                if user_reply =~ /^\/cancel$/i
                  engine.cancel_last_transaction(telegram_id)
                  engine.remove_state_transactions(telegram_id, Global::TODAYME)

                  bot.send_chat_action(chat_id: response.chat.id, action: Global::TYPING_ACTION)
                  bot.send_message(chat_id: response.chat.id, text: Global::BOT_TODAYME_CANCEL)

                  bot.send_chat_action(chat_id: response.chat.id, action: Global::TYPING_ACTION)
                  bot.send_message(chat_id: response.chat.id, text: Global::BOT_CANCEL_MESSAGE)
                else
                  if user_reply.downcase.eql?("today")
                    if !engine.db_exist(response.from.id)
                      force_reply = NUSBotgram::DataTypes::ForceReply.new(force_reply: true, selective: true)
                      bot.send_chat_action(chat_id: response.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: response.chat.id, text: Global::SEND_NUSMODS_URI_MESSAGE, reply_markup: force_reply)

                      bot.update do |msg|
                        mod_uri = msg.text
                        telegram_id = msg.from.id

                        if mod_uri =~ /^\/cancel$/i
                          engine.cancel_last_transaction(telegram_id)
                          engine.remove_state_transactions(telegram_id, Global::SETMODURL)

                          bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                          bot.send_message(chat_id: msg.chat.id, text: Global::BOT_SETMODURL_CANCEL)

                          bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                          bot.send_message(chat_id: msg.chat.id, text: Global::BOT_CANCEL_MESSAGE)
                        else
                          status_code = engine.analyze_uri(mod_uri)

                          if status_code == 200
                            engine.set_mod(mod_uri, Global::START_YEAR, Global::END_YEAR, Global::SEM, telegram_id)

                            bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                            bot.send_message(chat_id: msg.chat.id, text: "#{Global::REGISTERED_NUSMODS_URI_MESSAGE} @ #{mod_uri}", disable_web_page_preview: true)

                            engine.remove_state_transactions(telegram_id, Global::SETMODURL)

                            bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                            bot.send_message(chat_id: msg.chat.id, text: Global::GET_TIMETABLE_TODAY_MESSAGE)

                            models.get_today(telegram_id, bot, engine, msg, STICKER_COLLECTIONS)
                          elsif status_code == 403 || status_code == 404
                            bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                            bot.send_message(chat_id: msg.chat.id, text: Global::INVALID_NUSMODS_URI_MESSAGE)

                            bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                            bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_CANCEL_MESSAGE)

                            bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                            bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_RETRY_MESSAGE)
                          else
                            bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                            bot.send_message(chat_id: msg.chat.id, text: Global::INVALID_NUSMODS_URI_MESSAGE)

                            bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                            bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_CANCEL_MESSAGE)

                            bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                            bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_RETRY_MESSAGE)
                          end
                        end
                      end
                    else
                      telegram_id = response.from.id
                      bot.send_chat_action(chat_id: response.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: response.chat.id, text: Global::GET_TIMETABLE_TODAY_MESSAGE)

                      models.get_today(telegram_id, bot, engine, response, STICKER_COLLECTIONS)
                    end
                  elsif user_reply.downcase.eql?("dlec")
                    models.today_star_command(bot, engine, response, Global::DESIGN_LECTURE, STICKER_COLLECTIONS)
                  elsif user_reply.downcase.eql?("lab")
                    models.today_star_command(bot, engine, response, Global::LABORATORY, STICKER_COLLECTIONS)
                  elsif user_reply.downcase.eql?("lec")
                    models.today_star_command(bot, engine, response, Global::LECTURE, STICKER_COLLECTIONS)
                  elsif user_reply.downcase.eql?("plec")
                    models.today_star_command(bot, engine, response, Global::PACKAGED_LECTURE, STICKER_COLLECTIONS)
                  elsif user_reply.downcase.eql?("ptut")
                    models.today_star_command(bot, engine, response, Global::PACKAGED_TUTORIAL, STICKER_COLLECTIONS)
                  elsif user_reply.downcase.eql?("rec")
                    models.today_star_command(bot, engine, response, Global::RECITATION, STICKER_COLLECTIONS)
                  elsif user_reply.downcase.eql?("sec")
                    models.today_star_command(bot, engine, response, Global::SECTIONAL_TEACHING, STICKER_COLLECTIONS)
                  elsif user_reply.downcase.eql?("sem")
                    models.today_star_command(bot, engine, response, Global::SEMINAR_STYLE_MODULE_CLASS, STICKER_COLLECTIONS)
                  elsif user_reply.downcase.eql?("tut")
                    models.today_star_command(bot, engine, response, Global::TUTORIAL, STICKER_COLLECTIONS)
                  elsif user_reply.downcase.eql?("tut2")
                    models.today_star_command(bot, engine, response, Global::TUTORIAL_TYPE_2, STICKER_COLLECTIONS)
                  elsif user_reply.downcase.eql?("tut3")
                    models.today_star_command(bot, engine, response, Global::TUTORIAL_TYPE_3, STICKER_COLLECTIONS)
                  end
                end

                user_reply.clear
              end
            elsif time_diff > Global::X_MINUTES && time_diff <= Global::X_MINUTES_BUFFER
              question = 'What action do you want to search for today?'
              selection = NUSBotgram::DataTypes::ReplyKeyboardMarkup.new(keyboard: Global::CUSTOM_TODAY_KEYBOARD, one_time_keyboard: true)
              bot.send_message(chat_id: message.chat.id, text: question, reply_markup: selection, reply_to_message_id: last_state.to_s)

              bot.update do |response|
                user_reply = response.text

                if user_reply =~ /^\/cancel$/i
                  engine.cancel_last_transaction(telegram_id)
                  engine.remove_state_transactions(telegram_id, Global::TODAYME)

                  bot.send_chat_action(chat_id: response.chat.id, action: Global::TYPING_ACTION)
                  bot.send_message(chat_id: response.chat.id, text: Global::BOT_TODAYME_CANCEL)

                  bot.send_chat_action(chat_id: response.chat.id, action: Global::TYPING_ACTION)
                  bot.send_message(chat_id: response.chat.id, text: Global::BOT_CANCEL_MESSAGE)
                else
                  if user_reply.downcase.eql?("today")
                    if !engine.db_exist(response.from.id)
                      force_reply = NUSBotgram::DataTypes::ForceReply.new(force_reply: true, selective: true)
                      bot.send_chat_action(chat_id: response.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: response.chat.id, text: Global::SEND_NUSMODS_URI_MESSAGE, reply_markup: force_reply, reply_to_message_id: last_state.to_s)

                      bot.update do |msg|
                        mod_uri = msg.text
                        telegram_id = msg.from.id

                        if mod_uri =~ /^\/cancel$/i
                          engine.cancel_last_transaction(telegram_id)
                          engine.remove_state_transactions(telegram_id, Global::SETMODURL)

                          bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                          bot.send_message(chat_id: msg.chat.id, text: Global::BOT_SETMODURL_CANCEL)

                          bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                          bot.send_message(chat_id: msg.chat.id, text: Global::BOT_CANCEL_MESSAGE)
                        else
                          status_code = engine.analyze_uri(mod_uri)

                          if status_code == 200
                            engine.set_mod(mod_uri, Global::START_YEAR, Global::END_YEAR, Global::SEM, telegram_id)

                            bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                            bot.send_message(chat_id: msg.chat.id, text: "#{Global::REGISTERED_NUSMODS_URI_MESSAGE} @ #{mod_uri}", disable_web_page_preview: true, reply_to_message_id: last_state.to_s)

                            engine.remove_state_transactions(telegram_id, Global::SETMODURL)

                            bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                            bot.send_message(chat_id: msg.chat.id, text: Global::GET_TIMETABLE_TODAY_MESSAGE, reply_to_message_id: last_state.to_s)

                            models.get_today(telegram_id, bot, engine, msg, STICKER_COLLECTIONS)
                          elsif status_code == 403 || status_code == 404
                            bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                            bot.send_message(chat_id: msg.chat.id, text: Global::INVALID_NUSMODS_URI_MESSAGE, reply_to_message_id: last_state.to_s)

                            bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                            bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_CANCEL_MESSAGE, reply_to_message_id: last_state.to_s)

                            bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                            bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_RETRY_MESSAGE, reply_to_message_id: last_state.to_s)
                          else
                            bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                            bot.send_message(chat_id: msg.chat.id, text: Global::INVALID_NUSMODS_URI_MESSAGE, reply_to_message_id: last_state.to_s)

                            bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                            bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_CANCEL_MESSAGE, reply_to_message_id: last_state.to_s)

                            bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                            bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_RETRY_MESSAGE, reply_to_message_id: last_state.to_s)
                          end
                        end
                      end
                    else
                      telegram_id = response.from.id
                      bot.send_chat_action(chat_id: response.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: response.chat.id, text: Global::GET_TIMETABLE_TODAY_MESSAGE, reply_to_message_id: last_state.to_s)

                      models.get_today(telegram_id, bot, engine, response, STICKER_COLLECTIONS)
                    end
                  elsif user_reply.downcase.eql?("dlec")
                    models.today_star_command(bot, engine, response, Global::DESIGN_LECTURE, STICKER_COLLECTIONS)
                  elsif user_reply.downcase.eql?("lab")
                    models.today_star_command(bot, engine, response, Global::LABORATORY, STICKER_COLLECTIONS)
                  elsif user_reply.downcase.eql?("lec")
                    models.today_star_command(bot, engine, response, Global::LECTURE, STICKER_COLLECTIONS)
                  elsif user_reply.downcase.eql?("plec")
                    models.today_star_command(bot, engine, response, Global::PACKAGED_LECTURE, STICKER_COLLECTIONS)
                  elsif user_reply.downcase.eql?("ptut")
                    models.today_star_command(bot, engine, response, Global::PACKAGED_TUTORIAL, STICKER_COLLECTIONS)
                  elsif user_reply.downcase.eql?("rec")
                    models.today_star_command(bot, engine, response, Global::RECITATION, STICKER_COLLECTIONS)
                  elsif user_reply.downcase.eql?("sec")
                    models.today_star_command(bot, engine, response, Global::SECTIONAL_TEACHING, STICKER_COLLECTIONS)
                  elsif user_reply.downcase.eql?("sem")
                    models.today_star_command(bot, engine, response, Global::SEMINAR_STYLE_MODULE_CLASS, STICKER_COLLECTIONS)
                  elsif user_reply.downcase.eql?("tut")
                    models.today_star_command(bot, engine, response, Global::TUTORIAL, STICKER_COLLECTIONS)
                  elsif user_reply.downcase.eql?("tut2")
                    models.today_star_command(bot, engine, response, Global::TUTORIAL_TYPE_2, STICKER_COLLECTIONS)
                  elsif user_reply.downcase.eql?("tut3")
                    models.today_star_command(bot, engine, response, Global::TUTORIAL_TYPE_3, STICKER_COLLECTIONS)
                  end
                end

                user_reply.clear
              end
            end
          rescue NUSBotgram::Errors::ServiceUnavailableError
            sticker_id = STICKER_COLLECTIONS[0][:NIKOLA_TESLA_IS_UNIMPRESSED]
            bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
            bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

            bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
            bot.send_message(chat_id: message.chat.id, text: Global::BOT_SERVICE_OFFLINE)
          end
        when /(^\/today$|^\/today #{custom_today})/
          begin
            telegramid = message.from.id
            command = message.text
            message_id = message.message_id
            recv_date = Time.parse(message.date.to_s)

            time_diff = (time_now.to_i - recv_date.to_i) / 60
            last_state = engine.get_state_transactions(telegramid, command)

            if time_diff <= Global::X_MINUTES
              custom_today = message.text.sub!("/today", "").strip

              if custom_today.eql?("") || custom_today == ""
                day_of_week_regex = /\b(Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)\b/

                if !engine.db_exist(telegramid)
                  force_reply = NUSBotgram::DataTypes::ForceReply.new(force_reply: true, selective: true)
                  bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
                  bot.send_message(chat_id: message.chat.id, text: Global::SEND_NUSMODS_URI_MESSAGE, reply_markup: force_reply)

                  bot.update do |msg|
                    mod_uri = msg.text
                    telegram_id = msg.from.id

                    if mod_uri =~ /^\/cancel$/i
                      engine.cancel_last_transaction(telegram_id)
                      engine.remove_state_transactions(telegram_id, Global::SETMODURL)

                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::BOT_SETMODURL_CANCEL)

                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::BOT_CANCEL_MESSAGE)
                    else
                      status_code = engine.analyze_uri(mod_uri)

                      if status_code == 200
                        engine.set_mod(mod_uri, Global::START_YEAR, Global::END_YEAR, Global::SEM, telegram_id)

                        bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                        bot.send_message(chat_id: msg.chat.id, text: "#{Global::REGISTERED_NUSMODS_URI_MESSAGE} @ #{mod_uri}", disable_web_page_preview: true)

                        engine.remove_state_transactions(telegram_id, Global::SETMODURL)

                        bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                        bot.send_message(chat_id: msg.chat.id, text: Global::GET_TIMETABLE_TODAY_MESSAGE)

                        models.get_today(telegram_id, bot, engine, msg, STICKER_COLLECTIONS)
                      elsif status_code == 403 || status_code == 404
                        bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                        bot.send_message(chat_id: msg.chat.id, text: Global::INVALID_NUSMODS_URI_MESSAGE)

                        bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                        bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_CANCEL_MESSAGE)

                        bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                        bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_RETRY_MESSAGE)
                      else
                        bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                        bot.send_message(chat_id: msg.chat.id, text: Global::INVALID_NUSMODS_URI_MESSAGE)

                        bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                        bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_CANCEL_MESSAGE)

                        bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                        bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_RETRY_MESSAGE)
                      end
                    end
                  end
                else
                  telegram_id = message.from.id
                  bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
                  bot.send_message(chat_id: message.chat.id, text: Global::GET_TIMETABLE_TODAY_MESSAGE)

                  models.get_today(telegram_id, bot, engine, message, STICKER_COLLECTIONS)
                end
              elsif custom_today.downcase.eql?("dlec") || custom_today.downcase.eql?("dlecture")
                models.today_star_command(bot, engine, message, Global::DESIGN_LECTURE, STICKER_COLLECTIONS)
              elsif custom_today.downcase.eql?("lab") || custom_today.downcase.eql?("laboratory")
                models.today_star_command(bot, engine, message, Global::LABORATORY, STICKER_COLLECTIONS)
              elsif custom_today.downcase.eql?("lec") || custom_today.downcase.eql?("lecture")
                models.today_star_command(bot, engine, message, Global::LECTURE, STICKER_COLLECTIONS)
              elsif custom_today.downcase.eql?("plec") || custom_today.downcase.eql?("plecture")
                models.today_star_command(bot, engine, message, Global::PACKAGED_LECTURE, STICKER_COLLECTIONS)
              elsif custom_today.downcase.eql?("ptut") || custom_today.downcase.eql?("ptutorial")
                models.today_star_command(bot, engine, message, Global::PACKAGED_TUTORIAL, STICKER_COLLECTIONS)
              elsif custom_today.downcase.eql?("rec") || custom_today.downcase.eql?("recitation")
                models.today_star_command(bot, engine, message, Global::RECITATION, STICKER_COLLECTIONS)
              elsif custom_today.downcase.eql?("sec") || custom_today.downcase.eql?("sectional")
                models.today_star_command(bot, engine, message, Global::SECTIONAL_TEACHING, STICKER_COLLECTIONS)
              elsif custom_today.downcase.eql?("sem") || custom_today.downcase.eql?("seminar")
                models.today_star_command(bot, engine, message, Global::SEMINAR_STYLE_MODULE_CLASS, STICKER_COLLECTIONS)
              elsif custom_today.downcase.eql?("tut") || custom_today.downcase.eql?("tutorial")
                models.today_star_command(bot, engine, message, Global::TUTORIAL, STICKER_COLLECTIONS)
              elsif custom_today.downcase.eql?("tut2") || custom_today.downcase.eql?("tutorial2")
                models.today_star_command(bot, engine, message, Global::TUTORIAL_TYPE_2, STICKER_COLLECTIONS)
              elsif custom_today.downcase.eql?("tut3") || custom_today.downcase.eql?("tutorial3")
                models.today_star_command(bot, engine, message, Global::TUTORIAL_TYPE_3, STICKER_COLLECTIONS)
              end

              custom_today.clear
            elsif time_diff > Global::X_MINUTES && time_diff <= Global::X_MINUTES_BUFFER
              custom_today = message.text.sub!("/today", "").strip

              if custom_today.eql?("") || custom_today == ""
                day_of_week_regex = /\b(Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)\b/

                if !engine.db_exist(message.from.id)
                  force_reply = NUSBotgram::DataTypes::ForceReply.new(force_reply: true, selective: true)
                  bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
                  bot.send_message(chat_id: message.chat.id, text: Global::SEND_NUSMODS_URI_MESSAGE, reply_markup: force_reply, reply_to_message_id: last_state.to_s)

                  bot.update do |msg|
                    mod_uri = msg.text
                    telegram_id = msg.from.id

                    if mod_uri =~ /^\/cancel$/i
                      engine.cancel_last_transaction(telegram_id)
                      engine.remove_state_transactions(telegram_id, Global::SETMODURL)

                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::BOT_SETMODURL_CANCEL)

                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::BOT_CANCEL_MESSAGE)
                    else
                      status_code = engine.analyze_uri(mod_uri)

                      if status_code == 200
                        engine.set_mod(mod_uri, Global::START_YEAR, Global::END_YEAR, Global::SEM, telegram_id)

                        bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                        bot.send_message(chat_id: msg.chat.id, text: "#{Global::REGISTERED_NUSMODS_URI_MESSAGE} @ #{mod_uri}", disable_web_page_preview: true, reply_to_message_id: last_state.to_s)

                        engine.remove_state_transactions(telegram_id, Global::SETMODURL)

                        bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                        bot.send_message(chat_id: msg.chat.id, text: Global::GET_TIMETABLE_TODAY_MESSAGE, reply_to_message_id: last_state.to_s)

                        models.get_today(telegram_id, bot, engine, msg, STICKER_COLLECTIONS)
                      elsif status_code == 403 || status_code == 404
                        bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                        bot.send_message(chat_id: msg.chat.id, text: Global::INVALID_NUSMODS_URI_MESSAGE, reply_to_message_id: last_state.to_s)

                        bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                        bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_CANCEL_MESSAGE, reply_to_message_id: last_state.to_s)

                        bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                        bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_RETRY_MESSAGE, reply_to_message_id: last_state.to_s)
                      else
                        bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                        bot.send_message(chat_id: msg.chat.id, text: Global::INVALID_NUSMODS_URI_MESSAGE, reply_to_message_id: last_state.to_s)

                        bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                        bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_CANCEL_MESSAGE, reply_to_message_id: last_state.to_s)

                        bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                        bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_RETRY_MESSAGE, reply_to_message_id: last_state.to_s)
                      end
                    end
                  end
                else
                  telegram_id = message.from.id
                  bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
                  bot.send_message(chat_id: message.chat.id, text: Global::GET_TIMETABLE_TODAY_MESSAGE, reply_to_message_id: last_state.to_s)

                  models.get_today(telegram_id, bot, engine, message, STICKER_COLLECTIONS)
                end
              elsif custom_today.downcase.eql?("dlec") || custom_today.downcase.eql?("dlecture")
                models.today_star_command(bot, engine, message, Global::DESIGN_LECTURE, STICKER_COLLECTIONS)
              elsif custom_today.downcase.eql?("lab") || custom_today.downcase.eql?("laboratory")
                models.today_star_command(bot, engine, message, Global::LABORATORY, STICKER_COLLECTIONS)
              elsif custom_today.downcase.eql?("lec") || custom_today.downcase.eql?("lecture")
                models.today_star_command(bot, engine, message, Global::LECTURE, STICKER_COLLECTIONS)
              elsif custom_today.downcase.eql?("plec") || custom_today.downcase.eql?("plecture")
                models.today_star_command(bot, engine, message, Global::PACKAGED_LECTURE, STICKER_COLLECTIONS)
              elsif custom_today.downcase.eql?("ptut") || custom_today.downcase.eql?("ptutorial")
                models.today_star_command(bot, engine, message, Global::PACKAGED_TUTORIAL, STICKER_COLLECTIONS)
              elsif custom_today.downcase.eql?("rec") || custom_today.downcase.eql?("recitation")
                models.today_star_command(bot, engine, message, Global::RECITATION, STICKER_COLLECTIONS)
              elsif custom_today.downcase.eql?("sec") || custom_today.downcase.eql?("sectional")
                models.today_star_command(bot, engine, message, Global::SECTIONAL_TEACHING, STICKER_COLLECTIONS)
              elsif custom_today.downcase.eql?("sem") || custom_today.downcase.eql?("seminar")
                models.today_star_command(bot, engine, message, Global::SEMINAR_STYLE_MODULE_CLASS, STICKER_COLLECTIONS)
              elsif custom_today.downcase.eql?("tut") || custom_today.downcase.eql?("tutorial")
                models.today_star_command(bot, engine, message, Global::TUTORIAL, STICKER_COLLECTIONS)
              elsif custom_today.downcase.eql?("tut2") || custom_today.downcase.eql?("tutorial2")
                models.today_star_command(bot, engine, message, Global::TUTORIAL_TYPE_2, STICKER_COLLECTIONS)
              elsif custom_today.downcase.eql?("tut3") || custom_today.downcase.eql?("tutorial3")
                models.today_star_command(bot, engine, message, Global::TUTORIAL_TYPE_3, STICKER_COLLECTIONS)
              end

              custom_today.clear
            end
          rescue NUSBotgram::Errors::ServiceUnavailableError
            sticker_id = STICKER_COLLECTIONS[0][:NIKOLA_TESLA_IS_UNIMPRESSED]
            bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
            bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

            bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
            bot.send_message(chat_id: message.chat.id, text: Global::BOT_SERVICE_OFFLINE)
          end
        when /^\/nextclass$/i
          begin
            telegramid = message.from.id
            command = message.text
            message_id = message.message_id
            recv_date = Time.parse(message.date.to_s)

            time_diff = (time_now.to_i - recv_date.to_i) / 60
            last_state = engine.get_state_transactions(telegramid, command)

            if time_diff <= Global::X_MINUTES
              if !engine.db_exist(telegramid)
                force_reply = NUSBotgram::DataTypes::ForceReply.new(force_reply: true, selective: true)
                bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
                bot.send_message(chat_id: message.chat.id, text: Global::SEND_NUSMODS_URI_MESSAGE, reply_markup: force_reply)

                bot.update do |msg|
                  mod_uri = msg.text
                  telegram_id = msg.from.id

                  if mod_uri =~ /^\/cancel$/i
                    engine.cancel_last_transaction(telegram_id)
                    engine.remove_state_transactions(telegram_id, Global::SETMODURL)

                    bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                    bot.send_message(chat_id: msg.chat.id, text: Global::BOT_SETMODURL_CANCEL)

                    bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                    bot.send_message(chat_id: msg.chat.id, text: Global::BOT_CANCEL_MESSAGE)
                  else
                    status_code = engine.analyze_uri(mod_uri)

                    if status_code == 200
                      engine.set_mod(mod_uri, Global::START_YEAR, Global::END_YEAR, Global::SEM, telegram_id)

                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: "#{Global::REGISTERED_NUSMODS_URI_MESSAGE} @ #{mod_uri}", disable_web_page_preview: true)

                      engine.remove_state_transactions(telegram_id, Global::SETMODURL)

                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::NEXT_CLASS_MESSAGE)

                      models.predict_next_class(telegram_id, bot, engine, msg, STICKER_COLLECTIONS)
                    elsif status_code == 403 || status_code == 404
                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::INVALID_NUSMODS_URI_MESSAGE)

                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_CANCEL_MESSAGE)

                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_RETRY_MESSAGE)
                    else
                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::INVALID_NUSMODS_URI_MESSAGE)

                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_CANCEL_MESSAGE)

                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_RETRY_MESSAGE)
                    end
                  end
                end
              else
                telegram_id = message.from.id

                bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
                bot.send_message(chat_id: message.chat.id, text: Global::NEXT_CLASS_MESSAGE)

                models.predict_next_class(telegram_id, bot, engine, message, STICKER_COLLECTIONS)
              end
            elsif time_diff > Global::X_MINUTES && time_diff <= Global::X_MINUTES_BUFFER
              if !engine.db_exist(message.from.id)
                force_reply = NUSBotgram::DataTypes::ForceReply.new(force_reply: true, selective: true)
                bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
                bot.send_message(chat_id: message.chat.id, text: Global::SEND_NUSMODS_URI_MESSAGE, reply_markup: force_reply, reply_to_message_id: last_state.to_s)

                bot.update do |msg|
                  mod_uri = msg.text
                  telegram_id = msg.from.id

                  if mod_uri =~ /^\/cancel$/i
                    engine.cancel_last_transaction(telegram_id)
                    engine.remove_state_transactions(telegram_id, Global::SETMODURL)

                    bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                    bot.send_message(chat_id: msg.chat.id, text: Global::BOT_SETMODURL_CANCEL)

                    bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                    bot.send_message(chat_id: msg.chat.id, text: Global::BOT_CANCEL_MESSAGE)
                  else
                    status_code = engine.analyze_uri(mod_uri)

                    if status_code == 200
                      engine.set_mod(mod_uri, Global::START_YEAR, Global::END_YEAR, Global::SEM, telegram_id)

                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: "#{Global::REGISTERED_NUSMODS_URI_MESSAGE} @ #{mod_uri}", disable_web_page_preview: true, reply_to_message_id: last_state.to_s)

                      engine.remove_state_transactions(telegram_id, Global::SETMODURL)

                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::NEXT_CLASS_MESSAGE, reply_to_message_id: last_state.to_s)

                      models.predict_next_class(telegram_id, bot, engine, msg, STICKER_COLLECTIONS)
                    elsif status_code == 403 || status_code == 404
                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::INVALID_NUSMODS_URI_MESSAGE, reply_to_message_id: last_state.to_s)

                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_CANCEL_MESSAGE, reply_to_message_id: last_state.to_s)

                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_RETRY_MESSAGE, reply_to_message_id: last_state.to_s)
                    else
                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::INVALID_NUSMODS_URI_MESSAGE, reply_to_message_id: last_state.to_s)

                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_CANCEL_MESSAGE, reply_to_message_id: last_state.to_s)

                      bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
                      bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_RETRY_MESSAGE, reply_to_message_id: last_state.to_s)
                    end
                  end
                end
              else
                telegram_id = message.from.id

                bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
                bot.send_message(chat_id: message.chat.id, text: Global::NEXT_CLASS_MESSAGE, reply_to_message_id: last_state.to_s)

                models.predict_next_class(telegram_id, bot, engine, message, STICKER_COLLECTIONS)
              end
            end
          rescue NUSBotgram::Errors::ServiceUnavailableError
            sticker_id = STICKER_COLLECTIONS[0][:NIKOLA_TESLA_IS_UNIMPRESSED]
            bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
            bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

            bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
            bot.send_message(chat_id: message.chat.id, text: Global::BOT_SERVICE_OFFLINE)
          end
        when /^\/setprivacy$/i
          bot.send_message(chat_id: message.chat.id, text: "Operation not implemented yet")
        when /^\/cancel$/i
          bot.send_message(chat_id: message.chat.id, text: Global::BOT_CANCEL_NO_STATE)
        when /^where is #{custom_location}/i
          begin
            telegramid = message.from.id
            command = message.text
            message_id = message.message_id
            recv_date = Time.parse(message.date.to_s)
            custom_location = message.text.downcase.sub!("where is ", "").strip

            time_diff = (time_now.to_i - recv_date.to_i) / 60
            last_state = engine.get_state_transactions(telegramid, command)

            location_check = engine.location_exist(CONFIG[2][:REDIS_DB_MAPNUS], "#{custom_location.upcase}")

            if !location_check
              bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
              bot.send_message(chat_id: message.chat.id, text: Global::UNRECOGNIZED_LOCATION_RESPONSE)
            else
              geolocation = engine.get_location(CONFIG[2][:REDIS_DB_MAPNUS], "#{custom_location.upcase}")
              location = JSON.parse(geolocation)

              if time_diff <= Global::X_MINUTES
                loc = NUSBotgram::DataTypes::Location.new(latitude: location["geolocation"][0]["latitude"], longitude: location["geolocation"][0]["longitude"])
                bot.send_location(chat_id: message.chat.id, latitude: loc.latitude, longitude: loc.longitude)
              elsif time_diff > Global::X_MINUTES && time_diff <= Global::X_MINUTES_BUFFER
                loc = NUSBotgram::DataTypes::Location.new(latitude: location["geolocation"][0]["latitude"], longitude: location["geolocation"][0]["longitude"])
                bot.send_location(chat_id: message.chat.id, latitude: loc.latitude, longitude: loc.longitude, reply_to_message_id: last_state.to_s)
              end
            end
          rescue NUSBotgram::Errors::ServiceUnavailableError
            sticker_id = STICKER_COLLECTIONS[0][:NIKOLA_TESLA_IS_UNIMPRESSED]
            bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
            bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

            bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
            bot.send_message(chat_id: message.chat.id, text: Global::BOT_SERVICE_OFFLINE)
          end

          custom_location.clear
        when /^\/([a-zA-Z]|\d+)/
          sticker_id = STICKER_COLLECTIONS[0][:THAT_FREUDIAN_SCOWL]
          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: Global::UNRECOGNIZED_COMMAND_RESPONSE)
      end
    end
  end
end