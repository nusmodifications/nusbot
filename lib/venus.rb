require 'httparty'
require 'json'
require 'yaml'

require_relative 'nus_botgram'

module NUSBotgram
  class Venus
    START_YEAR = 2015
    END_YEAR = 2016
    SEM = 1
    DAY_REGEX = /([a-zA-Z]{6,})/

    config = YAML.load_file("config/config.yml")
    sticker_collections = YAML.load_file("config/stickers.yml")
    bot = NUSBotgram::Bot.new(config[0][:T_BOT_APIKEY_DEV])
    engine = NUSBotgram::Core.new

    bot.get_updates do |message|
      puts "In chat #{message.chat.id}, @#{message.from.first_name} > @#{message.from.id} said: #{message.text}"

      case message.text
        when /greet/i
          message.text = "Hello, #{message.from.first_name}!"
          bot.send_chat_action(chat_id: message.chat.id, action: "typing")
          bot.send_message(chat_id: message.chat.id, text: message.text)
        when /^hello$/
          message.text = "Hello, #{message.from.first_name}!"
          bot.send_chat_action(chat_id: message.chat.id, action: "typing")
          bot.send_message(chat_id: message.chat.id, text: message.text)
        when /^hi$/
          message.text = "Hello, #{message.from.first_name}!"
          bot.send_chat_action(chat_id: message.chat.id, action: "typing")
          bot.send_message(chat_id: message.chat.id, text: message.text)
        when /^hey$/
          message.text = "Hello, #{message.from.first_name}!"
          bot.send_chat_action(chat_id: message.chat.id, action: "typing")
          bot.send_message(chat_id: message.chat.id, text: message.text)
        when /how is your day/i
          message.text = "I'm good. How about you?"
          bot.send_message(chat_id: message.chat.id, text: message.text)
        when /when is your birthday/i
          message.text = "30th June 2015"
          bot.send_message(chat_id: message.chat.id, text: message.text)
        when /what do you want to do/i
          sticker_id = sticker_collections[0][:MARK_TWAIN_HUH]
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          message.text = "You tell me, what should I do?"
          bot.send_message(chat_id: message.chat.id, text: message.text)
        when /you are awesome/i
          sticker_id = sticker_collections[0][:ABRAHAM_LINCOLN_APPROVES]
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          message.text = "Thanks! I know, my creator is awesome!"
          bot.send_message(chat_id: message.chat.id, text: message.text)
        when /who is your creator/i
          sticker_id = sticker_collections[0][:STEVE_JOBS_LAUGHS_OUT_LOUD]
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          message.text = "He is Kenneth Ham."
          bot.send_message(chat_id: message.chat.id, text: message.text)
        when /who built you/i
          sticker_id = sticker_collections[0][:STEVE_JOBS_LAUGHS_OUT_LOUD]
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          message.text = "He is Kenneth Ham."
          bot.send_message(chat_id: message.chat.id, text: message.text)
        when /^what time is it now$/i
          now = Time.now.getlocal('+08:00').strftime("%H:%M GMT%z")

          message.text = "The time now is #{now}"
          bot.send_message(chat_id: message.chat.id, text: message.text)
        when /^what time now$/i
          now = Time.now.getlocal('+08:00').strftime("%H:%M GMT%z")

          message.text = "The time now is #{now}"
          bot.send_message(chat_id: message.chat.id, text: message.text)
        when /bye/i
          sticker_id = sticker_collections[0][:AUDREY_IS_ON_THE_VERGE_OF_TEARS]
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          message.text = "Bye? Will I see you again?"
          bot.send_message(chat_id: message.chat.id, text: message.text)
        when /ping$/i
          sticker_id = sticker_collections[0][:NIKOLA_TESLA_IS_UNIMPRESSED]
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          message.text = "[Sigh] Do I look like a computer to you?!"
          bot.send_message(chat_id: message.chat.id, text: message.text)
        when /shutdown$/i
          sticker_id = sticker_collections[0][:RICHARD_WAGNERS_TOLD_YOU]
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          message.text = "[Sigh] Tell me you didn't just try to shut me down..."
          bot.send_message(chat_id: message.chat.id, text: message.text)
        when /^\/time$/i
          now = Time.now.getlocal('+08:00').strftime("%H:%M GMT%z")

          message.text = "The time now is #{now}"
          bot.send_message(chat_id: message.chat.id, text: message.text)
        when /^\/now$/i
          now = Time.now.getlocal('+08:00').strftime("%H:%M GMT%z")

          message.text = "The time now is #{now}"
          bot.send_message(chat_id: message.chat.id, text: message.text)
        when /^\/poke$/i
          sticker_id = sticker_collections[0][:RICHARD_WAGNERS_TOLD_YOU]
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          message.text = "Aha- Don't try to be funny!"
          bot.send_message(chat_id: message.chat.id, text: message.text)
        when /^\/ping$/i
          sticker_id = sticker_collections[0][:NIKOLA_TESLA_IS_UNIMPRESSED]
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          message.text = "[Sigh] Do I look like a computer to you?!"
          bot.send_message(chat_id: message.chat.id, text: message.text)
        when /^\/crash$/i
          sticker_id = sticker_collections[0][:NIKOLA_TESLA_IS_UNIMPRESSED]
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          message.text = "Why do you have to be so mean?!"
          bot.send_message(chat_id: message.chat.id, text: message.text)
        when /^\/shutdown$/i
          sticker_id = sticker_collections[0][:RICHARD_WAGNERS_TOLD_YOU]
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          message.text = "[Sigh] Tell me you didn't just try to shut me down..."
          bot.send_message(chat_id: message.chat.id, text: message.text)
        when /^\/help$/i
          usage = "Hello! I am Venus, I am your NUS personal assistant at your service! I can guide you around NUS, get your NUSMods timetable, and lots more!\n\nYou can control me by sending these commands:

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

          bot.send_message(chat_id: message.chat.id, text: "#{usage}")
        when /^\/setmodurl$/i
          force_reply = NUSBotgram::DataTypes::ForceReply.new(force_reply: true, selective: true)
          bot.send_message(chat_id: message.chat.id, text: "Okay! Please send me your NUSMods URL (eg. http://modsn.us/nusbots)", reply_markup: force_reply)

          bot.update do |msg|
            mod_uri = msg.text
            telegram_id = msg.from.id

            engine.set_mod(mod_uri, START_YEAR, END_YEAR, SEM, telegram_id)

            bot.send_chat_action(chat_id: message.chat.id, action: "typing")
            bot.send_message(chat_id: msg.chat.id, text: "Awesome! I have registered your NUSMods URL @ #{mod_uri}", disable_web_page_preview: true)
          end
        when /^\/listmods$/i
          if !engine.db_exist(message.from.id)
            force_reply = NUSBotgram::DataTypes::ForceReply.new(force_reply: true, selective: true)
            bot.send_message(chat_id: message.chat.id, text: "Okay! Please send me your NUSMods URL (eg. http://modsn.us/nusbots)", reply_markup: force_reply)

            bot.update do |msg|
              mod_uri = msg.text
              telegram_id = msg.from.id

              engine.set_mod(mod_uri, START_YEAR, END_YEAR, SEM, telegram_id)
              bot.send_message(chat_id: msg.chat.id, text: "Awesome! I have registered your NUSMods URL @ #{mod_uri}", disable_web_page_preview: true)
              bot.send_message(chat_id: msg.chat.id, text: "Give me awhile, while I retrieve your timetable...")

              mods = engine.get_mod(telegram_id)
              mods.each do |key, value|
                if value[0]["lesson_type"][0, 3].upcase.eql?("LEC") || value[0]["lesson_type"][0, 3].upcase.eql?("SEM")
                  formatted = "#{value[0]["module_code"]} - #{value[0]["module_title"]}
                              [#{value[0]["lesson_type"][0, 3].upcase}][#{value[0]["class_no"]}]: #{value[0]["lecture_periods"]}
                  #{value[0]["start_time"]} - #{value[0]["end_time"]} @ #{value[0]["venue"]}"

                  bot.send_chat_action(chat_id: message.chat.id, action: "typing")
                  bot.send_message(chat_id: message.chat.id, text: "#{formatted}")
                elsif value[0]["lesson_type"][0, 3].upcase.eql?("TUT")
                  daytime = engine.check_daytime(value[0]["start_time"])

                  if daytime == 0
                    daytime = 0
                  end

                  formatted = "#{value[0]["module_code"]} - #{value[0]["module_title"]}
                              [#{value[0]["lesson_type"][0, 3].upcase}][#{value[0]["class_no"]}]: #{value[0]["tutorial_periods"][daytime - 1]}
                  #{value[0]["start_time"]} - #{value[0]["end_time"]} @ #{value[0]["venue"]}"

                  bot.send_chat_action(chat_id: message.chat.id, action: "typing")
                  bot.send_message(chat_id: message.chat.id, text: "#{formatted}")
                end
              end

              bot.send_chat_action(chat_id: message.chat.id, action: "typing")
              bot.send_message(chat_id: msg.chat.id, text: "There you go, #{msg.from.first_name}!")
            end
          else
            telegram_id = message.from.id
            bot.send_message(chat_id: message.chat.id, text: "Give me awhile, while I retrieve your timetable...")

            mods = engine.get_mod(telegram_id)
            mods.each do |key, value|
              if value[0]["lesson_type"][0, 3].upcase.eql?("LEC") || value[0]["lesson_type"][0, 3].upcase.eql?("SEM")
                formatted = "#{value[0]["module_code"]} - #{value[0]["module_title"]}
                            [#{value[0]["lesson_type"][0, 3].upcase}][#{value[0]["class_no"]}]: #{value[0]["lecture_periods"]}
                #{value[0]["start_time"]} - #{value[0]["end_time"]} @ #{value[0]["venue"]}"

                bot.send_chat_action(chat_id: message.chat.id, action: "typing")
                bot.send_message(chat_id: message.chat.id, text: "#{formatted}")
              elsif value[0]["lesson_type"][0, 3].upcase.eql?("TUT")
                daytime = engine.check_daytime(value[0]["start_time"])

                if daytime == 0
                  daytime = 0
                end

                formatted = "#{value[0]["module_code"]} - #{value[0]["module_title"]}
                            [#{value[0]["lesson_type"][0, 3].upcase}][#{value[0]["class_no"]}]: #{value[0]["tutorial_periods"][daytime - 1]}
                #{value[0]["start_time"]} - #{value[0]["end_time"]} @ #{value[0]["venue"]}"

                bot.send_chat_action(chat_id: message.chat.id, action: "typing")
                bot.send_message(chat_id: message.chat.id, text: "#{formatted}")
              end
            end

            bot.send_chat_action(chat_id: message.chat.id, action: "typing")
            bot.send_message(chat_id: message.chat.id, text: "There you go, #{message.from.first_name}!")
          end
        when /^\/getmod$/i
          if !engine.db_exist(message.from.id)
            force_reply = NUSBotgram::DataTypes::ForceReply.new(force_reply: true, selective: true)
            bot.send_message(chat_id: message.chat.id, text: "Okay! Please send me your NUSMods URL (eg. http://modsn.us/nusbots)", reply_markup: force_reply)

            bot.update do |msg|
              mod_uri = msg.text
              telegram_id = msg.from.id

              engine.set_mod(mod_uri, START_YEAR, END_YEAR, SEM, telegram_id)

              bot.send_chat_action(chat_id: message.chat.id, action: "typing")
              bot.send_message(chat_id: msg.chat.id, text: "Awesome! I have registered your NUSMods URL @ #{mod_uri}", disable_web_page_preview: true)
              bot.send_message(chat_id: msg.chat.id, text: "Alright! What modules do you want to search?", reply_markup: force_reply)

              bot.update do |mod|
                mods = engine.get_mod(telegram_id)
                mod_code = mod.text.upcase

                mods.each do |key, value|
                  if value[0]["module_code"].eql?(mod_code)
                    if value[0]["lesson_type"][0, 3].upcase.eql?("LEC") || value[0]["lesson_type"][0, 3].upcase.eql?("SEM")
                      formatted = "#{value[0]["module_code"]} - #{value[0]["module_title"]}
                                  [#{value[0]["lesson_type"][0, 3].upcase}][#{value[0]["class_no"]}]: #{value[0]["lecture_periods"]}
                      #{value[0]["start_time"]} - #{value[0]["end_time"]} @ #{value[0]["venue"]}"

                      bot.send_chat_action(chat_id: message.chat.id, action: "typing")
                      bot.send_message(chat_id: message.chat.id, text: "#{formatted}")
                    elsif value[0]["lesson_type"][0, 3].upcase.eql?("TUT")
                      daytime = engine.check_daytime(value[0]["start_time"])

                      if daytime == 0
                        daytime = 0
                      end

                      formatted = "#{value[0]["module_code"]} - #{value[0]["module_title"]}
                                  [#{value[0]["lesson_type"][0, 3].upcase}][#{value[0]["class_no"]}]: #{value[0]["tutorial_periods"][daytime - 1]}
                      #{value[0]["start_time"]} - #{value[0]["end_time"]} @ #{value[0]["venue"]}"

                      bot.send_chat_action(chat_id: message.chat.id, action: "typing")
                      bot.send_message(chat_id: message.chat.id, text: "#{formatted}")
                    end
                  end
                end

                bot.send_chat_action(chat_id: message.chat.id, action: "typing")
                bot.send_message(chat_id: mod.chat.id, text: "There you go, #{mod.from.first_name}!")
              end
            end
          else
            telegram_id = message.from.id
            force_reply = NUSBotgram::DataTypes::ForceReply.new(force_reply: true, selective: true)
            bot.send_message(chat_id: message.chat.id, text: "Alright! What modules do you want to search?", reply_markup: force_reply)

            bot.update do |msg|
              mods = engine.get_mod(telegram_id)
              mod_code = msg.text.upcase

              mods.each do |key, value|
                if value[0]["module_code"].eql?(mod_code)
                  if value[0]["lesson_type"][0, 3].upcase.eql?("LEC") || value[0]["lesson_type"][0, 3].upcase.eql?("SEM")
                    formatted = "#{value[0]["module_code"]} - #{value[0]["module_title"]}
                                [#{value[0]["lesson_type"][0, 3].upcase}][#{value[0]["class_no"]}]: #{value[0]["lecture_periods"]}
                    #{value[0]["start_time"]} - #{value[0]["end_time"]} @ #{value[0]["venue"]}"

                    bot.send_chat_action(chat_id: message.chat.id, action: "typing")
                    bot.send_message(chat_id: message.chat.id, text: "#{formatted}")
                  elsif value[0]["lesson_type"][0, 3].upcase.eql?("TUT")
                    daytime = engine.check_daytime(value[0]["start_time"])

                    if daytime == 0
                      daytime = 0
                    end

                    formatted = "#{value[0]["module_code"]} - #{value[0]["module_title"]}
                                [#{value[0]["lesson_type"][0, 3].upcase}][#{value[0]["class_no"]}]: #{value[0]["tutorial_periods"][daytime - 1]}
                    #{value[0]["start_time"]} - #{value[0]["end_time"]} @ #{value[0]["venue"]}"

                    bot.send_chat_action(chat_id: message.chat.id, action: "typing")
                    bot.send_message(chat_id: message.chat.id, text: "#{formatted}")
                  end
                end
              end

              bot.send_chat_action(chat_id: message.chat.id, action: "typing")
              bot.send_message(chat_id: msg.chat.id, text: "There you go, #{msg.from.first_name}!")
            end
          end
        when /^\/today$/i
          day_today = Time.now.strftime("%A")

          if !engine.db_exist(message.from.id)
            force_reply = NUSBotgram::DataTypes::ForceReply.new(force_reply: true, selective: true)
            bot.send_message(chat_id: message.chat.id, text: "Okay! Please send me your NUSMods URL (eg. http://modsn.us/nusbots)", reply_markup: force_reply)

            bot.update do |msg|
              mod_uri = msg.text
              telegram_id = msg.from.id

              engine.set_mod(mod_uri, START_YEAR, END_YEAR, SEM, telegram_id)

              bot.send_chat_action(chat_id: message.chat.id, action: "typing")
              bot.send_message(chat_id: msg.chat.id, text: "Awesome! I have registered your NUSMods URL @ #{mod_uri}", disable_web_page_preview: true)
              bot.send_message(chat_id: msg.chat.id, text: "Alright! Let's get you your schedule for today!")

              mods = engine.get_mod(telegram_id)

              mods.each do |key, value|
                if value[0]["day_text"].eql?(day_today)
                  if value[0]["lesson_type"][0, 3].upcase.eql?("LEC") || value[0]["lesson_type"][0, 3].upcase.eql?("SEM")
                    formatted = "#{value[0]["module_code"]} - #{value[0]["module_title"]}
                                [#{value[0]["lesson_type"][0, 3].upcase}][#{value[0]["class_no"]}]: #{value[0]["lecture_periods"]}
                    #{value[0]["start_time"]} - #{value[0]["end_time"]} @ #{value[0]["venue"]}"

                    bot.send_chat_action(chat_id: message.chat.id, action: "typing")
                    bot.send_message(chat_id: message.chat.id, text: "#{formatted}")
                  elsif value[0]["lesson_type"][0, 3].upcase.eql?("TUT")
                    daytime = engine.check_daytime(value[0]["start_time"])

                    if daytime == 0
                      daytime = 0
                    end

                    formatted = "#{value[0]["module_code"]} - #{value[0]["module_title"]}
                                [#{value[0]["lesson_type"][0, 3].upcase}][#{value[0]["class_no"]}]: #{value[0]["tutorial_periods"][daytime - 1]}
                    #{value[0]["start_time"]} - #{value[0]["end_time"]} @ #{value[0]["venue"]}"

                    bot.send_chat_action(chat_id: message.chat.id, action: "typing")
                    bot.send_message(chat_id: msg.chat.id, text: "#{formatted}")
                  end
                end
              end

              bot.send_message(chat_id: msg.chat.id, text: "There you go, #{msg.from.first_name}!")
            end
          else
            telegram_id = message.from.id
            bot.send_message(chat_id: message.chat.id, text: "Alright! Let's get you your schedule for today!")

            mods = engine.get_mod(telegram_id)

            mods.each do |key, value|
              if value[0]["day_text"].eql?(day_today)
                if value[0]["lesson_type"][0, 3].upcase.eql?("LEC") || value[0]["lesson_type"][0, 3].upcase.eql?("SEM")
                  formatted = "#{value[0]["module_code"]} - #{value[0]["module_title"]}
                              [#{value[0]["lesson_type"][0, 3].upcase}][#{value[0]["class_no"]}]: #{value[0]["lecture_periods"]}
                  #{value[0]["start_time"]} - #{value[0]["end_time"]} @ #{value[0]["venue"]}"

                  bot.send_message(chat_id: message.chat.id, text: "#{formatted}")
                elsif value[0]["lesson_type"][0, 3].upcase.eql?("TUT")
                  daytime = engine.check_daytime(value[0]["start_time"])

                  if daytime == 0
                    daytime = 0
                  end

                  formatted = "#{value[0]["module_code"]} - #{value[0]["module_title"]}
                              [#{value[0]["lesson_type"][0, 3].upcase}][#{value[0]["class_no"]}]: #{value[0]["tutorial_periods"][daytime - 1]}
                  #{value[0]["start_time"]} - #{value[0]["end_time"]} @ #{value[0]["venue"]}"

                  bot.send_message(chat_id: message.chat.id, text: "#{formatted}")
                end
              end
            end

            bot.send_message(chat_id: message.chat.id, text: "There you go, #{message.from.first_name}!")
          end

          bot.send_message(chat_id: message.chat.id, text: "Operation not fully implemented yet")
        when /^\/gettodaylec$/i
          bot.send_message(chat_id: message.chat.id, text: "Operation not implemented yet")
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
        when /where is subway at utown?/i
          loc = NUSBotgram::DataTypes::Location.new(latitude: 1.3036985632674172, longitude: 103.77380311489104)
          bot.send_location(chat_id: message.chat.id, latitude: loc.latitude, longitude: loc.longitude)
        when /^\/([a-zA-Z]|\d+)/
          sticker_id = sticker_collections[0][:THAT_FREUDIAN_SCOWL]
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          message.text = "Unrecognized command. Say what?"
          bot.send_message(chat_id: message.chat.id, text: message.text)
      end
    end
  end
end