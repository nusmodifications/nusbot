require 'addressable/uri'
require 'digest'
require 'httparty'
require 'json'
require 'redis'

module NUSBotgram
  class Core
    CONFIG = YAML.load_file("../lib/config/config.yml")
    DB_TOKEN = Digest::MD5.hexdigest(CONFIG[3][:DB_TOKEN])
    DB_KEY = Digest::MD5.hexdigest(CONFIG[3][:DB_KEY])
    API_ENDPOINT = 'http://api.nusmods.com/'
    REDIRECT_ENDPOINT = 'http://nusmods.com/redirect.php?timetable='

    def initialize
      @@redis = Redis.new(:host => CONFIG[2][:REDIS_HOST], :port => CONFIG[2][:REDIS_PORT], :db => 0)
    end

    private

    def callback(uri)
      _uri = REDIRECT_ENDPOINT + uri
      mods = Hash.new

      # Resolve NUSMods Shortened link
      response = HTTParty.get(_uri)
      result = response.body
      json_result = JSON.parse(result)

      # Retrieve the actual resolved link
      redirect_url = json_result["redirectedUrl"]
      resolved_url = CGI::unescape(redirect_url)

      query_uri = Addressable::URI.parse(resolved_url)

      mods_query = query_uri.query_values

      mods_query.each do |key, value|
        mods[key] = value
      end

      mods
    end

    public

    def get_uri_code(nusmods_uri)
      code = Addressable::URI.parse(nusmods_uri).path[1, 9]

      code
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

    def set_mod(uri, start_year, end_year, sem, *args)
      @@redis.select(0)
      telegram_id = args[0]
      is_deleted = false

      modules = callback(uri)
      uri_code = get_uri_code(uri)

      modules.each do |key, value|
        unfreeze_key = key.dup
        code_query = /[a-zA-Z]{2,3}[\s]?[\d]{4}[a-zA-Z]{0,2}/
        module_code = key.match code_query
        module_type = unfreeze_key.sub!(code_query, "")[1, 3]

        response = HTTParty.get("#{API_ENDPOINT}#{start_year}-#{end_year}/#{sem}/modules/#{module_code}.json")
        result = response.body
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

          # Customized JSON hash
          # Replace JSON hash with `_key` returns the same result
          if class_no.eql?(value) && lesson_type[0, 3].upcase.eql?(module_type)
            code_check = @@redis.hget("users", telegram_id)
            hkey = "users:#{telegram_id}.#{code_check}"

            # Check if the same NUSMods URI shortened code exists,
            # If it does, do nothing, else delete and replace with the new NUSMods URI shortened code
            if uri_code != code_check && !is_deleted
              delete_hmods(hkey)
              @@redis.hset("users", telegram_id, uri_code)
              is_deleted = true

              @@redis.hsetnx("#{hash_key}",
                             "#{uri_code}.#{telegram_id}.#{mod_code}#{module_type}.#{class_no}",
                             [:uri => uri,
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
            else
              @@redis.hsetnx("#{hash_key}",
                             "#{uri_code}.#{telegram_id}.#{mod_code}#{module_type}.#{class_no}",
                             [:uri => uri,
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
          end
        end
      end
    end

    public

    def db_exist(telegram_id)
      @@redis.hget("users", telegram_id)
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

    public

    def get_mod(telegram_id)
      @@redis.select(0)
      modules_hash = Hash.new

      uri_code = @@redis.hget("users", telegram_id)
      hash_key = "users:#{telegram_id}.#{uri_code}"

      if !uri_code
        "404"
      else
        results = @@redis.hgetall(hash_key)

        results.each do |key, value|
          json_value = JSON.parse(@@redis.hget(hash_key, key))
          modules_hash[key] = json_value
        end
      end

      modules_hash
    end
  end
end