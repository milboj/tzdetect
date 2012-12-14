require 'tzdetect'
require 'test/unit'

class TZDetect::ParserTest < Test::Unit::TestCase
  include TZDetect
  def test_get_location 
    
    assert_nothing_raised do
      geocoder =  GoogleGeocode.new("RS", "Novi Sad")
      geocoder.position!
      assert_instance_of Float, geocoder.latitude
      assert_instance_of Float, geocoder.longitude
    end
  end

  def test_wrong_location 
    
    assert_raises Error::GeoCoder do
      geocoder =  GoogleGeocode.new("LL", "rfgthjklfads f")
      geocoder.position!

    end
  end
end


