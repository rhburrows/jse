module JSE
  class ToJsonTransform
    def apply(obj)
      obj.to_json
    end
  end
end
