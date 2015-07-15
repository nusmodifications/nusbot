module NUSBotgram
  class Algorithms
    def initialize
    end

    public

    def bubble_sort(container)
      loop do
        swapped = false
        (container.size - 1).times do |i|
          if (container[i] <=> container[i + 1]) == 1
            container[i], container[i + 1] = container[i + 1], container[i] # Swap
            swapped = true
          end
        end
        break unless swapped
      end

      container
    end
  end
end