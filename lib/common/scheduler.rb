module NUSBotgram
  class Scheduler
    DURATIONS = [
        ['y', 365 * 24 * 3600],
        ['M', 30 * 24 * 3600],
        ['w', 7 * 24 * 3600],
        ['d', 24 * 3600],
        ['h', 3600],
        ['m', 60],
        ['s', 1]
    ]

    DURATIONS2 = DURATIONS.dup
    DURATIONS2.delete_at(1)

    DURATION = DURATIONS.inject({}) { |r, (k, v)| r[k] = v; r }
    DURATION_LETTERS = DURATION.keys.join

    DURATION_KEYS = DURATIONS.collect { |k, v| k.to_sym }

    def initialize
    end

    public

    # Turns a string like '1m10s' into a float like '70.0', more formally,
    # turns a time duration expressed as a string into a Float instance
    # (millisecond count).
    #
    # w -> week
    # d -> day
    # h -> hour
    # m -> minute
    # s -> second
    # M -> month
    # y -> year
    # 'nada' -> millisecond
    #
    # Some examples:
    #
    #   parse_duration "0.5"    # => 0.5
    #   parse_duration "500"    # => 0.5
    #   parse_duration "1000"   # => 1.0
    #   parse_duration "1h"     # => 3600.0
    #   parse_duration "1h10s"  # => 3610.0
    #   parse_duration "1w2d"   # => 777600.0
    def parse_duration(string, opts={})
      string = string.to_s

      return 0.0 if string == ''

      m = string.match(/^(-?)([\d\.#{DURATION_LETTERS}]+)$/)

      return nil if m.nil? && opts[:no_error]
      raise ArgumentError.new("cannot parse '#{string}'") if m.nil?

      mod = m[1] == '-' ? -1.0 : 1.0
      val = 0.0

      s = m[2]

      while s.length > 0
        if (m = s.match(/^(\d+|\d+\.\d*|\d*\.\d+)([#{DURATION_LETTERS}])(.*)$/))
          val += m[1].to_f * DURATION[m[2]]
        elsif s.match(/^\d+$/)
          val += s.to_i
        elsif s.match(/^\d*\.\d*$/)
          val += s.to_f
        elsif opts[:no_error]
          return nil
        else
          raise ArgumentError.new("cannot parse '#{string}' (especially '#{s}')")
        end

        break unless m && m[3]
        s = m[3]
      end

      mod * val
    end

    public

    def to_duration(seconds, options={})

      h = to_duration_hash(seconds, options)

      return (options[:drop_seconds] ? '0m' : '0s') if h.empty?

      s = DURATION_KEYS.inject('') { |r, key|
        count = h[key]
        count = nil if count == 0
        r << "#{count}#{key}" if count
        r
      }

      ms = h[:ms]
      s << ms.to_s if ms

      s
    end

    public

    def to_duration_hash(seconds, options={})

      h = {}

      if seconds.is_a?(Float)
        h[:ms] = (seconds % 1 * 1000).to_i
        seconds = seconds.to_i
      end

      if options[:drop_seconds]
        h.delete(:ms)
        seconds = (seconds - seconds % 60)
      end

      durations = options[:months] ? DURATIONS : DURATIONS2

      durations.each do |key, duration|

        count = seconds / duration
        seconds = seconds % duration

        h[key.to_sym] = count if count > 0
      end

      h
    end
  end
end