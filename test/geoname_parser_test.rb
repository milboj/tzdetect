require 'tzdetect'
require 'test/unit'
class TZDetect::ParserTest < Test::Unit::TestCase
  include TZDetect
  def test_geoname_parser_not_configured_username
    assert_raises Error::Parser do
      TZDetect::Configuration.username = nil
      ge = TZDetect::GeonameParser.new(44.2, 22.0) 
      ge.timezone!
    end
  end
  def test_class_method 
    assert_nothing_raised do
      TZDetect::Configuration.username = GEONAME_USERNAME
      ge = TZDetect::GeonameParser.timezone!(12.2, 25.0) 
      ge.timezone!

    end
  end
  def test_geoname_parser_bad_input
    assert_raises Error::Parser do
      ge = TZDetect::GeonameParser.new(44.2, "gthyju") 
      ge.timezone!
    end
  end
  def test_zones
    TZDetect::Configuration.username = GEONAME_USERNAME
    zones = {
      "Europe/Belgrade"=> [44.2,22.0], 
      "Africa/Tripoli" => [27.2,22.0],
      "Africa/Johannesburg" => [-27.2,22.0]}
    zones.each {|key, value|
      assert_equal(key, TZDetect::GeonamParser.timezone!(value[0], value[1]))
    }
  end

end
