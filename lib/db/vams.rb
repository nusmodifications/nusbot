require 'json'
require 'redis'
require 'yaml'

module NUSBotgram
  class VAMS
    # Configuration
    CONFIG = YAML.load_file("../config/config.yml")

    location_codes = File.readlines("locations.txt").map(&:strip)
    location_names = File.readlines("location_names.txt").map(&:strip)

    lat = /\lat\=(\d.\d+)/
    lon = /\long\=(\d+.\d+)/

    redis = Redis.new(:host => CONFIG[3][:REDIS_HOST], :port => CONFIG[3][:REDIS_PORT], :password => CONFIG[3][:REDIS_PASSWORD], :db => CONFIG[3][:REDIS_DB_MAPNUS])

    location_names = Hash[location_codes.zip(location_names)]
    locations = File.readlines("loc_db_input.txt").map { |line|
      location_code, location = line.strip.split(' : ')

      _lat = location.match lat
      _lon = location.match lon
      _lat = _lat.to_s.sub!(/\lat\=/, "")
      _lon = _lon.to_s.sub!(/\long\=/, "")

      results = {
          title: location_names[location_code],
          geolocation: [latitude: _lat.to_f, longitude: _lon.to_f]
      }

      redis.hsetnx("mapnus:locations:#{location_code}", location_code, results.to_json)
    }
  end
end