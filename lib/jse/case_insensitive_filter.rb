module JSE
  class CaseInsensitiveFilter
    def initialize(field, text)
      @field, @text = field, text
    end

    def match?(json)
      json[@field] && json[@field].upcase == @text.upcase
    end
  end
end
