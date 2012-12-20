module TZDetect
  module Parser
    attr_accessor :latitude, :longitude
    def initialize lat, lon
      lat = lat.to_f if lat.kind_of? Integer
      lon = lon.to_f if lon.kind_of? Integer
      valid_latitude_and_longitude lat, lon
      raise TZDetect::Error::Parser, "lat and long must be float" if !lat.kind_of?(Float) || !lon.kind_of?(Float)
      @latitude  = lat
      @longitude = lon
    end
    
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def timezone! lat, lon
        t = self.new lat, lon
        t.timezone
      end
    end

    def timezone
      begin
        m = self.timezone!
      rescue
        m = nil
      end
    end

    private
    def valid_latitude_and_longitude lat, lon
      raise TZDetect::Error::Parser, "latitude and longitude must be number" if !lat.kind_of?(Float) || !lon.kind_of?(Float)
      raise TZDetect::Error::Parser, "latitude must be beetween -90 and 90 degrees" if lat < -90 || lat > 90
      raise TZDetect::Error::Parser, "longitude must be beetween -180 and 180 degrees" if lon < -180 || lon > 180
    end


  end
end
