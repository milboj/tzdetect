require 'tzdetect'
require 'test/unit'
class TZDetect::MainTest < Test::Unit::TestCase
  include TZDetect
  GEONAME_USERNAME= "milboj"
  def test_not_all_properties 
    assert_raises ArgumentError do
       TimeZone.new()
    end
    assert_raises ArgumentError do
      TZDetect::Configuration.service = :geo
    end
  end
  def test_geoname_get_location 
    assert_nothing_raised do
      TZDetect::Configuration.username = GEONAME_USERNAME
      TZDetect::Configuration.service = :geoname
      tz = TimeZone.new("RS", "Novi Sad")
      m = tz.timezone
      assert_kind_of  TZInfo::DataTimezone, m
      assert_equal m.name, "Europe/Belgrade"
    end
  end
  def test_google_get_location 
    assert_nothing_raised do
      TZDetect::Configuration.service = :google
      tz = TimeZone.new("RS", "Novi Sad")
      m = tz.timezone
      assert_kind_of  TZInfo::DataTimezone, m
      assert_equal m.name, "Europe/Belgrade"
    end
  end
  def test_google_get_location_small_countyr 
      TZDetect::Configuration.service = :google
      tz = TimeZone.new("rs", "Novi Sad")
      m = tz.timezone
      assert_kind_of  TZInfo::DataTimezone, m
      assert_equal m.name, "Europe/Belgrade"
  end
  def test_google_get_location_us_static 
      TZDetect::Configuration.service = :google
      tz = TimeZone.get_location!("US", "Miami", "Florida")
      assert_kind_of  TZDetect::Position, tz
  end
  def test_google_get_location_us 
      TZDetect::Configuration.service = :google
      tz = TimeZone.new("US", "Miami", "Florida")
      m = tz.timezone
      assert_kind_of  TZInfo::DataTimezone, m
      assert_equal  m.name, "America/New_York"
  end
  def test_geoname_get_location_us 
      TZDetect::Configuration.service = :geoname
      tz = TimeZone.new("US", "Miami", "Florida")
      m = tz.timezone
      assert_kind_of  TZInfo::DataTimezone, m
      assert_equal  m.name, "America/New_York"
  end
  def test_wrong_country 
    assert_raises Error::Base do
      TZDetect::Configuration.service = :google
      tz = TimeZone.new("ll", "burutifdas")
      m = tz.timezone
      assert_kind_of  tzinfo::datatimezone, m
    end
  end
  def test_wrong_country_code_google 
    assert_raises Error::Base do
      TZDetect::Configuration.service = :geoname
      tz = TimeZone.new("LL", "buruti")
      tz.timezone
    end
  end
  def test_static_by_location 
      tz = TimeZone.by_location(44.21, 21.0)
      assert_kind_of  TZInfo::DataTimezone, tz
      assert_equal  tz.name, "Europe/Belgrade"
  end

  def test_static
      m = TimeZone.get("rs", "Novi Sad")
      assert_kind_of  TZInfo::DataTimezone, m
      assert_equal m.name, "Europe/Belgrade"
  end


end


