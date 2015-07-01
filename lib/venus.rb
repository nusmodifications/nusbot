require 'httparty'
require 'json'
require 'nusmods'
require 'yaml'

require_relative 'nus_botgram'

module NUSBotgram
  class Venus
    START_YEAR = 2014
    END_YEAR = 2015
    SEM = 1

    config = YAML.load_file("config/config.yml")
    bot = NUSBotgram::Bot.new(config[0][:T_BOT_APIKEY_DEV])
    engine = NUSBotgram::Core.new
    mod_uri = ""

    bot.get_updates do |message|
      case message.text
        when /^\/help$/i
          usage = "Hello! I am Venus, I am your NUS personal assistant at your service! I can guide you around NUS, get your NUSMods timetable, and lots more!

                You can control me by sending these commands:

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
            bot.send_message(chat_id: message.chat.id, text: "Awesome! I have registered your NUSMods URL @ #{mod_uri}", disable_web_page_preview: true)
          end
        when /^\/listmods$/i
          if mod_uri == nil || mod_uri.eql?("")
            force_reply = NUSBotgram::DataTypes::ForceReply.new(force_reply: true, selective: true)
            bot.send_message(chat_id: message.chat.id, text: "Okay! Please send me your NUSMods URL (eg. http://modsn.us/nusbots)", reply_markup: force_reply)

            bot.update do |msg|
              mod_uri = msg.text
              bot.send_message(chat_id: message.chat.id, text: "Awesome! I have registered your NUSMods URL @ #{mod_uri}", disable_web_page_preview: true)
              bot.send_message(chat_id: message.chat.id, text: "Give me awhile, while I retrieve your timetable...")

              mods = engine.retrieve_mod(mod_uri, START_YEAR, END_YEAR, SEM)
              mods.each do |key, value|
                formatted = "#{value[:module_code]} - #{value[:module_title]}
						              [#{value[:lesson_type][0, 3].upcase}][#{value[:class_no]}]
						              #{value[:start_time]} - #{value[:end_time]} @ #{value[:venue]}"

                bot.send_message(chat_id: message.chat.id, text: "#{formatted}")
              end

              bot.send_message(chat_id: message.chat.id, text: "There you go, #{message.from.first_name}!")
            end
          else
            bot.send_message(chat_id: message.chat.id, text: "Give me awhile, while I retrieve your timetable...")

            mods = engine.retrieve_mod(mod_uri, START_YEAR, END_YEAR, SEM)
            mods.each do |key, value|
              formatted = "#{value[:module_code]} - #{value[:module_title]}
						             [#{value[:lesson_type][0, 3].upcase}][#{value[:class_no]}]
						             #{value[:start_time]} - #{value[:end_time]} @ #{value[:venue]}"

              bot.send_message(chat_id: message.chat.id, text: "#{formatted}")
            end

            bot.send_message(chat_id: message.chat.id, text: "There you go, #{message.from.first_name}!")
          end
        when /^\/getmod$/i
          i = 0

          if mod_uri == nil || mod_uri.eql?("")
            force_reply = NUSBotgram::DataTypes::ForceReply.new(force_reply: true, selective: true)
            bot.send_message(chat_id: message.chat.id, text: "Okay! Please send me your NUSMods URL (eg. http://modsn.us/nusbots)", reply_markup: force_reply)

            bot.update do |msg|
              mod_uri = msg.text
              bot.send_message(chat_id: message.chat.id, text: "Awesome! I have registered your NUSMods URL @ #{mod_uri}", disable_web_page_preview: true)
              bot.send_message(chat_id: message.chat.id, text: "Alright! What modules do you want to search?", reply_markup: force_reply)

              bot.update do |msg|
                mods = engine.retrieve_mod(mod_uri, START_YEAR, END_YEAR, SEM)
                mod_code = msg.text.upcase

                mods.each do |key, value|
                  if (mods["#{mod_code}-#{i}"] == nil || mods["#{mod_code}-#{i}"].eql?(""))
                    puts "EMPTY"
                  else
                    bot.send_message(chat_id: message.chat.id, text: "[#{mods["#{mod_code}-#{i}"][:lesson_type][0, 3].upcase}][#{mods["#{mod_code}-#{i}"][:class_no]}]: #{mods["#{mod_code}-#{i}"][:start_time]} - #{mods["#{mod_code}-#{i}"][:end_time]} @ #{mods["#{mod_code}-#{i}"][:venue]}")
                  end

                  i += 1
                end
              end
            end
          else
            force_reply = NUSBotgram::DataTypes::ForceReply.new(force_reply: true, selective: true)
            bot.send_message(chat_id: message.chat.id, text: "Alright! What modules do you want to search?", reply_markup: force_reply)

            bot.update do |msg|
              mods = engine.retrieve_mod(mod_uri, START_YEAR, END_YEAR, SEM)
              mod_code = msg.text.upcase

              mods.each do |key, value|
                if (mods["#{mod_code}-#{i}"] == nil || mods["#{mod_code}-#{i}"].eql?(""))
                  puts "EMPTY"
                else
                  bot.send_message(chat_id: message.chat.id, text: "[#{mods["#{mod_code}-#{i}"][:lesson_type][0, 3].upcase}][#{mods["#{mod_code}-#{i}"][:class_no]}]: #{mods["#{mod_code}-#{i}"][:start_time]} - #{mods["#{mod_code}-#{i}"][:end_time]} @ #{mods["#{mod_code}-#{i}"][:venue]}")
                end

                i += 1
              end
            end

            bot.send_message(chat_id: message.chat.id, text: "There you go, #{message.from.first_name}!")
          end
        when /^\/today$/i
          bot.send_message(chat_id: message.chat.id, text: "Operation not implemented yet")
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
        when /^\/crash$/i
          sticker_id = config[0][:NIKOLA_TESLA_IS_UNIMPRESSED]
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)
          bot.send_message(chat_id: message.chat.id, text: "I am unimpressed!")
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
        when /greet/i
          message.text = "Hello, #{message.from.first_name}!"
          bot.send_message(chat_id: message.chat.id, text: message.text)
        when /how is your day/i
          message.text = "I'm good. How about you?"
          bot.send_message(chat_id: message.chat.id, text: message.text)
        when /when is your birthday?/i
          message.text = "30th June 2015"
          bot.send_message(chat_id: message.chat.id, text: message.text)
        when /what do you want to do?/i
          message.text = "I want to integrate with NUSMODS"
          bot.send_message(chat_id: message.chat.id, text: message.text)
        when /you are awesome/i
          sticker_id = config[0][:ABRAHAM_LINCOLN_APPROVES]
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)
        when /bye/i
          sticker_id = config[0][:NAPOLEAN_BONAPARTE]
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)
      end
    end
  end
end