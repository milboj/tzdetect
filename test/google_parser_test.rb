require 'tzdetect'
require 'test/unit'

require 'helper'
class TZDetect::ParserTest < Test::Unit::TestCase
  include TZDetect

  def test_google_parser
    assert_nothing_raised do
      parsed =  TZDetect::GoogleParser.new(12.2, 25.0) 

      parsed.timezone!
      parsed =  TZDetect::GoogleParser.new(12, 25) 
    end
  end
  def test_bad_inputs
    assert_raises Error::Parser do
      TZDetect::GoogleParser.new(12.2, "dd") 
    end
    assert_raises Error::Parser do
      TZDetect::GoogleParser.new("dd", "tghyj") 
    end
    assert_raises Error::Parser do
      TZDetect::GoogleParser.new(91, 1) 
    end
    assert_raises Error::Parser do
      TZDetect::GoogleParser.new(89.99, 181.1) 
    end

    assert_raises Error::Parser do
      TZDetect::GoogleParser.new(91.1, 181.1) 
    end
  end

  def test_class_method 
    assert_nothing_raised do
       TZDetect::GoogleParser.timezone!(12.2, 25.0) 

    end
  end
  def test_zones
    zones = {
      "Europe/Belgrade"=> [44.2,22.0], 
      "Africa/Tripoli" => [27.2,22.0],
      "Africa/Johannesburg" => [-27.2,22.0]}
    zones.each {|key, value|
      assert_equal(key, TZDetect::GoogleParser.timezone!(value[0], value[1]))
    }
  end

end

