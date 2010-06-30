module JSE
  class FieldValueTransform
    def initialize(field)
      @field = field
    end

    def apply(hash)
      hash[@field]
    end
  end
end
