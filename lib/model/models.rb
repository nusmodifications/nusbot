module NUSBotgram
  class Models
    INVALID_MODULE_CODE = "I'm afraid this is an invalid module code which I am unable to process right now.\nThe reasons might be the following:\n1. You have entered a wrong module code,\n2. This module doesn't exist in my brain,\n3. You are trying to be funny..."
    NSATURDAY_RESPONSE = "One does not simply have classes on Saturday!"
    NSUNDAY_RESPONSE = "You've got to be kidding! It's Sunday, you shouldn't have any classes today!"
    NSUNDAY_RESPONSE_END = "C'mon, have a break, will ya!"

    def initialize
    end

    public

    def list_mods(telegram_id, bot, engine, message)
      module_results = engine.get_mod(telegram_id)

      module_results.each do |key|
        mods_parsed = JSON.parse(key)

        if mods_parsed[0]["lesson_type"][0, 3].upcase.eql?("LEC") || mods_parsed[0]["lesson_type"][0, 3].upcase.eql?("SEM")
          formatted = "#{mods_parsed[0]["module_code"]} - #{mods_parsed[0]["module_title"]}\n#{mods_parsed[0]["lesson_type"][0, 3].upcase}[#{mods_parsed[0]["class_no"]}]: #{mods_parsed[0]["day_text"]}\n#{mods_parsed[0]["start_time"]} - #{mods_parsed[0]["end_time"]} @ #{mods_parsed[0]["venue"]}"

          bot.send_chat_action(chat_id: message.chat.id, action: "typing")
          bot.send_message(chat_id: message.chat.id, text: "#{formatted}")
        elsif mods_parsed[0]["lesson_type"][0, 3].upcase.eql?("TUT")
          formatted = "#{mods_parsed[0]["module_code"]} - #{mods_parsed[0]["module_title"]}\n#{mods_parsed[0]["lesson_type"][0, 3].upcase}[#{mods_parsed[0]["class_no"]}]: #{mods_parsed[0]["day_text"]}\n#{mods_parsed[0]["start_time"]} - #{mods_parsed[0]["end_time"]} @ #{mods_parsed[0]["venue"]}"

          bot.send_chat_action(chat_id: message.chat.id, action: "typing")
          bot.send_message(chat_id: message.chat.id, text: "#{formatted}")
        end
      end

      bot.send_chat_action(chat_id: message.chat.id, action: "typing")
      bot.send_message(chat_id: message.chat.id, text: "There you go, #{message.from.first_name}!")
    end

    public

    def get_mod(telegram_id, bot, engine, mods_ary, message, sticker_collections)
      module_results = engine.get_mod(telegram_id)
      mod_code = message.text.upcase

      module_results.each do |key|
        mods_parsed = JSON.parse(key)

        mods_ary.push(mods_parsed[0]["module_code"])

        if mods_parsed[0]["module_code"].eql?(mod_code)
          formatted = "#{mods_parsed[0]["module_code"]} - #{mods_parsed[0]["module_title"]}\n#{mods_parsed[0]["lesson_type"][0, 3].upcase}[#{mods_parsed[0]["class_no"]}]: #{mods_parsed[0]["day_text"]}\n#{mods_parsed[0]["start_time"]} - #{mods_parsed[0]["end_time"]} @ #{mods_parsed[0]["venue"]}"

          bot.send_chat_action(chat_id: message.chat.id, action: "typing")
          bot.send_message(chat_id: message.chat.id, text: "#{formatted}")
        end
      end

      if mods_ary.uniq.include?(mod_code)
        bot.send_chat_action(chat_id: message.chat.id, action: "typing")
        bot.send_message(chat_id: message.chat.id, text: "There you go, #{message.from.first_name}!")
      else
        bot.send_chat_action(chat_id: message.chat.id, action: "typing")
        sticker_id = sticker_collections[0][:NIKOLA_TESLA_IS_UNIMPRESSED]
        bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

        bot.send_chat_action(chat_id: message.chat.id, action: "typing")
        bot.send_message(chat_id: message.chat.id, text: INVALID_MODULE_CODE)

        bot.send_chat_action(chat_id: message.chat.id, action: "typing")
        bot.send_message(chat_id: message.chat.id, text: "Please try again, #{message.from.first_name}!")
      end
    end

    public

    def get_today(telegram_id, bot, engine, day_today, days_ary, message, customized_message, sticker_collections)
      module_results = engine.get_mod(telegram_id)

      module_results.each do |key|
        mods_parsed = JSON.parse(key)

        days_ary.push(mods_parsed[0]["day_text"])

        if mods_parsed[0]["day_text"].eql?(day_today)
          formatted = "#{mods_parsed[0]["module_code"]} - #{mods_parsed[0]["module_title"]}\n#{mods_parsed[0]["lesson_type"][0, 3].upcase}[#{mods_parsed[0]["class_no"]}]: #{mods_parsed[0]["day_text"]}\n#{mods_parsed[0]["start_time"]} - #{mods_parsed[0]["end_time"]} @ #{mods_parsed[0]["venue"]}"

          bot.send_message(chat_id: message.chat.id, text: "#{formatted}")
        end
      end

      # Identify free day in schedule
      if days_ary.uniq.include?(day_today)
        bot.send_chat_action(chat_id: message.chat.id, action: "typing")
        bot.send_message(chat_id: message.chat.id, text: "There you go, #{message.from.first_name}!")
      elsif !days_ary.uniq.include?(day_today) && day_today.eql?("Saturday")
        bot.send_chat_action(chat_id: message.chat.id, action: "typing")
        sticker_id = sticker_collections[0][:ONE_DOESNT_SIMPLY_SEND_A_TOLKIEN_STICKER]
        bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

        bot.send_chat_action(chat_id: message.chat.id, action: "typing")
        bot.send_message(chat_id: message.chat.id, text: NSATURDAY_RESPONSE)
      elsif !days_ary.uniq.include?(day_today) && day_today.eql?("Sunday")
        bot.send_chat_action(chat_id: message.chat.id, action: "typing")
        sticker_id = sticker_collections[0][:NIKOLA_TESLA_IS_UNIMPRESSED]
        bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

        bot.send_chat_action(chat_id: message.chat.id, action: "typing")
        bot.send_message(chat_id: message.chat.id, text: NSUNDAY_RESPONSE)

        bot.send_chat_action(chat_id: message.chat.id, action: "typing")
        bot.send_message(chat_id: message.chat.id, text: NSUNDAY_RESPONSE_END)
      elsif !days_ary.uniq.include?(day_today)
        bot.send_chat_action(chat_id: message.chat.id, action: "typing")
        sticker_id = sticker_collections[0][:ABRAHAM_LINCOLN_APPROVES]
        bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

        bot.send_chat_action(chat_id: message.chat.id, action: "typing")
        bot.send_message(chat_id: message.chat.id, text: customized_message)
      end
    end

    public

    def get_today_pattern(telegram_id, bot, engine, day_today, lesson_type, days_ary, mods_ary, message, sticker_collections)
      module_results = engine.get_mod(telegram_id)

      module_results.each do |key|
        mods_parsed = JSON.parse(key)

        days_ary.push(mods_parsed[0]["day_text"])
        mods_ary.push(mods_parsed[0]["lesson_type"])

        if mods_parsed[0]["day_text"].eql?(day_today) && mods_parsed[0]["lesson_type"].eql?("#{lesson_type}")
          formatted = "#{mods_parsed[0]["module_code"]} - #{mods_parsed[0]["module_title"]}\n#{mods_parsed[0]["lesson_type"][0, 3].upcase}[#{mods_parsed[0]["class_no"]}]: #{mods_parsed[0]["day_text"]}\n#{mods_parsed[0]["start_time"]} - #{mods_parsed[0]["end_time"]} @ #{mods_parsed[0]["venue"]}"

          bot.send_message(chat_id: message.chat.id, text: "#{formatted}")
        end
      end

      if days_ary.uniq.include?(day_today) && mods_ary.uniq.include?("#{lesson_type}")
        bot.send_chat_action(chat_id: message.chat.id, action: "typing")
        bot.send_message(chat_id: message.chat.id, text: "There you go, #{message.from.first_name}!")
      elsif !days_ary.uniq.include?(day_today) && day_today.eql?("Saturday")
        bot.send_chat_action(chat_id: message.chat.id, action: "typing")
        sticker_id = sticker_collections[0][:ONE_DOESNT_SIMPLY_SEND_A_TOLKIEN_STICKER]
        bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

        bot.send_chat_action(chat_id: message.chat.id, action: "typing")
        bot.send_message(chat_id: message.chat.id, text: NSATURDAY_RESPONSE)
      elsif !days_ary.uniq.include?(day_today) && day_today.eql?("Sunday")
        bot.send_chat_action(chat_id: message.chat.id, action: "typing")
        sticker_id = sticker_collections[0][:NIKOLA_TESLA_IS_UNIMPRESSED]
        bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

        bot.send_chat_action(chat_id: message.chat.id, action: "typing")
        bot.send_message(chat_id: message.chat.id, text: NSUNDAY_RESPONSE)

        bot.send_chat_action(chat_id: message.chat.id, action: "typing")
        bot.send_message(chat_id: message.chat.id, text: NSUNDAY_RESPONSE_END)
      elsif !days_ary.uniq.include?(day_today) || !mods_ary.uniq.include?("#{lesson_type}")
        bot.send_chat_action(chat_id: message.chat.id, action: "typing")
        sticker_id = sticker_collections[0][:ABRAHAM_LINCOLN_APPROVES]
        bot.send_sticker(chat_id: message.chat.id, sticker: sticker_id)

        bot.send_chat_action(chat_id: message.chat.id, action: "typing")
        bot.send_message(chat_id: message.chat.id, text: "It seems like you are either not taking or do not have any #{lesson_type.downcase}-based classes today!")
      end
    end
  end
end
