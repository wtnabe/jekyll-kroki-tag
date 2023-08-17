require "spec_helper"

describe Jekyll::KrokiTag::OptionParser do
  before(:all) {
    @class = Jekyll::KrokiTag::OptionParser
  }

  describe "#parse" do
    describe "valid as ruby hash syntax" do
      it 'return hash and default value applied' do
        assert {
          @class.parse("type: 'plantuml'") == {type: "plantuml", format: "svg"}
        }
      end
    end

    describe "invalid as ruby hash syntax ( string literal required )" do
      it {
        e = assert_raises(Jekyll::KrokiTag::ArgumentError) do
          @class.parse("type: plantuml")
        end
        assert {
          e.message =~ /Did you write invalid syntax \?/
        }
      }
    end

    describe "invalid ruby syntax" do
      it {
        assert_raises(Jekyll::KrokiTag::SyntaxError) do
          @class.parse("type: 'plantuml' alt: 'alt'")
        end
      }
    end

    describe "valid multi items" do
      describe "thru" do
        it {
          assert {
            @class.parse("type: 'plantuml', format: 'png', alt: 1, caption: 1.1") == {type: "plantuml", format: "png", alt: 1, caption: 1.1}
          }
        }
      end
      describe "downcase type and format" do
        it {
          assert {
            @class.parse("type: 'PlantUML', format: 'pNG', alt: 'A'") == {type: "plantuml", format: "png", alt: "A"}
          }
        }
      end
    end

    describe "invalid args" do
      it "first undefined keyword raise error" do
        e = assert_raises(Jekyll::KrokiTag::ArgumentError) {
          @class.parse("format: 'svg', diagram: 'plantuml'")
        }
        assert { e.message =~ /is not allowed keyword/ }
      end
    end

    describe "missing argument `type`" do
      it {
        e = assert_raises(Jekyll::KrokiTag::MissingRequiredArgument) do
          @class.parse("format: 'svg'")
        end
        assert {
          e.message =~ /is missing/
        }
      }
    end
  end
end
