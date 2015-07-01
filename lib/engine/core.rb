require 'addressable/uri'
require 'httparty'
require 'json'

module NUSBotgram
  class Core
    def initialize
    end

    private

    def callback(uri)
      _uri = 'http://nusmods.com/redirect.php?timetable=' + uri
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

    def retrieve_mod(uri, start_year, end_year, sem)
      i = 0
      modules = callback(uri)
      modules_hash = Hash.new

      modules.each do |key, value|
        code_query = /[a-zA-Z]{2,3}[\s]?[\d]{4}[a-zA-Z]{0,2}/
        module_code = key.match code_query

        response = HTTParty.get("http://api.nusmods.com/#{start_year}-#{end_year}/#{sem}/modules/#{module_code}.json")
        result = response.body
        json_result = JSON.parse(result)

        mod_code = json_result["ModuleCode"]
        mod_title = json_result["ModuleTitle"]
        timetable = json_result["Timetable"]
        lecture_periods = json_result["LecturePeriods"]
        tutorial_periods = json_result["TutorialPeriods"]

        timetable.each do |_key|
          if _key["ClassNo"] == "#{value}"
            class_no = _key["ClassNo"]
            lesson_type = _key["LessonType"]
            day_text = _key["DayText"]
            start_time = _key["StartTime"]
            end_time = _key["EndTime"]
            venue = _key["Venue"]

            modules_hash["#{mod_code}-#{i}"] = { :module_code => mod_code,
                                                 :module_title => mod_title,
                                                 :class_no => class_no,
                                                 :lesson_type => lesson_type,
                                                 :day_text => day_text,
                                                 :start_time => start_time,
                                                 :end_time => end_time,
                                                 :venue => venue,
                                                 :lecture_periods => lecture_periods,
                                                 :tutorial_periods => tutorial_periods }
          end
        end

        i += 1
      end

      modules_hash
    end
  end
end