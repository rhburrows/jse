module JSE
  class RegexpFilter
    def initialize(field, regexp, options = [])
      @field = field
      # regexp should have leading and trailing '/'
      @regexp = Regexp.new(regexp[1,regexp.size-2], options)
    end

    def match?(json)
      json[@field] =~ @regexp
    end
  end
end
