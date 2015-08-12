##
## == Exceptions during processing
##
## Any exceptions during #each will result in the item being re-added to the
## schedule at the original time.
##
## == Multiple producers and consumers
##
## Multiple producers and consumers are fine.
##
## == Concurrent reads and writes
##
## Concurrent reads and writes are fine.
##
module NUSBotgram
  class RedisScheduler
    include Enumerable

    POLL_DELAY = 1.0 # seconds
    CAS_DELAY = 0.5 # seconds

    def initialize(redis, opts={})
      @redis = redis
      @namespace = opts[:namespace]
      @blocking = opts[:blocking]
      @uniq = opts[:uniq]

      @queue = [@namespace, "schedule:queue"].join
      @processing_set = [@namespace, "schedule:processing"].join
      @counter = [@namespace, "schedule:counter"].join
    end

    def schedule!(item, time)
      @redis.zadd(@queue, time.to_f, make_entry(item))
    end

    def reset!
      [@queue, @processing_set, @counter].each { |k| @redis.del k }
    end

    def size
      @redis.zcard(@queue)
    end

    def processing_set_size
      @redis.scard(@processing_set)
    end

    def each(descriptor=nil)
      while (x = get(descriptor))
        item, processing_descriptor, at = x
        begin
          yield item, at
        rescue Exception # back in the hole!
          schedule!(item, at)
          raise
        ensure
          cleanup! processing_descriptor
        end
      end
    end

    def items
      ItemEnumerator.new(@redis, @queue, @uniq)
    end

    def processing_set_items
      @redis.smembers(@processing_set).map do |x|
        item, timestamp, descriptor = Marshal.load(x)
        [item, Time.at(timestamp), descriptor]
      end
    end

    private

    def make_entry(item)
      if @uniq
        item.to_s
      else
        id = @redis.incr(@counter)
        "#{id}:#{item}"
      end
    end

    def parse_entry(entry)
      if @uniq
        entry
      else
        entry =~ /^\d+:(\S+)$/ or raise InvalidEntryException, entry
        $1
      end
    end

    def get(descriptor)
      @blocking ? blocking_get(descriptor) : nonblocking_get(descriptor)
    end

    def blocking_get(descriptor)
      sleep POLL_DELAY until (x = nonblocking_get(descriptor))
      x
    end

    def nonblocking_get(descriptor)
      loop do
        @redis.watch(@queue)
        entries = @redis.zrangebyscore(@queue, 0, Time.now.to_f, :withscores => true, :limit => [0, 1])
        break unless entries.size > 0

        entry, at = entries.first
        item = parse_entry(entry)
        descriptor = Marshal.dump [item, Time.now.to_i, descriptor]

        @redis.multi do # try and grab it
          @redis.zrem(@queue, entry)
          @redis.sadd(@processing_set, descriptor)
        end and break [item, descriptor, Time.at(at.to_f)]

        sleep CAS_DELAY # transaction failed. retry!
      end
    end

    def cleanup!(item)
      @redis.srem(@processing_set, item)
    end

    class ItemEnumerator
      include Enumerable

      def initialize(redis, q, uniq)
        @redis = redis
        @q = q
        @uniq = uniq
      end

      PAGE_SIZE = 50

      def each
        start = 0

        while start < size
          elements = self[start, PAGE_SIZE]
          elements.each { |*x| yield(*x) }
          start += elements.size
        end
      end

      def [](start, num = nil)
        elements = @redis.zrange(@q, start, start + (num || 0), :withscores => true)

        v = elements.map do |entry, at|
          item = parse_entry(entry)
          [item, Time.at(at.to_f)]
        end

        num ? v : v.first
      end

      def size
        @redis.zcard(@q)
      end

      def parse_entry(entry)
        if @uniq
          entry
        else
          entry =~ /^\d+:(\S+)$/ or raise InvalidEntryException, entry
          $1
        end
      end
    end

    class InvalidEntryException < StandardError;
    end
  end
end
