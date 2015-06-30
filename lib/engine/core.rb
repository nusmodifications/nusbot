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
      modules = callback(uri)
      modules_hash = Hash.new
      module_data = Array.new

      modules.each do |key, value|
        code_query = /[a-zA-Z]{2,3}[\s]?[\d]{4}[a-zA-Z]{0,2}/
        module_code = key.match code_query

        # module_code = mods.sub!(/\S+\([\S+\]\=\S+)/, "")
        response = HTTParty.get("http://api.nusmods.com/#{start_year}-#{end_year}/#{sem}/modules/#{module_code}.json")
        result = response.body
        json_result = JSON.parse(result)

        slot = value.to_i - 1

        mod_code = json_result["ModuleCode"]
        mod_title = json_result["ModuleTitle"]
        start_time = json_result["Timetable"][slot]["StartTime"]
        end_time = json_result["Timetable"][slot]["EndTime"]
        venue = json_result["Timetable"][slot]["Venue"]

        modules_hash[mod_code] = { :module_title => mod_title,
                                   :start_time => start_time,
                                   :end_time => end_time,
                                   :venue => venue }
        module_data.push(mod_code)
        module_data.push(mod_title)
        module_data.push(start_time)
        module_data.push(end_time)
        module_data.push(venue)
      end

      modules_hash
    end
  end
end