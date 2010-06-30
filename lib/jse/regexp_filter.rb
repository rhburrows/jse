module JSE
  class RegexpFilter
    def initialize(field, regexp)
      @field = field
      # regexp should have leading and trailing '/'
      @regexp = Regexp.new(regexp[1,regexp.size-2])
    end

    def match?(json)
      json[@field] =~ @regexp
    end
  end
end
