require 'json'
require 'net/http'
require File.expand_path(File.dirname(__FILE__) + '/../geocoder')

module TZDetect
  class GeonameGeocode  
    include Geocoder
    GEONAME_GEOCODE_API = "http://api.geonames.org/searchJSON"

    # Returns position 
    def position! 
      begin 

        url =URI(GEONAME_GEOCODE_API)
        url.query = URI.encode_www_form(geoname_params)

        Net::HTTP.start(url.host, url.port, :use_ssl => false) do |http| 
          request = Net::HTTP::Get.new(url.request_uri)
          response = http.request request # Net::HTTPResponse object
          json_result =JSON.parse(response.read_body)

          if !json_result["geonames"].nil? and !json_result["geonames"].empty?
            geoname = json_result["geonames"][0]
            @latitude  = geoname["lat"]
            @longitude = geoname["lng"]
            @timezone  = geoname["timezone"]["timeZoneId"]
            return fetched_data
          else 
            raise "no results"
          end
        end
      rescue Exception => e
        raise TZDetect::Error::GeoCoder, e.message
      end
    end

    private
    def geoname_params
      username = Configuration.username
      raise "no geoname username configured" if username.nil?
      address = @region.nil? ? @city : "#{@city},#{@region}"
      return {:q=> address, :country=>@country, :formated => "true",:maxRows => 5, :username => username, :style => "FULL" }
    end

  end

end
