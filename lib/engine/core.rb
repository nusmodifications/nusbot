require 'addressable/uri'
require 'anybase'
require 'digest'
require 'httparty'
require 'json'
require 'redis'

module NUSBotgram
  class Core
    CONFIG = YAML.load_file("../lib/config/config.yml")
    DB_TOKEN = Digest::MD5.hexdigest(CONFIG[3][:DB_TOKEN])
    DB_KEY = Digest::MD5.hexdigest(CONFIG[3][:DB_KEY])
    API_ENDPOINT = 'http://api.nusmods.com'
    REDIRECT_ENDPOINT = 'https://nusmods.com/redirect.php?timetable='

    def initialize
      @@redis = Redis.new(:host => CONFIG[2][:REDIS_HOST], :port => CONFIG[2][:REDIS_PORT], :db => 0)
    end

    private

    def callback(uri)
      uri_regex = /^(http|https).\/\/modsn.us\/*/i
      noredirect_regex = /^(http|https).\/\/nusmods.com\/timetable\/*/i

      modsn = uri.match uri_regex
      nusmods = uri.match noredirect_regex

      if !modsn && nusmods
        mods = decode_uri(uri)

        [0, mods]
      elsif modsn && !nusmods
        _uri = REDIRECT_ENDPOINT + uri

        # Resolve NUSMods Shortened link
        response = HTTParty.get(_uri)
        result = response.body
        json_result = JSON.parse(result)

        # Retrieve the actual resolved link
        redirect_url = json_result["redirectedUrl"]
        resolved_url = CGI::unescape(redirect_url)

        mods = decode_uri(resolved_url)

        [1, mods]
      elsif !modsn && !nusmods
        404
      end
    end

    private

    def decode_uri(uri)
      mods = Hash.new

      decoded = Addressable::URI.parse(uri)
      mods_query = decoded.query_values

      mods_query.each do |key, value|
        mods[key] = value
      end

      mods
    end

    private

    def get_uri_code(nusmods_uri)
      code = Addressable::URI.parse(nusmods_uri).path[1, 9]

      code
    end

    public

    def analyze_uri(uri)
      response = HTTParty.get(uri)

      case response.code
        when 200
          response.code
        when 403
          response.code
        when 404
          response.code
        when 500...600
          response.code
      end
    end

    public

    def db_exist(telegram_id)
      @@redis.hget("users", telegram_id)
    end

    private

    def find_keys(hash_key)
      keys = @@redis.keys("#{hash_key}:*")

      keys
    end

    private

    def ldelete_keys(hash_key)
      keys = find_keys(hash_key)
      key_len = keys.size

      for i in 0...key_len do
        len = @@redis.llen(keys[i])

        for j in 0...len do
          @@redis.rpop(keys[i])
        end
      end
    end

    private

    # If different NUSMods is sent, delete all the existing modules, then store the new modules.
    def delete_hmods(hash_key)
      results = @@redis.hgetall(hash_key)

      results.each do |key, value|
        @@redis.hdel(hash_key, key)
      end
    end

    public

    def get_mod(telegram_id)
      @@redis.select(0)
      modules_ary = Array.new

      uri_code = @@redis.hget("users", telegram_id)
      hash_key = "users:#{telegram_id}.#{uri_code}"

      if !uri_code
        404
      else
        keys = find_keys(hash_key)
        key_len = keys.size

        for i in 0...key_len do
          len = @@redis.llen(keys[i])

          for j in 0...len do
            modules_ary.push(@@redis.lindex(keys[i], j))
          end
        end
      end

      modules_ary
    end

    public

    def set_mod(uri, start_year, end_year, sem, *args)
      @@redis.select(0)
      telegram_id = args[0]
      user_code = db_exist(telegram_id)
      is_deleted = false

      modules = callback(uri)

      if modules[0] == 0
        uri_code = Anybase::Base62.random(5)

        modules[1].each do |key, value|
          unfreeze_key = key.dup
          code_query = /[a-zA-Z]{2,3}[\s]?[\d]{4}[a-zA-Z]{0,2}/
          module_code = key.match code_query
          module_type = unfreeze_key.sub!(code_query, "")[1, 3]

          response = HTTParty.get("#{API_ENDPOINT}/#{start_year}-#{end_year}/#{sem}/modules/#{module_code}.json")
          result = response.body
          is_deleted = preprocess_store(telegram_id, user_code, is_deleted, uri, uri_code, result, value, module_type)
        end
      elsif modules[0] == 1
        uri_code = get_uri_code(uri)

        modules[1].each do |key, value|
          unfreeze_key = key.dup
          code_query = /[a-zA-Z]{2,3}[\s]?[\d]{4}[a-zA-Z]{0,2}/
          module_code = key.match code_query
          module_type = unfreeze_key.sub!(code_query, "")[1, 3]

          response = HTTParty.get("#{API_ENDPOINT}/#{start_year}-#{end_year}/#{sem}/modules/#{module_code}.json")
          result = response.body
          is_deleted = preprocess_store(telegram_id, user_code, is_deleted, uri, uri_code, result, value, module_type)
        end
      else
        404
      end
    end

    private

    def preprocess_store(telegram_id, user_code, is_deleted, uri, uri_code, result, value, module_type)
      json_result = JSON.parse(result)

      mod_code = json_result["ModuleCode"]
      mod_title = json_result["ModuleTitle"]
      timetable = json_result["Timetable"]
      lecture_periods = json_result["LecturePeriods"]
      tutorial_periods = json_result["TutorialPeriods"]

      timetable.each do |_key|
        class_no = _key["ClassNo"]
        lesson_type = _key["LessonType"]
        week_text = _key["WeekText"]
        day_text = _key["DayText"]
        start_time = _key["StartTime"]
        end_time = _key["EndTime"]
        venue = _key["Venue"]

        hash_key = "users:#{telegram_id}.#{uri_code}"

        if !user_code
          # Customized JSON hash
          # Replace JSON hash with `_key` returns the same result
          if class_no.eql?(value) && lesson_type[0, 3].upcase.eql?(module_type)
            @@redis.hset("users", telegram_id, uri_code)
            store_json(hash_key, uri, mod_code, mod_title, class_no, week_text, day_text, start_time, end_time, venue, lecture_periods, lesson_type, tutorial_periods)
          end
        else
          # Customized JSON hash
          # Replace JSON hash with `_key` returns the same result
          if class_no.eql?(value) && lesson_type[0, 3].upcase.eql?(module_type) ||
              "#{lesson_type[0].upcase}LEC".eql?("DLEC") ||
              "#{lesson_type[0].upcase}LEC".eql?("PLEC") ||
              "#{lesson_type[0].upcase}TUT".eql?("PTUT")

            hkey = "users:#{telegram_id}.#{user_code}"

            # Check if the same NUSMods URI shortened code exists,
            # If it does, do nothing, else delete and replace with the new NUSMods URI shortened code
            if user_code != uri_code && !is_deleted
              ldelete_keys(hkey)
              @@redis.hset("users", telegram_id, uri_code)
              is_deleted = true

              store_json(hash_key, uri, mod_code, mod_title, class_no, week_text, day_text, start_time, end_time, venue, lecture_periods, lesson_type, tutorial_periods)
            elsif user_code == uri_code && !is_deleted
              ldelete_keys(hkey)
              @@redis.hset("users", telegram_id, uri_code)
              is_deleted = true

              store_json(hash_key, uri, mod_code, mod_title, class_no, week_text, day_text, start_time, end_time, venue, lecture_periods, lesson_type, tutorial_periods)
            else
              store_json(hash_key, uri, mod_code, mod_title, class_no, week_text, day_text, start_time, end_time, venue, lecture_periods, lesson_type, tutorial_periods)
            end
          end
        end
      end

      is_deleted
    end

    private

    def store_json(hash_key, uri, mod_code, mod_title, class_no, week_text, day_text, start_time, end_time, venue, lecture_periods, lesson_type, tutorial_periods)
      @@redis.rpush("#{hash_key}:#{mod_code}", [:uri => uri,
                                                :module_code => mod_code,
                                                :module_title => mod_title,
                                                :class_no => class_no,
                                                :week_text => week_text,
                                                :lesson_type => lesson_type,
                                                :day_text => day_text,
                                                :start_time => start_time,
                                                :end_time => end_time,
                                                :venue => venue,
                                                :lecture_periods => lecture_periods,
                                                :tutorial_periods => tutorial_periods].to_json)
    end

    public

    def check_daytime(time)
      if time[0, 2].to_i >= 0 && time[0, 2].to_i <= 11
        return 0
      elsif time[0, 2].to_i >= 12 && time[0, 2].to_i <= 17
        return 1
      elsif time[0, 2].to_i >= 18 && time[0, 2].to_i <= 24
        return 2
      end
    end
  end
end