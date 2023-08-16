# frozen_string_literal: true

require "spec_helper"

describe "Jekyll::KrokiTag::Tag" do
end

describe "Jekyll::KrokiTag::Util" do
  before(:all) {
    @class = Class.new do
      include Jekyll::KrokiTag::Util
    end
  }

  describe "#parse_args" do
    describe "even number and valid args" do
      it "return valid Hash object" do
        assert {
          @class.new.parse_args("type: plantuml format: svg") == {type: "plantuml", format: "svg"}
        }
      end
    end

    describe "even number and invalid args" do
      it "first undefined keyword raise error" do
        e = assert_raises(Jekyll::KrokiTag::Util::KrokiTagArgumentError) {
          @class.new.parse_args("format: svg diagram: plantuml")
        }
        assert { e.message == "diagram" }
      end
    end

    describe "odd number args" do
      it "first undefined keyword raise error" do
        e = assert_raises(Jekyll::KrokiTag::Util::KrokiTagArgumentError) {
          @class.new.parse_args("plantuml format: svg")
        }
        assert { e.message == "plantuml" }
      end
    end

    describe "missing argument `type`" do
      it {
        assert_raises(Jekyll::KrokiTag::Util::KrokiTagArgumentError) do
          @class.new.parse_args("format: svg")
        end
      }
    end
  end

  describe "#uri" do
    describe "valid args" do
      it "return valid URI" do
        assert {
          @class.new.uri(content: "actor User", type: :plantuml, format: :svg).instance_of? URI::HTTPS
        }
      end
    end

    describe "invalid args" do
      it "missing keyword" do
        e = assert_raises(ArgumentError) do
          @class.new.uri(diagram: "actor User")
        end
        assert {
          e.message == "missing keywords: :type, :format, :content"
        }
      end
    end

    describe "unsafe string" do
      it "return escaped valid URI" do
        assert {
          u = @class.new.uri(type: "foo bar", format: "gif", content: "actor User")
          URI::UNSAFE !~ u.to_s
        }
      end
    end
  end
end
