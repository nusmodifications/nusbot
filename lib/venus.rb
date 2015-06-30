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
      puts "In chat #{message.chat.id}, @#{message.from.username} said: #{message.text}"

      case message.text
        when /^\/setmodurl$/i
          force_reply = NUSBotgram::DataTypes::ForceReply.new(force_reply: true, selective: true)
          bot.send_message(chat_id: message.chat.id, text: "Okay! Please send me your NUSMods URL (eg. http://modsn.us/aaaa)", reply_markup: force_reply)
          bot.update do |msg|
            mod_uri = msg.text
          end
        when /what are my modules/i
          if (mod_uri == nil || mod_uri.eql?(""))
            force_reply = NUSBotgram::DataTypes::ForceReply.new(force_reply: true, selective: true)
            bot.send_message(chat_id: message.chat.id, text: "Okay! Please send me your NUSMods URL (eg. http://modsn.us/aaaa)", reply_markup: force_reply)
            bot.update do |msg|
              mod_uri = msg.text

              mods = engine.retrieve_mod(mod_uri, START_YEAR, END_YEAR, SEM)

              mods.each do |key|
                bot.send_message(chat_id: message.chat.id, text: "#{key}")
              end
            end
          else
            mods = engine.retrieve_mod(mod_uri, START_YEAR, END_YEAR, SEM)

            mods.each do |key|
              bot.send_message(chat_id: message.chat.id, text: "#{key}")
            end
          end
        when /what are my modules?/i
          if (mod_uri == nil || mod_uri.eql?(""))
            force_reply = NUSBotgram::DataTypes::ForceReply.new(force_reply: true, selective: true)
            bot.send_message(chat_id: message.chat.id, text: "Okay! Please send me your NUSMods URL (eg. http://modsn.us/aaaa)", reply_markup: force_reply)
            bot.update do |msg|
              mod_uri = msg.text

              mods = engine.retrieve_mod(mod_uri, START_YEAR, END_YEAR, SEM)

              mods.each do |key|
                bot.send_message(chat_id: message.chat.id, text: "#{key}")
              end
            end
          else
            mods = engine.retrieve_mod(mod_uri, START_YEAR, END_YEAR, SEM)

            mods.each do |key|
              bot.send_message(chat_id: message.chat.id, text: "#{key}")
            end
          end
        when /^\/classtime$/i
          if (mod_uri == nil || mod_uri.eql?(""))
            force_reply = NUSBotgram::DataTypes::ForceReply.new(force_reply: true, selective: true)
            bot.send_message(chat_id: message.chat.id, text: "Okay! Please send me your NUSMods URL (eg. http://modsn.us/aaaa)", reply_markup: force_reply)
            bot.update do |msg|
              mod_uri = msg.text

              force_reply = NUSBotgram::DataTypes::ForceReply.new(force_reply: true, selective: true)
              bot.send_message(chat_id: message.chat.id, text: "Alright! What modules do you want to search?", reply_markup: force_reply)
              bot.update do |msg_reply|
                mods = engine.retrieve_mod(mod_uri, START_YEAR, END_YEAR, SEM)

                bot.send_message(chat_id: message.chat.id, text: "#{mods[msg_reply.text][:start_time]} - #{mods[msg_reply.text][:end_time]} @ #{mods[msg_reply.text][:venue]}")
              end
            end
          else
            force_reply = NUSBotgram::DataTypes::ForceReply.new(force_reply: true, selective: true)
            bot.send_message(chat_id: message.chat.id, text: "Alright! What modules do you want to search?", reply_markup: force_reply)
            bot.update do |msg|
              mods = engine.retrieve_mod(mod_uri, START_YEAR, END_YEAR, SEM)

              bot.send_message(chat_id: message.chat.id, text: "#{mods[msg.text][:start_time]} - #{mods[msg.text][:end_time]} @ #{mods[msg.text][:venue]}")
            end
          end
        when /^\/crash$/
          bot.send_message(chat_id: message.chat.id, text: "I will crash you! Don't crash me!")
        when /^\/start$/
          question = 'This is an awesome message?'
          answers = NUSBotgram::DataTypes::ReplyKeyboardMarkup.new(keyboard: [%w(YES), %w(NO)], one_time_keyboard: true)
          bot.send_message(chat_id: message.chat.id, text: question, reply_markup: answers)
        when /^\/stop$/
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