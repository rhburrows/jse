require 'spec_helper'

module JSE
  describe CaseInsensitiveFilter do
    describe "#match?" do
      it "matches if the fields match ignoring case" do
        filter = CaseInsensitiveFilter.new('field', 'VaLuE')
        filter.match?({ 'field' => 'value' }).should be_true
      end

      it "doesn't match if the fields don't match" do
        filter = CaseInsensitiveFilter.new('field', 'VaLuE')
        filter.match?({ 'field' => 'other' }).should_not be_true
      end
    end
  end
end
