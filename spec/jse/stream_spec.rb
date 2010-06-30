require 'spec_helper'

module JSE
  describe Stream do
    class PassingFilter
      def match?(line)
        true
      end
    end

    class FailingFilter
      def match?(line)
        false
      end
    end

    class NotFirstFilter
      def initialize
        @matched = false
      end

      def match?(n)
        if @matched
          true
        else
          @matched = true
          false
        end
      end
    end

    let(:inner){ mock("Inner Stream") }
    let(:stream){ Stream.new(inner) }

    describe "#each_line" do
      it "yields every line that matches all the filters" do
        inner.stub(:each_line).and_yield("{\"value\":1}").
          and_yield("{\"value\":2}")
        stream.filters = [PassingFilter.new]
        results = []
        stream.each_line do |l|
          results << l
        end
        results.should == ["{\"value\":1}", "{\"value\":2}"]
      end

      it "doesn't yields lines that don't match filters" do
        inner.stub(:each_line).and_yield("{\"value\":1}").
          and_yield("{\"value:\":2}")
        stream.filters = [FailingFilter.new]
        results = []
        stream.each_line do |l|
          results << l
        end
        results.should == []
      end

      it "works with multiple filters" do
        inner.stub(:each_line).and_yield("{\"value\":1}").
          and_yield("{\"value\":2}").
          and_yield("{\"value\":4}")
        stream.filters = [NotFirstFilter.new, NotFirstFilter.new]
        results = []
        stream.each_line do |l|
          results << l
        end
        results.should == ["{\"value\":4}"]
      end
    end

    describe "#filter!" do
      it "adds a new filter to the list" do
        stream.filters = []
        stream.filter!('field', 'text')
        stream.filters.size.should == 1
      end

      it "adds a normal filter if it looks like a string" do
        stream.filters = []
        stream.filter!('field', 'text')
        stream.filters.first.class.should == JSE::Filter
      end

      it "adds a regexp filter if it looks like a regexp" do
        stream.filters = []
        stream.filter!('field', '/^regexp$/')
        stream.filters.first.class.should == JSE::RegexpFilter
      end
    end
  end
end
