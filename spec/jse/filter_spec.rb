require 'spec_helper'
require 'json'

module JSE
  describe Filter do
    describe "#match?" do
      it "returns true if the passed json has a field with matching text" do
        filter = Filter.new('field', 'text')
        json = JSON.parse('{"field":"text"}')
        filter.match?(json).should be_true
      end

      it "returns false if the passed json has no field with matching text" do
        filter = Filter.new('field', 'text')
        json = JSON.parse('{"asdf":"fdas"}')
        filter.match?(json).should be_false
      end

      it "returns false if it has a field but the text doesn't match" do
        filter = Filter.new('field', 'text')
        json = JSON.parse('{"field":"nope"}')
        filter.match?(json).should be_false
      end
    end
  end
end
