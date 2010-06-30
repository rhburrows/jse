module JSE
  class Filter
    def initialize(field, text)
      @field, @text = field, text
    end

    def match?(json)
      json[@field] == @text
    end
  end
end
