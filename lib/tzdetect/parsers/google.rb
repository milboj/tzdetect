require 'json'
require 'net/http'
require File.expand_path(File.dirname(__FILE__) + '/../parser')
    
module TZDetect
  class GoogleParser 
    include Parser
    GOOGLE_GEOCODE_TIMEZONE_API = "https://maps.googleapis.com/maps/api/timezone/json"

    def timezone! 
      begin
        url =URI(GOOGLE_GEOCODE_TIMEZONE_API)
        url.query = URI.encode_www_form(self.params)
        Net::HTTP.start(url.host, url.port, :use_ssl => true) do |http| 
          request = Net::HTTP::Get.new(url.request_uri)
          response = http.request request # Net::HTTPResponse object
          json_result =JSON.parse(response.read_body)
          if json_result["status"] == "OK"
            json_result["timeZoneId"]
          else
            raise "No result"
          end
        end
      rescue Exception => e
        raise TZDetect::Error::Parser, e.message
      end
    end


    def params
        timestamp = Time.now.to_i
        {:location =>"#{@latitude},#{@longitude}", :timestamp=>"#{timestamp}", :sensor=>"false"}.merge(Configuration.google_params) 
    end

  end
end
