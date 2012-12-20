module TZDetect
  Position = Struct.new(:latitude, :longitude, :timezone)
  module Geocoder
    attr_accessor :city, :country, :region
    attr_reader   :latitude, :longitude, :timezone

    # Constructor initalize country city and region 
    def initialize country, city, region=""
      @country = country
      @city    = city
      @region  = region
    end


    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      # Returns location position hash
      #
      #  *latitude
      #  *longitude
      #  *timezone - can be nil 
      #
      def self.get country, city, region=""
        location = self.new country, city, region
        location.position
      end

      # Returns location position hash (raise exception)
      #
      #  *latitude
      #  *longitude
      #  *timezone - can be nil 
      #
      def self.get! country, city, region=""
        location = self.new country, city, region
        return location.position!
      end
    end



    # Returns position 
    def postion
      begin
        self.postion! 
      rescue 
        nil
      end
    end

    # Returns position raise excpetion 
    def position!
      raise TZDetect::Error::Geocoder, "not implemented method position!"
    end

    def fetched_data
      Position.new(@latitude, @longitude, @timezone)
    end

  end
end
