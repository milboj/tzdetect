require "tzinfo"
require "tzdetect/error"
require "tzdetect/configuration"

require "tzdetect/parsers/geoname"
require "tzdetect/parsers/google"

require "tzdetect/geocoders/geoname"
require "tzdetect/geocoders/google"

module TZDetect
  class TimeZone
    attr_reader :country_code, :city, :region, :latitude, :longitude, :timezone
  
    # Constructor 
    #
    # * country_code - two character ISO 3166-1 alpha 2 code http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
    # * city 
    # * region - use region 
    # * latitude
    # * longitude
    #
    # == Example
    # 
    # === Country with many timezones without position data. System will find location for Miami and then find timezone
    # 
    #  tz = TimeZone.new("US", "Miami", "Florida")
    #  tz.timezone.name   #  "America/New_York"
    #  tz.latitude        #   25.774265 
    #  tz.longitude       #  -80.193658
    #
    # === Country with many timezones with position data. System will directly find timezone with position data
    #
    #  tz = TimeZone.new("US", "Miami", "Florida", 25.774265, -80.193658)
    #  tz.timezone.name   #  "America/New_York"
    #
    # === Country with one timezone will not return location data 
    #
    #  tz = TimeZone.new("RS", "Novi Sad")
    #  tz.timezone.name   #  "Europe/Belgrade"
    #  tz.latitude        #   nil 
    #  tz.longitude #   nil
    #
    #  
    #
    def initialize country_code, city, region=nil, latitude=nil, longitude=nil
      @country_code = country_code.upcase
      @city      = city
      @region    = region
      @latitude  = latitude
      @longitude = longitude
      timezone!
    end

   

  
    class << self

      # Returns countries codes for countries with more then one timezone
      def countries_with_many_tz
        TZInfo::Country.all.select{|m| m.zones.count > 1}.map{|m| m.code}
      end

      # Detect timezone by country code city region and position data 
      # Returns TZInfo object and raise errors
      def get! country_code, city, region="", latitude=nil, longitude=nil
        m = self.new country_code, city, region, latitude, longitude
        m.timezone
      end

      # Detect timezone by country code city region and position data 
      # Returns TZInfo object and raise errors
      def get country_code, city, region="", latitude=nil, longitude=nil
        begin
          m = self.new country_code, city, region, latitude, longitude
          m.timezone
        rescue Exception 
          nil
        end
      end


      # Detect timezone by latitude and longitude
      # Returns TZInfo raise errors
      def by_location! latitude, longitude
        type = TZDetect::Configuration.service
        case type
        when :google
          geocoder = GoogleParser.new(latitude, longitude)
        when :geoname
          geocoder = GeonameParser.new(latitude, longitude)
        else
          raise TZDetect::Error::Configuration, "wrong configuration for field type"
        end
        TZInfo::Timezone.get geocoder.timezone!
      end


      # Detect timezone by latitude and longitude
      # Returns TZInfo object, if can't find timezone returns nil
      def by_location latitude, longitude
        begin
          self.by_location! latitude, longitude
        rescue Exception 
          nil
        end

      end


      # Detect timezone by latitude and longitude
      # Returns TZInfo object, if can't find timezone returns nil
      def get_location!(country_code, city, region=nil)
        type = TZDetect::Configuration.service
        case type
        when :google
          geocoder = GoogleGeocode.new(country_code, city, region)
        when :geoname
          geocoder = GeonameGeocode.new(country_code, city, region)
        else
          raise TZDetect::Error::Configuration, "wrong configuration for field type"
        end
        geocoder.position!
      end

    end

    private 

    def tz_name!
      @timezone = self.class.by_location! @latitude, @longitude
    end

    def location_fetch!
      location = self.class.get_location!(@country_code, @city, @region)
      @latitude  = location.latitude
      @longitude = location.longitude
      @timezone  =  TZInfo::Timezone.get(location.timezone) unless location.timezone.nil?
    end


    def get_country! 
      begin
        return TZInfo::Country.get(@country_code)
      rescue Exception => e
        raise TZDetect::Error::Base, e
      end
    end
    
    # Returns TZInfo object with detected timezone information 
    # can rise errors
    def timezone!
      if @timezone.nil?

        tz =  get_country! 
        # if country have only one zone then return that zone
        if tz.zones.count == 1
          @timezone = TZInfo::Timezone.get(tz.zones[0].name)
        else
          location_fetch! if @latitude.nil? or @longitude.nil?
          # some services returns timezone when fetch location 
          tz_name! if @timezone.nil?
        end
      end
      return @timezone
    end


  end
end

