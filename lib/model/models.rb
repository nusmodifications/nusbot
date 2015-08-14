require_relative '../config/global'
require_relative '../common/algorithms'

module NUSBotgram
  class Models

    def initialize(bot, engine)
      @@bot = bot
      @@engine = engine
    end

    public

    def list_mods(telegram_id, message)
      module_results = @@engine.get_mod(telegram_id)

      module_results.each do |key|
        mods_parsed = JSON.parse(key)

        formatted = "#{mods_parsed[0]["module_code"]} - #{mods_parsed[0]["module_title"]}\n#{mods_parsed[0]["lesson_type"][0, 3].upcase}[#{mods_parsed[0]["class_no"]}]: #{mods_parsed[0]["day_text"]}\n#{mods_parsed[0]["start_time"]} - #{mods_parsed[0]["end_time"]} @ #{mods_parsed[0]["venue"]}"

        @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        @@bot.send_message(chat_id: message.chat.id, text: "#{formatted}")
      end

      @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
      @@bot.send_message(chat_id: message.chat.id, text: "There you go, #{message.from.first_name}!")

      @@engine.remove_state_transactions(telegram_id, Global::LISTMODS)
    end

    public

    def get_mod(telegram_id, message, sticker_collections)
      mods_ary = Array.new

      module_results = @@engine.get_mod(telegram_id)
      mod_code = message.text.upcase

      module_results.each do |key|
        mods_parsed = JSON.parse(key)

        mods_ary.push(mods_parsed[0]["module_code"])

        if mods_parsed[0]["module_code"].eql?(mod_code)
          formatted = "#{mods_parsed[0]["module_code"]} - #{mods_parsed[0]["module_title"]}\n#{mods_parsed[0]["lesson_type"][0, 3].upcase}[#{mods_parsed[0]["class_no"]}]: #{mods_parsed[0]["day_text"]}\n#{mods_parsed[0]["start_time"]} - #{mods_parsed[0]["end_time"]} @ #{mods_parsed[0]["venue"]}"

          @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          @@bot.send_message(chat_id: message.chat.id, text: "#{formatted}")
        end
      end

      if mods_ary.uniq.include?(mod_code)
        @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        @@bot.send_message(chat_id: message.chat.id, text: "There you go, #{message.from.first_name}!")

        @@engine.remove_state_transactions(telegram_id, Global::GETMOD)
      else
        @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        sticker_id = sticker_collections[0][:NIKOLA_TESLA_IS_UNIMPRESSED]
        @@bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

        @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        @@bot.send_message(chat_id: message.chat.id, text: Global::INVALID_NUSMODS_URI_MESSAGE)

        @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        @@bot.send_message(chat_id: message.chat.id, text: Global::NUSMODS_URI_CANCEL_MESSAGE)

        @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        @@bot.send_message(chat_id: message.chat.id, text: Global::NUSMODS_URI_RETRY_MESSAGE)

        @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        @@bot.send_message(chat_id: message.chat.id, text: "Please try again, #{message.from.first_name}!")
      end
    end

    public

    def get_today(telegram_id, message, sticker_collections)
      days_ary = Array.new
      day_today = Time.now.getlocal('+08:00').strftime("%A")

      module_results = @@engine.get_mod(telegram_id)

      lessons_ary = Array.new
      day_lessons = Hash.new { |hash, key| hash[key] = [] }

      module_results.each do |key|
        mods_parsed = JSON.parse(key)

        lessons_ary.push([mods_parsed[0]["day_text"], mods_parsed[0]["lesson_type"]])
        days_ary.push(mods_parsed[0]["day_text"])

        if mods_parsed[0]["day_text"].eql?(day_today)
          formatted = "#{mods_parsed[0]["module_code"]} - #{mods_parsed[0]["module_title"]}\n#{mods_parsed[0]["lesson_type"][0, 3].upcase}[#{mods_parsed[0]["class_no"]}]: #{mods_parsed[0]["day_text"]}\n#{mods_parsed[0]["start_time"]} - #{mods_parsed[0]["end_time"]} @ #{mods_parsed[0]["venue"]}"

          @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          @@bot.send_message(chat_id: message.chat.id, text: "#{formatted}")
        end
      end

      lessons_ary.each do |key, value|
        day_lessons[key] << value
      end

      # Check if hash exist with Today's day
      # day_lessons[day_today].empty? # => true, if it's empty, free day
      # Identify free day in schedule
      if !day_lessons[day_today].empty?
        close_keyboard = NUSBotgram::DataTypes::ReplyKeyboardHide.new(hide_keyboard: true)
        @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        @@bot.send_message(chat_id: message.chat.id, text: "There you go, #{message.from.first_name}!", reply_markup: close_keyboard)

        @@engine.remove_state_transactions(telegram_id, Global::TODAYME)
      elsif day_lessons[day_today].empty? && day_today.eql?("Saturday")
        close_keyboard = NUSBotgram::DataTypes::ReplyKeyboardHide.new(hide_keyboard: true)
        @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        sticker_id = sticker_collections[0][:ONE_DOESNT_SIMPLY_SEND_A_TOLKIEN_STICKER]
        @@bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

        @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        @@bot.send_message(chat_id: message.chat.id, text: Global::NSATURDAY_RESPONSE, reply_markup: close_keyboard)

        @@engine.remove_state_transactions(telegram_id, Global::TODAYME)
      elsif day_lessons[day_today].empty? && day_today.eql?("Sunday")
        close_keyboard = NUSBotgram::DataTypes::ReplyKeyboardHide.new(hide_keyboard: true)
        @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        sticker_id = sticker_collections[0][:NIKOLA_TESLA_IS_UNIMPRESSED]
        @@bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

        @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        @@bot.send_message(chat_id: message.chat.id, text: Global::NSUNDAY_RESPONSE)

        @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        @@bot.send_message(chat_id: message.chat.id, text: Global::NSUNDAY_RESPONSE_END, reply_markup: close_keyboard)

        @@engine.remove_state_transactions(telegram_id, Global::TODAYME)
      elsif day_lessons[day_today].empty?
        close_keyboard = NUSBotgram::DataTypes::ReplyKeyboardHide.new(hide_keyboard: true)
        @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        sticker_id = sticker_collections[0][:ABRAHAM_LINCOLN_APPROVES]
        @@bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

        @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        @@bot.send_message(chat_id: message.chat.id, text: Global::FREEDAY_RESPONSE, reply_markup: close_keyboard)

        @@engine.remove_state_transactions(telegram_id, Global::TODAYME)
      end
    end

    public

    def get_today_pattern(telegram_id, lesson_type, message, sticker_collections)
      day_today = Time.now.getlocal('+08:00').strftime("%A")

      module_results = @@engine.get_mod(telegram_id)
      lessons_ary = Array.new
      day_lessons = Hash.new { |hash, key| hash[key] = [] }

      module_results.each do |key|
        mods_parsed = JSON.parse(key)

        lessons_ary.push([mods_parsed[0]["day_text"], mods_parsed[0]["lesson_type"]])

        if mods_parsed[0]["day_text"].eql?(day_today) && mods_parsed[0]["lesson_type"].downcase.eql?("#{lesson_type.downcase}")
          formatted = "#{mods_parsed[0]["module_code"]} - #{mods_parsed[0]["module_title"]}\n#{mods_parsed[0]["lesson_type"][0, 3].upcase}[#{mods_parsed[0]["class_no"]}]: #{mods_parsed[0]["day_text"]}\n#{mods_parsed[0]["start_time"]} - #{mods_parsed[0]["end_time"]} @ #{mods_parsed[0]["venue"]}"

          @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          @@bot.send_message(chat_id: message.chat.id, text: "#{formatted}")
        elsif mods_parsed[0]["day_text"].eql?(day_today) && mods_parsed[0]["lesson_type"].downcase.eql?(lesson_type.downcase.eql?("tutorial type 2"))
          formatted = "#{mods_parsed[0]["module_code"]} - #{mods_parsed[0]["module_title"]}\n#{mods_parsed[0]["lesson_type"][0, 3].upcase}[#{mods_parsed[0]["class_no"]}]: #{mods_parsed[0]["day_text"]}\n#{mods_parsed[0]["start_time"]} - #{mods_parsed[0]["end_time"]} @ #{mods_parsed[0]["venue"]}"

          @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          @@bot.send_message(chat_id: message.chat.id, text: "#{formatted}")
        elsif mods_parsed[0]["day_text"].eql?(day_today) && mods_parsed[0]["lesson_type"].downcase.eql?(lesson_type.downcase.eql?("tutorial type 3"))
          formatted = "#{mods_parsed[0]["module_code"]} - #{mods_parsed[0]["module_title"]}\n#{mods_parsed[0]["lesson_type"][0, 3].upcase}[#{mods_parsed[0]["class_no"]}]: #{mods_parsed[0]["day_text"]}\n#{mods_parsed[0]["start_time"]} - #{mods_parsed[0]["end_time"]} @ #{mods_parsed[0]["venue"]}"

          @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          @@bot.send_message(chat_id: message.chat.id, text: "#{formatted}")
        elsif mods_parsed[0]["day_text"].eql?(day_today) && mods_parsed[0]["lesson_type"].downcase.eql?(lesson_type.downcase.eql?("seminar-style module class"))
          formatted = "#{mods_parsed[0]["module_code"]} - #{mods_parsed[0]["module_title"]}\n#{mods_parsed[0]["lesson_type"][0, 3].upcase}[#{mods_parsed[0]["class_no"]}]: #{mods_parsed[0]["day_text"]}\n#{mods_parsed[0]["start_time"]} - #{mods_parsed[0]["end_time"]} @ #{mods_parsed[0]["venue"]}"

          @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          @@bot.send_message(chat_id: message.chat.id, text: "#{formatted}")
        elsif mods_parsed[0]["day_text"].eql?(day_today) && mods_parsed[0]["lesson_type"].downcase.eql?(lesson_type.downcase.eql?("sectional teaching"))
          formatted = "#{mods_parsed[0]["module_code"]} - #{mods_parsed[0]["module_title"]}\n#{mods_parsed[0]["lesson_type"][0, 3].upcase}[#{mods_parsed[0]["class_no"]}]: #{mods_parsed[0]["day_text"]}\n#{mods_parsed[0]["start_time"]} - #{mods_parsed[0]["end_time"]} @ #{mods_parsed[0]["venue"]}"

          @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          @@bot.send_message(chat_id: message.chat.id, text: "#{formatted}")
        end
      end

      lessons_ary.each do |key, value|
        day_lessons[key] << value
      end

      # Check if day exist
      # Check if lessons exist with day
      if day_lessons[day_today].empty? && day_today.eql?("Saturday")
        close_keyboard = NUSBotgram::DataTypes::ReplyKeyboardHide.new(hide_keyboard: true)
        @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        sticker_id = sticker_collections[0][:ONE_DOESNT_SIMPLY_SEND_A_TOLKIEN_STICKER]
        @@bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

        @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        @@bot.send_message(chat_id: message.chat.id, text: Global::NSATURDAY_RESPONSE, reply_markup: close_keyboard)
      elsif day_lessons[day_today].empty? && day_today.eql?("Sunday")
        close_keyboard = NUSBotgram::DataTypes::ReplyKeyboardHide.new(hide_keyboard: true)
        @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        sticker_id = sticker_collections[0][:NIKOLA_TESLA_IS_UNIMPRESSED]
        @@bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

        @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        @@bot.send_message(chat_id: message.chat.id, text: Global::NSUNDAY_RESPONSE)

        @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        @@bot.send_message(chat_id: message.chat.id, text: Global::NSUNDAY_RESPONSE_END, reply_markup: close_keyboard)
      elsif day_lessons[day_today].include?(lesson_type)
        close_keyboard = NUSBotgram::DataTypes::ReplyKeyboardHide.new(hide_keyboard: true)
        @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        @@bot.send_message(chat_id: message.chat.id, text: "There you go, #{message.from.first_name}!", reply_markup: close_keyboard)
      elsif !day_lessons[day_today].include?(lesson_type)
        close_keyboard = NUSBotgram::DataTypes::ReplyKeyboardHide.new(hide_keyboard: true)
        @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        sticker_id = sticker_collections[0][:ABRAHAM_LINCOLN_APPROVES]
        @@bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

        @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        @@bot.send_message(chat_id: message.chat.id, text: "It seems like you are either not taking or do not have any \"#{lesson_type.downcase}\"-based classes today!", reply_markup: close_keyboard)
      elsif day_lessons[day_today].empty?
        close_keyboard = NUSBotgram::DataTypes::ReplyKeyboardHide.new(hide_keyboard: true)
        @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        sticker_id = sticker_collections[0][:ABRAHAM_LINCOLN_APPROVES]
        @@bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

        @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        @@bot.send_message(chat_id: message.chat.id, text: Global::FREEDAY_RESPONSE, reply_markup: close_keyboard)
      end

      @@engine.remove_state_transactions(telegram_id, Global::TODAYSTAR)
    end

    public

    def today_star_command(message, lesson_type, sticker_collections)
      if !@@engine.db_exist(message.from.id)
        force_reply = NUSBotgram::DataTypes::ForceReply.new(force_reply: true, selective: true)
        @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        @@bot.send_message(chat_id: message.chat.id, text: Global::SEND_NUSMODS_URI_MESSAGE, reply_markup: force_reply)

        @@bot.update do |msg|
          mod_uri = msg.text
          telegram_id = msg.from.id

          if mod_uri =~ /^\/cancel$/i
            @@engine.cancel_last_transaction(telegram_id)
            @@engine.remove_state_transactions(telegram_id, Global::SETMODURL)

            @@bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
            @@bot.send_message(chat_id: msg.chat.id, text: Global::BOT_SETMODURL_CANCEL)

            @@bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
            @@bot.send_message(chat_id: msg.chat.id, text: Global::BOT_CANCEL_MESSAGE)
          else
            status_code = engine.analyze_uri(mod_uri)

            if status_code == 200
              @@engine.set_mod(mod_uri, Global::START_YEAR, Global::END_YEAR, Global::SEM, telegram_id)

              @@bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
              @@bot.send_message(chat_id: msg.chat.id, text: "#{Global::REGISTERED_NUSMODS_URI_MESSAGE} @ #{mod_uri}", disable_web_page_preview: true)

              @@engine.remove_state_transactions(telegram_id, Global::SETMODURL)

              @@bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
              @@bot.send_message(chat_id: msg.chat.id, text: Global::GET_TIMETABLE_TODAY_MESSAGE)

              get_today_pattern(telegram_id, lesson_type, msg, sticker_collections)
            elsif status_code == 403 || status_code == 404
              @@bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
              @@bot.send_message(chat_id: msg.chat.id, text: Global::INVALID_NUSMODS_URI_MESSAGE)

              @@bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
              @@bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_CANCEL_MESSAGE)

              @@bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
              @@bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_RETRY_MESSAGE)
            else
              @@bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
              @@bot.send_message(chat_id: msg.chat.id, text: Global::INVALID_NUSMODS_URI_MESSAGE)

              @@bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
              @@bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_CANCEL_MESSAGE)

              @@bot.send_chat_action(chat_id: msg.chat.id, action: Global::TYPING_ACTION)
              @@bot.send_message(chat_id: msg.chat.id, text: Global::NUSMODS_URI_RETRY_MESSAGE)
            end
          end
        end
      else
        telegram_id = message.from.id
        @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        @@bot.send_message(chat_id: message.chat.id, text: Global::GET_TIMETABLE_TODAY_MESSAGE)

        get_today_pattern(telegram_id, lesson_type, message, sticker_collections)
      end
    end

    public

    def predict_next_class(telegram_id, message, sticker_collections)
      current_time_now = Time.now.getlocal('+08:00').strftime("%R")
      day_today = Time.now.getlocal('+08:00').strftime("%A")

      # algorithms = NUSBotgram::Algorithms.new
      module_results = @@engine.get_mod(telegram_id)

      mods_hash = Hash.new
      unsorted_hash = Hash.new
      # sorted_hash = Hash.new
      json_data = Array.new
      # time_ary = Array.new
      next_class = Array.new
      stop = false
      i = 0

      # Preprocess start_time to be sorted
      module_results.each do |key|
        mods_parsed = JSON.parse(key)

        if mods_parsed[0]["day_text"].eql?(day_today)
          json_data.push mods_parsed
          # unsorted_hash[i] = mods_parsed
          mods_hash["#{mods_parsed[0]["day_text"]}-#{i}"] = mods_parsed[0]["start_time"]
          # time_ary.push(mods_parsed[0]["start_time"])

          i += 1
        elsif day_today.eql?("Saturday")
          @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          sticker_id = sticker_collections[0][:ONE_DOESNT_SIMPLY_SEND_A_TOLKIEN_STICKER]
          @@bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          @@bot.send_message(chat_id: message.chat.id, text: Global::NSATURDAY_RESPONSE)

          break
        elsif day_today.eql?("Sunday")
          @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          sticker_id = sticker_collections[0][:NIKOLA_TESLA_IS_UNIMPRESSED]
          @@bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

          @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          @@bot.send_message(chat_id: message.chat.id, text: Global::NSUNDAY_RESPONSE)

          @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
          @@bot.send_message(chat_id: message.chat.id, text: Global::NSUNDAY_RESPONSE_END)

          break
        end
      end

      normal_data = json_data.flatten.to_json
      sorted_data = JSON[normal_data].sort_by { |j| j['start_time'].to_i }

      # # Sort array in ascending order - Time relative
      # sorted = algorithms.bubble_sort(time_ary)
      #
      # # Process and store the sorted time into Hash
      # for j in 0...mods_hash.size do
      #   # if current_time_now < sorted[j]
      #   for k in 0...mods_hash.size do
      #     if mods_hash["#{day_today}-#{j}"].include?(sorted[k])
      #       sorted_hash[j] = unsorted_hash[k]
      #     end
      #   end
      #   # end
      # end

      for k in 0...sorted_data.size do
        lesson_time = sorted_data[k]["start_time"]

        if sorted_data[k]["day_text"].eql?(day_today) && current_time_now <= lesson_time
          next_class.push(sorted_data[k])
        end
      end

      if next_class.empty? && !stop
        sticker_id = sticker_collections[0][:LOL_MARLEY]
        @@bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

        @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        @@bot.send_message(chat_id: message.chat.id, text: Global::NEXT_CLASS_NULL_MESSAGE)

        stop = true
      elsif next_class[0]["day_text"].eql?(day_today) && !stop
        formatted = "#{next_class[0]["module_code"]} - #{next_class[0]["module_title"]}\n#{next_class[0]["lesson_type"][0, 3].upcase}[#{next_class[0]["class_no"]}]: #{next_class[0]["day_text"]}\n#{next_class[0]["start_time"]} - #{next_class[0]["end_time"]} @ #{next_class[0]["venue"]}"

        @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        @@bot.send_message(chat_id: message.chat.id, text: "#{formatted}")

        @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        @@bot.send_message(chat_id: message.chat.id, text: "There you go, #{message.from.first_name}!")

        stop = true
      elsif !stop
        sticker_id = sticker_collections[0][:LOL_MARLEY]
        @@bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

        @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        @@bot.send_message(chat_id: message.chat.id, text: Global::NEXT_CLASS_NULL_MESSAGE)

        stop = true
      end

      # sorted_hash.each do |key, value|
      #   lesson_time = sorted_hash[key][0]["start_time"]
      #
      #   if sorted_hash[key][0]["day_text"].eql?(day_today) && current_time_now <= lesson_time && !stop
      #     formatted = "#{sorted_hash[key][0]["module_code"]} - #{sorted_hash[key][0]["module_title"]}\n#{sorted_hash[key][0]["lesson_type"][0, 3].upcase}[#{sorted_hash[key][0]["class_no"]}]: #{sorted_hash[key][0]["day_text"]}\n#{sorted_hash[key][0]["start_time"]} - #{sorted_hash[key][0]["end_time"]} @ #{sorted_hash[key][0]["venue"]}"
      #
      #     @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
      #     @@bot.send_message(chat_id: message.chat.id, text: "#{formatted}")
      #
      #     @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
      #     @@bot.send_message(chat_id: message.chat.id, text: "There you go, #{message.from.first_name}!")
      #
      #     stop = true
      #   elsif !stop
      #     sticker_id = sticker_collections[0][:LOL_MARLEY]
      #     @@bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)
      #
      #     @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
      #     @@bot.send_message(chat_id: message.chat.id, text: Global::NEXT_CLASS_NULL_MESSAGE)
      #
      #     stop = true
      #   end
      # end
    end

    public

    def get_tomorrow(telegram_id, message, sticker_collections)
      day_today = Time.now.getlocal('+08:00').strftime("%A")
      days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
      i = 1
      day_count = 0
      json_data = Array.new

      days.each do |day|
        if day.equal?(day_today) || day == day_today
          day_count = i
        end

        i += 1
      end

      module_results = @@engine.get_mod(telegram_id)

      module_results.each do |key|
        mods_parsed = JSON.parse(key)

        if mods_parsed[0]["day_text"].eql?(days[day_count])
          json_data.push mods_parsed
        end
      end

      # Sort based on start_time
      normal_data = json_data.flatten.to_json
      sorted_data = JSON[normal_data].sort_by { |j| j['start_time'].to_i }

      for k in 0...sorted_data.size do
        formatted = "#{sorted_data[k]["module_code"]} - #{sorted_data[k]["module_title"]}\n#{sorted_data[k]["lesson_type"][0, 3].upcase}[#{sorted_data[k]["class_no"]}]: #{sorted_data[k]["day_text"]}\n#{sorted_data[k]["start_time"]} - #{sorted_data[k]["end_time"]} @ #{sorted_data[k]["venue"]}"

        @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        @@bot.send_message(chat_id: message.chat.id, text: "#{formatted}")
      end

      if days[day_count].eql?("Saturday")
        @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        sticker_id = sticker_collections[0][:ONE_DOESNT_SIMPLY_SEND_A_TOLKIEN_STICKER]
        @@bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

        @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        @@bot.send_message(chat_id: message.chat.id, text: Global::NSATURDAY_RESPONSE)
      elsif days[day_count].eql?("Sunday")
        @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        sticker_id = sticker_collections[0][:NIKOLA_TESLA_IS_UNIMPRESSED]
        @@bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

        @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        @@bot.send_message(chat_id: message.chat.id, text: Global::NSUNDAY_RESPONSE)

        @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        @@bot.send_message(chat_id: message.chat.id, text: Global::NSUNDAY_RESPONSE_END)
      end

      @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
      @@bot.send_message(chat_id: message.chat.id, text: "There you go, #{message.from.first_name}!")
    end
  end
end
