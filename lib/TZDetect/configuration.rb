module TZDetect
  class Configuration
    ALLOWED_TYPES= [:google, :geoname] 

    @@google_signature  = nil
    @@google_client_key = nil

    def self.service= type
      raise ArgumentError, "wrong service type" unless ALLOWED_TYPES.include?(type.to_sym)
      @@service= type
    end
    
    def self.service
      @@service ||= :google
    end

    def self.google_client_key
      @@google_client_key 
    end

    def self.google_client_key= google_key
      @@google_client_key= google_key
    end

    def self.google_signature
      @@google_signature 
    end

    def self.google_signature= google_signature
      @@google_key= google_signature
    end


    def self.username= username
      @@username = username
    end
    
    def self.username
      @@username 
    end

    def self.begin
      yield self
    end

    protected
    # Merge this params Set params https://developers.google.com/maps/documentation/business/webservices
    def self.google_params
      params             = {}
      params[:client]    = @@google_client_key unless @@google_client_key.nil?
      params[:signature] = @@google_signature unless @@google_signature.nil?
      return params
    end

  end
end
