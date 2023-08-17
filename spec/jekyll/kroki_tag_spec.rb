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
        e = assert_raises(::ArgumentError) do
          @class.new.uri(content: "actor User")
        end
        assert {
          e.message == "missing keywords: :type, :format"
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

  describe "#render_body" do
    describe "only type and format" do
      it {
        assert {
          @class.new.render_body("actor User", opts: {type: "plantuml", format: "svg"})
        }
      }
    end
    describe "alt and caption supplied" do
      it {
        assert {
          @class.new.render_body("actor User", opts: {type: "plantuml", format: "svg", alt: "figure1", caption: "fig1. User"})
        }
      }
    end
  end
end
