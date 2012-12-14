require 'tzdetect'
require 'test/unit'


class TZDetect::ParserTest < Test::Unit::TestCase
  include TZDetect
  GEONAME_USERNAME= "milboj"
  def test_no_configured_user  
    assert_raises Error::GeoCoder do
      geocoder =  GeonameGeocode.new("LL", "GDSAFDSAF")
      geocoder.position!
      
    end

  end
  def test_geoname_get_location 
    
    assert_nothing_raised do
      TZDetect::Configuration.username = GEONAME_USERNAME
      geocoder =  GeonameGeocode.new("RS", "Novi Sad")
      geocoder.position!
      assert_instance_of Float, geocoder.latitude
      assert_instance_of Float, geocoder.longitude
    end
  end

  def test_geoname_wrong_location 
    
    assert_raises Error::GeoCoder do
      TZDetect::Configuration.username = GEONAME_USERNAME
      geocoder =  GeonameGeocode.new("LL", "tghyjukl")
      geocoder.position!
    end
  end
end


