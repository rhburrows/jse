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

    class ValueUpcaseTransform
      def apply(json)
        updated = json.dup
        updated['value'] = json['value'].upcase
        updated
      end
    end

    class ValueDoubleTransform
      def apply(json)
        updated = json.dup
        updated['value'] = json['value'] + json['value']
        updated
      end
    end

    let(:inner){ mock("Inner Stream") }
    let(:stream){ Stream.new(inner) }

    describe "#each_line" do
      before do
        inner.stub(:each_line).and_yield("{\"value\":\"a\"}").
          and_yield("{\"value\":\"b\"}").
          and_yield("{\"value\":\"c\"}")
      end

      it "yields every line that matches all the filters" do
        stream.filters = [PassingFilter.new]
        results = []
        stream.each_line do |l|
          results << l
        end
        results.should == [ "{\"value\":\"a\"}",
                            "{\"value\":\"b\"}",
                            "{\"value\":\"c\"}" ]
      end

      it "doesn't yields lines that don't match filters" do
        stream.filters = [FailingFilter.new]
        results = []
        stream.each_line do |l|
          results << l
        end
        results.should == []
      end

      it "works with multiple filters" do
        stream.filters = [NotFirstFilter.new, NotFirstFilter.new]
        results = []
        stream.each_line do |l|
          results << l
        end
        results.should == ["{\"value\":\"c\"}"]
      end

      it "yeilds every line if there are no filters" do
        stream.filters = []
        results = []
        stream.each_line do |l|
          results << l
        end
        results.should == [ "{\"value\":\"a\"}",
                            "{\"value\":\"b\"}",
                            "{\"value\":\"c\"}" ]
      end

      it "runs all transforms on the lines" do
        stream.transforms = [ValueUpcaseTransform.new,
                             ValueDoubleTransform.new,
                             ToJsonTransform.new]
        results = []
        stream.each_line do |l|
          results << l
        end
        results.should == ["{\"value\":\"AA\"}",
                           "{\"value\":\"BB\"}",
                           "{\"value\":\"CC\"}"]
      end
    end

    describe "#filter!" do
      before do
        stream.filters = []
      end

      it "adds a new filter to the list" do
        stream.filter!('field', 'text')
        stream.filters.size.should == 1
      end

      it "adds a normal filter if it looks like a string" do
        stream.filter!('field', 'text')
        stream.filters.first.class.should == JSE::Filter
      end

      it "uses a case insensitive filter for exact string matches" do
        stream.filter!('field', 'text', true)
        stream.filters.first.class.should == JSE::CaseInsensitiveFilter
      end

      it "adds a regexp filter if it looks like a regexp" do
        stream.filter!('field', '/^regexp$/')
        stream.filters.first.class.should == JSE::RegexpFilter
      end
    end

    describe "#print!" do
      before do
        stream.transforms = []
      end

      context "only on field is specified" do
        it "adds on transform" do
          stream.print!('field')
          stream.transforms.size.should == 1
        end
      end

      context "multiple fields are specified" do
        it "adds two transforms" do
          stream.print!('field', 'other')
          stream.transforms.size.should == 2
        end

        it "adds a to_json_transform on the end" do
          stream.print!('field', 'other')
          stream.transforms.last.class.should == ToJsonTransform
        end
      end
    end
  end
end
