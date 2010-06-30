require 'json'

module JSE
  class Stream
    attr_accessor :filters
    attr_reader :inner

    def initialize(inner)
      @inner = inner
      @filters = []
    end

    def each_line
      inner.each_line do |line|
        unless filter_chain.eliminates?(line)
          yield line
        end
      end
    end

    def filter!(field, text)
      if looks_like_regexp?(text)
        filters << RegexpFilter.new(field, text)
      else
        filters << Filter.new(field, text)
      end
    end

    private

    def looks_like_regexp?(string)
      string[0,1] == '/' && string[string.size-1,1] == '/'
    end

    def filter_chain
      FilterChain.new(filters)
    end

    class FilterChain
      def initialize(filters)
        @filters = filters
      end

      def eliminates?(line)
        begin
          json = JSON.parse(line)
          !@filters.all?{ |f| f.match?(json) }
        rescue JSON::ParserError
          $stderr.puts "Error parsing line:"
          $stderr.puts line
          true
        end
      end
    end
  end
end
