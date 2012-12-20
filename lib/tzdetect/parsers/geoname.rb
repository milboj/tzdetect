require 'json'
require 'net/http'
require File.expand_path(File.dirname(__FILE__) + '/../parser')
    
module TZDetect
  class GeonameParser  
    include Parser

    GEONAME_GEOCODE_TIMEZONE_API = "http://api.geonames.org"
    def timezone! 
      begin

        url =URI("#{GEONAME_GEOCODE_TIMEZONE_API}#{geoname_params}")
        Net::HTTP.start(url.host, url.port, :use_ssl => false) do |http| 
          request = Net::HTTP::Get.new(url.request_uri)
          response = http.request request # Net::HTTPResponse object
          json_result =JSON.parse(response.read_body)["timezoneId"]
          raise "No result" if json_result.nil?
          return json_result
        end
      rescue Exception => e
        raise TZDetect::Error::Parser, e.message
      end
    end
    def geoname_params
      username = Configuration.username
      raise "No geoname useraname" if username.nil?
      "/timezoneJSON?lat=#{@latitude}&lng=#{@longitude}&username=#{username}"
    end
  end
end
