module JSE
  class SubsetTransform
    def initialize(*fields)
      @fields = fields
    end

    def apply(json)
      @fields.inject({}) do |result, field|
        result[field] = json[field]
        result
      end
    end
  end
end
