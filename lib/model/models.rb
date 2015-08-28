require_relative '../config/global'
require_relative '../common/algorithms'
require_relative '../../lib/factory/bot_platform'

module NUSBotgram
  class Models

    def initialize(bot, engine)
      @bot = bot
      @engine = engine
      @platform = NUSBotgram::BotPlatform.new(BotFactory.new)
      @platform.add_telegram(bot)
    end

    public

    def list_mods(telegram_id, message)
      module_results = @engine.get_mod(telegram_id)

      module_results.each do |key|
        mods_parsed = JSON.parse(key)

        formatted = "#{mods_parsed[0]["module_code"]} - #{mods_parsed[0]["module_title"]}\n#{mods_parsed[0]["lesson_type"][0, 3].upcase}[#{mods_parsed[0]["class_no"]}]: #{mods_parsed[0]["day_text"]}\n#{mods_parsed[0]["start_time"]} - #{mods_parsed[0]["end_time"]} @ #{mods_parsed[0]["venue"]}"

        @platform.normal_reply_message(message, formatted)
        # @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
        # @@bot.send_message(chat_id: message.chat.id, text: "#{formatted}")
      end

      @platform.completed_task_message(message)
      # @@bot.send_chat_action(chat_id: message.chat.id, action: Global::TYPING_ACTION)
      # @@bot.send_message(chat_id: message.chat.id, text: "There you go, #{message.from.first_name}!")

      @engine.remove_state_transactions(telegram_id, Global::LISTMODS)
    end

    public

    def get_mod(telegram_id, message, sticker_collections)
      mods_ary = Array.new

      module_results = @engine.get_mod(telegram_id)
      mod_code = message.text.upcase

      module_results.each do |key|
        mods_parsed = JSON.parse(key)

        mods_ary.push(mods_parsed[0]["module_code"])

        if mods_parsed[0]["module_code"].eql?(mod_code)
          formatted = "#{mods_parsed[0]["module_code"]} - #{mods_parsed[0]["module_title"]}\n#{mods_parsed[0]["lesson_type"][0, 3].upcase}[#{mods_parsed[0]["class_no"]}]: #{mods_parsed[0]["day_text"]}\n#{mods_parsed[0]["start_time"]} - #{mods_parsed[0]["end_time"]} @ #{mods_parsed[0]["venue"]}"

          @platform.normal_reply_message(message, formatted)
        end
      end

      if mods_ary.uniq.include?(mod_code)
        @platform.completed_task_message(message)

        @engine.remove_state_transactions(telegram_id, Global::GETMOD)
      else
        @platform.invalid_url_message(message, sticker_collections)
      end
    end

    public

    def get_today(telegram_id, message, sticker_collections)
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

      if day_count == 7
        day_count = 0
      end

      module_results = @engine.get_mod(telegram_id)

      module_results.each do |key|
        mods_parsed = JSON.parse(key)

        if mods_parsed[0]["day_text"].eql?(days[day_count - 1])
          json_data.push mods_parsed
        end
      end

      # Sort based on start_time
      normal_data = json_data.flatten.to_json
      sorted_data = JSON[normal_data].sort_by { |j| j['start_time'].to_i }

      for k in 0...sorted_data.size do
        formatted = "#{sorted_data[k]["module_code"]} - #{sorted_data[k]["module_title"]}\n#{sorted_data[k]["lesson_type"][0, 3].upcase}[#{sorted_data[k]["class_no"]}]: #{sorted_data[k]["day_text"]}\n#{sorted_data[k]["start_time"]} - #{sorted_data[k]["end_time"]} @ #{sorted_data[k]["venue"]}"

        @platform.normal_reply_message(message, formatted)
      end

      if days[day_count - 1].eql?("Saturday")
        @platform.today_saturday_message(message, sticker_collections)

        @engine.remove_state_transactions(telegram_id, Global::TODAYME)
      elsif days[day_count - 1].eql?("Sunday")
        @platform.today_sunday_message(message, sticker_collections)

        @engine.remove_state_transactions(telegram_id, Global::TODAYME)
      elsif json_data.empty?
        @platform.today_freeday_message(message, sticker_collections)

        @engine.remove_state_transactions(telegram_id, Global::TODAYME)
      end

      @platform.today_completed_ckb_message(message)
    end

    public

    def get_today_pattern(telegram_id, lesson_type, message, sticker_collections)
      day_today = Time.now.getlocal('+08:00').strftime("%A")

      module_results = @engine.get_mod(telegram_id)
      lessons_ary = Array.new
      day_lessons = Hash.new { |hash, key| hash[key] = [] }

      module_results.each do |key|
        mods_parsed = JSON.parse(key)

        lessons_ary.push([mods_parsed[0]["day_text"], mods_parsed[0]["lesson_type"]])

        if mods_parsed[0]["day_text"].eql?(day_today) && mods_parsed[0]["lesson_type"].downcase.eql?("#{lesson_type.downcase}")
          formatted = "#{mods_parsed[0]["module_code"]} - #{mods_parsed[0]["module_title"]}\n#{mods_parsed[0]["lesson_type"][0, 3].upcase}[#{mods_parsed[0]["class_no"]}]: #{mods_parsed[0]["day_text"]}\n#{mods_parsed[0]["start_time"]} - #{mods_parsed[0]["end_time"]} @ #{mods_parsed[0]["venue"]}"

          @platform.normal_reply_message(message, formatted)
        elsif mods_parsed[0]["day_text"].eql?(day_today) && mods_parsed[0]["lesson_type"].downcase.eql?(lesson_type.downcase.eql?("tutorial type 2"))
          formatted = "#{mods_parsed[0]["module_code"]} - #{mods_parsed[0]["module_title"]}\n#{mods_parsed[0]["lesson_type"][0, 3].upcase}[#{mods_parsed[0]["class_no"]}]: #{mods_parsed[0]["day_text"]}\n#{mods_parsed[0]["start_time"]} - #{mods_parsed[0]["end_time"]} @ #{mods_parsed[0]["venue"]}"

          @platform.normal_reply_message(message, formatted)
        elsif mods_parsed[0]["day_text"].eql?(day_today) && mods_parsed[0]["lesson_type"].downcase.eql?(lesson_type.downcase.eql?("tutorial type 3"))
          formatted = "#{mods_parsed[0]["module_code"]} - #{mods_parsed[0]["module_title"]}\n#{mods_parsed[0]["lesson_type"][0, 3].upcase}[#{mods_parsed[0]["class_no"]}]: #{mods_parsed[0]["day_text"]}\n#{mods_parsed[0]["start_time"]} - #{mods_parsed[0]["end_time"]} @ #{mods_parsed[0]["venue"]}"

          @platform.normal_reply_message(message, formatted)
        elsif mods_parsed[0]["day_text"].eql?(day_today) && mods_parsed[0]["lesson_type"].downcase.eql?(lesson_type.downcase.eql?("seminar-style module class"))
          formatted = "#{mods_parsed[0]["module_code"]} - #{mods_parsed[0]["module_title"]}\n#{mods_parsed[0]["lesson_type"][0, 3].upcase}[#{mods_parsed[0]["class_no"]}]: #{mods_parsed[0]["day_text"]}\n#{mods_parsed[0]["start_time"]} - #{mods_parsed[0]["end_time"]} @ #{mods_parsed[0]["venue"]}"

          @platform.normal_reply_message(message, formatted)
        elsif mods_parsed[0]["day_text"].eql?(day_today) && mods_parsed[0]["lesson_type"].downcase.eql?(lesson_type.downcase.eql?("sectional teaching"))
          formatted = "#{mods_parsed[0]["module_code"]} - #{mods_parsed[0]["module_title"]}\n#{mods_parsed[0]["lesson_type"][0, 3].upcase}[#{mods_parsed[0]["class_no"]}]: #{mods_parsed[0]["day_text"]}\n#{mods_parsed[0]["start_time"]} - #{mods_parsed[0]["end_time"]} @ #{mods_parsed[0]["venue"]}"

          @platform.normal_reply_message(message, formatted)
        end
      end

      lessons_ary.each do |key, value|
        day_lessons[key] << value
      end

      # Check if day exist
      # Check if lessons exist with day
      if day_lessons[day_today].empty? && day_today.eql?("Saturday")
        @platform.today_saturday_message(message, sticker_collections)
      elsif day_lessons[day_today].empty? && day_today.eql?("Sunday")
        @platform.today_sunday_message(message, sticker_collections)
      elsif day_lessons[day_today].include?(lesson_type)
        @platform.today_completed_ckb_message(message)
      elsif !day_lessons[day_today].include?(lesson_type)
        free_class = "It seems like you are either not taking or do not have any \"#{lesson_type.downcase}\"-based classes today!"

        @platform.today_freeclass_message(message, free_class, sticker_collections)
      elsif day_lessons[day_today].empty?
        @platform.today_freeday_message(message, sticker_collections)
      end

      @engine.remove_state_transactions(telegram_id, Global::TODAYSTAR)
    end

    public

    def today_star_command(message, lesson_type, sticker_collections)
      if !@engine.db_exist(message.from.id)
        @platform.submit_nusmods_url(message)

        @bot.update do |msg|
          mod_uri = msg.text
          telegram_id = msg.from.id

          if mod_uri =~ /^\/cancel$/i
            @engine.cancel_last_transaction(telegram_id)
            @engine.remove_state_transactions(telegram_id, Global::SETMODURL)

            @platform.submit_nusmods_url(message)
          else
            status_code = @engine.analyze_uri(mod_uri)

            if status_code == 200
              @engine.set_mod(mod_uri, Global::START_YEAR, Global::END_YEAR, Global::SEM, telegram_id)
              @engine.remove_state_transactions(telegram_id, Global::SETMODURL)

              @platform.registered_nusmods(message, mod_uri)

              get_today_pattern(telegram_id, lesson_type, msg, sticker_collections)
            elsif status_code == 403 || status_code == 404
              @platform.retry_nusmods_message(message)
            else
              @platform.retry_nusmods_message(message)
            end
          end
        end
      else
        telegram_id = message.from.id
        @platform.get_today_timetable_message(message)

        get_today_pattern(telegram_id, lesson_type, message, sticker_collections)
      end
    end

    public

    def predict_next_class(telegram_id, message, sticker_collections)
      current_time_now = Time.now.getlocal('+08:00').strftime("%R")
      day_today = Time.now.getlocal('+08:00').strftime("%A")

      # algorithms = NUSBotgram::Algorithms.new
      module_results = @engine.get_mod(telegram_id)

      mods_hash = Hash.new
      # unsorted_hash = Hash.new
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
          @platform.today_saturday_message(message, sticker_collections)

          break
        elsif day_today.eql?("Sunday")
          @platform.today_sunday_message(message, sticker_collections)

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
        @platform.no_class_message(message, sticker_collections)

        stop = true
      elsif next_class[0]["day_text"].eql?(day_today) && !stop
        formatted = "#{next_class[0]["module_code"]} - #{next_class[0]["module_title"]}\n#{next_class[0]["lesson_type"][0, 3].upcase}[#{next_class[0]["class_no"]}]: #{next_class[0]["day_text"]}\n#{next_class[0]["start_time"]} - #{next_class[0]["end_time"]} @ #{next_class[0]["venue"]}"

        @platform.normal_reply_message(message, formatted)
        @platform.completed_task_message(message)

        stop = true
      elsif !stop
        @platform.no_class_message(message, sticker_collections)

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

      if day_count == 7
        day_count = 0
      end

      module_results = @engine.get_mod(telegram_id)

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

        @platform.normal_reply_message(message, formatted)
      end

      if days[day_count].eql?("Saturday")
        @platform.today_saturday_message(message, sticker_collections)
      elsif days[day_count].eql?("Sunday")
        @platform.today_sunday_message(message, sticker_collections)
      end

      @platform.completed_task_message(message)
    end
  end
end
