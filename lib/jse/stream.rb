require 'json'

module JSE
  class Stream
    attr_accessor :filters, :transforms
    attr_reader :inner

    def initialize(inner)
      @inner = inner
      @transforms = []
      @filters = []
    end

    def each_line
      inner.each_line do |line|
        unless filter_chain.eliminates?(line)
          yield transform_chain.apply(line)
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

    def print!(*field_list)
      if field_list.size == 1
        transforms << FieldValueTransform.new(field_list[0])
      else
        transforms << SubsetTransform.new(*field_list)
        transforms << ToJsonTransform.new
      end
    end

    private

    def looks_like_regexp?(string)
      string[0,1] == '/' && string[string.size-1,1] == '/'
    end

    def transform_chain
      TransformChain.new(transforms)
    end

    class TransformChain
      def initialize(transforms)
        @transforms = transforms
      end

      def apply(line)
        begin
          if @transforms.empty?
            line
          else
            json = JSON.parse(line)
            @transforms.inject(json){ |j, transform| transform.apply(j) }
          end
        rescue JSON::ParserError
          $stderr.puts "Error parsing line:"
          $stderr.puts line
          true
        end
      end
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
