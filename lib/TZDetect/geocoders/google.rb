require 'json'
require 'net/http'
require File.expand_path(File.dirname(__FILE__) + '/../geocoder')

module TZDetect
  class GoogleGeocode  
    include Geocoder
    GOOGLE_GEOCODE_API = "https://maps.google.com/maps/api/geocode/json"


    # Returns position 
    def position! 
        other = @region.nil? ? @country : "#{@region},#{@country}"
        address = "#{@city},#{other}"
        position = self.class.fetch_by_address!(address)
        @latitude = position["lat"]
        @longitude = position["lng"]
        return fetched_data
    end


    # Find position by addresss
    def self.fetch_by_address! address
      begin 
        url =URI(GOOGLE_GEOCODE_API)
        url.query = URI.encode_www_form(self.params(address))
        Net::HTTP.start(url.host, url.port, :use_ssl => true) do |http| 
          request = Net::HTTP::Get.new(url.request_uri)
          response = http.request request # Net::HTTPResponse object
          json_result =JSON.parse(response.read_body)
          if json_result["status"] == "OK"
            return  json_result["results"][0]["geometry"]["location"]
          else 
            raise "no results"
          end
        end
      rescue Exception => e
        raise TZDetect::Error::GeoCoder, e.message
      end
    end

    # Set params https://developers.google.com/maps/documentation/business/webservices
    def self.params address
      {:address=> address, :sensor=>"false"}.merge(Configuration.google_params) 
    end

  end

end
