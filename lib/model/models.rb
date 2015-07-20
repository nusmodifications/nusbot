require_relative '../config/global'
require_relative '../common/algorithms'

module NUSBotgram
  class Models
    def initialize
    end

    public

    def list_mods(telegram_id, bot, engine, message)
      module_results = engine.get_mod(telegram_id)

      module_results.each do |key|
        mods_parsed = JSON.parse(key)

        formatted = "#{mods_parsed[0]["module_code"]} - #{mods_parsed[0]["module_title"]}\n#{mods_parsed[0]["lesson_type"][0, 3].upcase}[#{mods_parsed[0]["class_no"]}]: #{mods_parsed[0]["day_text"]}\n#{mods_parsed[0]["start_time"]} - #{mods_parsed[0]["end_time"]} @ #{mods_parsed[0]["venue"]}"

        bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        bot.send_message(chat_id: message.chat.id, text: "#{formatted}")
      end

      bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
      bot.send_message(chat_id: message.chat.id, text: "There you go, #{message.from.first_name}!")

      engine.remove_state_transactions(telegram_id, Global::LISTMODS)
    end

    public

    def get_mod(telegram_id, bot, engine, message, sticker_collections)
      mods_ary = Array.new

      module_results = engine.get_mod(telegram_id)
      mod_code = message.text.upcase

      module_results.each do |key|
        mods_parsed = JSON.parse(key)

        mods_ary.push(mods_parsed[0]["module_code"])

        if mods_parsed[0]["module_code"].eql?(mod_code)
          formatted = "#{mods_parsed[0]["module_code"]} - #{mods_parsed[0]["module_title"]}\n#{mods_parsed[0]["lesson_type"][0, 3].upcase}[#{mods_parsed[0]["class_no"]}]: #{mods_parsed[0]["day_text"]}\n#{mods_parsed[0]["start_time"]} - #{mods_parsed[0]["end_time"]} @ #{mods_parsed[0]["venue"]}"

          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: "#{formatted}")
        end
      end

      if mods_ary.uniq.include?(mod_code)
        bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        bot.send_message(chat_id: message.chat.id, text: "There you go, #{message.from.first_name}!")

        engine.remove_state_transactions(telegram_id, Global::GETMOD)
      else
        bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        sticker_id = sticker_collections[0][:NIKOLA_TESLA_IS_UNIMPRESSED]
        bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

        bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        bot.send_message(chat_id: message.chat.id, text: Global::INVALID_NUSMODS_URI_MESSAGE)

        bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        bot.send_message(chat_id: message.chat.id, text: Global::NUSMODS_URI_CANCEL_MESSAGE)

        bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        bot.send_message(chat_id: message.chat.id, text: Global::NUSMODS_URI_RETRY_MESSAGE)

        bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        bot.send_message(chat_id: message.chat.id, text: "Please try again, #{message.from.first_name}!")
      end
    end

    public

    def get_today(telegram_id, bot, engine, message, sticker_collections)
      days_ary = Array.new
      day_today = Time.now.strftime("%A")

      module_results = engine.get_mod(telegram_id)

      module_results.each do |key|
        mods_parsed = JSON.parse(key)

        days_ary.push(mods_parsed[0]["day_text"])

        if mods_parsed[0]["day_text"].eql?(day_today)
          formatted = "#{mods_parsed[0]["module_code"]} - #{mods_parsed[0]["module_title"]}\n#{mods_parsed[0]["lesson_type"][0, 3].upcase}[#{mods_parsed[0]["class_no"]}]: #{mods_parsed[0]["day_text"]}\n#{mods_parsed[0]["start_time"]} - #{mods_parsed[0]["end_time"]} @ #{mods_parsed[0]["venue"]}"

          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: "#{formatted}")
        end
      end

      # Identify free day in schedule
      if days_ary.uniq.include?(day_today)
        close_keyboard = NUSBotgram::DataTypes::ReplyKeyboardHide.new(hide_keyboard: true)
        bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        bot.send_message(chat_id: message.chat.id, text: "There you go, #{message.from.first_name}!", reply_markup: close_keyboard)

        engine.remove_state_transactions(telegram_id, Global::TODAYME)
      elsif !days_ary.uniq.include?(day_today) && day_today.eql?("Saturday")
        close_keyboard = NUSBotgram::DataTypes::ReplyKeyboardHide.new(hide_keyboard: true)
        bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        sticker_id = sticker_collections[0][:ONE_DOESNT_SIMPLY_SEND_A_TOLKIEN_STICKER]
        bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

        bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        bot.send_message(chat_id: message.chat.id, text: Global::NSATURDAY_RESPONSE, reply_markup: close_keyboard)
      elsif !days_ary.uniq.include?(day_today) && day_today.eql?("Sunday")
        close_keyboard = NUSBotgram::DataTypes::ReplyKeyboardHide.new(hide_keyboard: true)
        bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        sticker_id = sticker_collections[0][:NIKOLA_TESLA_IS_UNIMPRESSED]
        bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

        bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        bot.send_message(chat_id: message.chat.id, text: Global::NSUNDAY_RESPONSE)

        bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        bot.send_message(chat_id: message.chat.id, text: Global::NSUNDAY_RESPONSE_END, reply_markup: close_keyboard)
      elsif !days_ary.uniq.include?(day_today)
        close_keyboard = NUSBotgram::DataTypes::ReplyKeyboardHide.new(hide_keyboard: true)
        bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        sticker_id = sticker_collections[0][:ABRAHAM_LINCOLN_APPROVES]
        bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

        bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        bot.send_message(chat_id: message.chat.id, text: Global::FREEDAY_RESPONSE, reply_markup: close_keyboard)
      end
    end

    public

    def get_today_pattern(telegram_id, bot, engine, day_today, lesson_type, message, sticker_collections)
      module_results = engine.get_mod(telegram_id)

      daymods_hash = Hash.new
      days_ary = Array.new
      mods_ary = Array.new

      module_results.each do |key|
        mods_parsed = JSON.parse(key)

        daymods_hash[mods_parsed[0]["day_text"]] = mods_parsed[0]["lesson_type"]
        days_ary.push(mods_parsed[0]["day_text"])
        mods_ary.push(mods_parsed[0]["lesson_type"])

        if mods_parsed[0]["day_text"].eql?(day_today) && mods_parsed[0]["lesson_type"].downcase.eql?("#{lesson_type.downcase}")
          formatted = "#{mods_parsed[0]["module_code"]} - #{mods_parsed[0]["module_title"]}\n#{mods_parsed[0]["lesson_type"][0, 3].upcase}[#{mods_parsed[0]["class_no"]}]: #{mods_parsed[0]["day_text"]}\n#{mods_parsed[0]["start_time"]} - #{mods_parsed[0]["end_time"]} @ #{mods_parsed[0]["venue"]}"

          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: "#{formatted}")
        end
      end

      if daymods_hash[day_today].nil? || daymods_hash[day_today] == nil
        close_keyboard = NUSBotgram::DataTypes::ReplyKeyboardHide.new(hide_keyboard: true)
        bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        sticker_id = sticker_collections[0][:ABRAHAM_LINCOLN_APPROVES]
        bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

        bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        bot.send_message(chat_id: message.chat.id, text: "It seems like you are either not taking or do not have any \"#{lesson_type.downcase}\"-based classes today!", reply_markup: close_keyboard)
      else
        if days_ary.uniq.include?(day_today) && daymods_hash[day_today].include?("#{lesson_type}")
          close_keyboard = NUSBotgram::DataTypes::ReplyKeyboardHide.new(hide_keyboard: true)
          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: "There you go, #{message.from.first_name}!", reply_markup: close_keyboard)

          engine.remove_state_transactions(telegram_id, Global::TODAYSTAR)
        elsif !days_ary.uniq.include?(day_today) && day_today.eql?("Saturday")
          close_keyboard = NUSBotgram::DataTypes::ReplyKeyboardHide.new(hide_keyboard: true)
          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          sticker_id = sticker_collections[0][:ONE_DOESNT_SIMPLY_SEND_A_TOLKIEN_STICKER]
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: Global::NSATURDAY_RESPONSE, reply_markup: close_keyboard)
        elsif !days_ary.uniq.include?(day_today) && day_today.eql?("Sunday")
          close_keyboard = NUSBotgram::DataTypes::ReplyKeyboardHide.new(hide_keyboard: true)
          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          sticker_id = sticker_collections[0][:NIKOLA_TESLA_IS_UNIMPRESSED]
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: Global::NSUNDAY_RESPONSE)

          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: Global::NSUNDAY_RESPONSE_END, reply_markup: close_keyboard)
        elsif days_ary.uniq.include?(day_today) && !daymods_hash[day_today].include?("#{lesson_type}")
          close_keyboard = NUSBotgram::DataTypes::ReplyKeyboardHide.new(hide_keyboard: true)
          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          sticker_id = sticker_collections[0][:ABRAHAM_LINCOLN_APPROVES]
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: "It seems like you are either not taking or do not have any \"#{lesson_type.downcase}\"-based classes today!", reply_markup: close_keyboard)
        elsif !days_ary.uniq.include?(day_today) && !daymods_hash[day_today].include?("#{lesson_type}")
          close_keyboard = NUSBotgram::DataTypes::ReplyKeyboardHide.new(hide_keyboard: true)
          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          sticker_id = sticker_collections[0][:ABRAHAM_LINCOLN_APPROVES]
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: "It seems like you are either not taking or do not have any \"#{lesson_type.downcase}\"-based classes today!", reply_markup: close_keyboard)
        end
      end
    end

    public

    def today_star_command(bot, engine, message, lesson_type, sticker_collections)
      day_today = Time.now.strftime("%A")

      if !engine.db_exist(message.from.id)
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

              get_today_pattern(telegram_id, bot, engine, day_today, lesson_type, msg, sticker_collections)
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

        get_today_pattern(telegram_id, bot, engine, day_today, lesson_type, message, sticker_collections)
      end
    end

    public

    def predict_next_class(telegram_id, bot, engine, message, sticker_collections)
      current_time_now = Time.now.strftime("%R")
      day_today = Time.now.strftime("%A")

      algorithms = NUSBotgram::Algorithms.new
      module_results = engine.get_mod(telegram_id)

      mods_hash = Hash.new
      unsorted_hash = Hash.new
      sorted_hash = Hash.new
      time_ary = Array.new
      stop = false
      i = 0

      # Preprocess start_time to be sorted
      module_results.each do |key|
        mods_parsed = JSON.parse(key)

        if mods_parsed[0]["day_text"].eql?(day_today)
          unsorted_hash[i] = mods_parsed
          mods_hash["#{mods_parsed[0]["day_text"]}-#{i}"] = mods_parsed[0]["start_time"]
          time_ary.push(mods_parsed[0]["start_time"])

          i += 1
        end
      end

      # Sort array in ascending order - Time relative
      sorted = algorithms.bubble_sort(time_ary)

      # Process and store the sorted time into Hash
      for j in 0...mods_hash.size do
        # if current_time_now < sorted[j]
        for k in 0...mods_hash.size do
          if mods_hash["#{day_today}-#{j}"].include?(sorted[k])
            sorted_hash[j] = unsorted_hash[k]
          end
        end
        # end
      end

      sorted_hash.each do |key, value|
        lesson_time = sorted_hash[key][0]["start_time"]

        if sorted_hash[key][0]["day_text"].eql?(day_today) && current_time_now <= lesson_time && !stop
          formatted = "#{sorted_hash[key][0]["module_code"]} - #{sorted_hash[key][0]["module_title"]}\n#{sorted_hash[key][0]["lesson_type"][0, 3].upcase}[#{sorted_hash[key][0]["class_no"]}]: #{sorted_hash[key][0]["day_text"]}\n#{sorted_hash[key][0]["start_time"]} - #{sorted_hash[key][0]["end_time"]} @ #{sorted_hash[key][0]["venue"]}"

          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: "#{formatted}")

          stop = true
        elsif !stop
          sticker_id = sticker_collections[0][:LOL_MARLEY]
          bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          bot.send_message(chat_id: message.chat.id, text: Global::NEXT_CLASS_NULL_MESSAGE)

          stop = true
        end
      end
    end
  end
end
