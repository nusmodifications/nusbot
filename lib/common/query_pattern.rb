module NUSBotgram
  class QueryPattern
    def ===(_)
      false
    end

    def arguments(message)
      []
    end
  end

  class TextQuery < QueryPattern
    attr_accessor :pattern

    def initialize(pattern = nil)
      @pattern = pattern
    end

    def ===(message)
      return false unless message.type == :text
      return true if @pattern.nil?
      @pattern === message.text
    end

    def arguments(message)
      if Regexp === @pattern
        query = @pattern.match(message.text)
        query.to_a
      else
        [message.text]
      end
    end
  end

  class CommandQuery < QueryPattern
    attr_accessor :command

    def initialize(command = nil, no_split = false)
      @command = command
      @no_split = no_split
    end

    def ===(message)
      start_with = '/'

      if !@command.nil?
        start_with += @command.to_s
      end
      return false if message.type != :text
      return false if !message.text.start_with? start_with

      true
    end

    def arguments(message)
      case
        when @no_split
          cmd, _, args = message.text.parition(/\s/)
          [cmd[1..-1], args]
        when @comamnd.nil?
          cmd, *args = message.text.split
          [cmd[1..-1], *args]
        else
          cmd, *args = message.text.split
          args
      end
    end
  end

  class StarQuery < QueryPattern
    def ===(_)
      true
    end
  end

  class FallbackQuery < StarQuery
  end
end