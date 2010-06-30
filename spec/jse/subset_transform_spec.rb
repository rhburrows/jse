require 'spec_helper'

module JSE
  describe SubsetTransform do
    describe "#apply" do
      it "returns the set of fields as a json object" do
        transform = SubsetTransform.new('name', 'value')
        json = JSON.parse("{\"name\":\"n\", \"value\":\"v\", \"id\":1}")
        transform.apply(json).to_json.should ==
          "{\"name\":\"n\",\"value\":\"v\"}"
      end
    end
  end
end
