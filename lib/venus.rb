require 'httparty'
require 'json'
require 'yaml'

require_relative 'nus_botgram'

module NUSBotgram
  class Venus
    config = YAML.load_file("config/config.yml")
    bot = NUSBotgram::Bot.new(config[0][:T_BOT_APIKEY_DEV])

    response = HTTParty.get('http://api.nusmods.com/2014-2015/2/modules/CS3243.json')
    result = response.body

    bot.get_updates do |message|
      puts "In chat #{message.chat.id}, @#{message.from.username} said: #{message.text}"

      case message.text
        when /what is my next module?/i
          out = JSON.parse(result)
          code = out["ModuleCode"]
          title = out["ModuleTitle"]
          bot.send_message(chat_id: message.chat.id, text: "#{code}: #{title}")
        when /what time is the class?/i
          out = JSON.parse(result)
          timetable = out["Timetable"][6]["StartTime"]
          bot.send_message(chat_id: message.chat.id, text: "It's at #{timetable}")
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
        when /you are so awesome/i
          sticker_id = 'BQADBQADGQADyIsGAAE2WnfSWOhfUgI'
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)
        when /bye/i
          sticker_id = 'BQADBQADMQADyIsGAAERAAFE5KQulX0C'
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)
      end
    end
  end
end