# TZDetect

Detects timezone by address or location, using google or geoname web services.
It will utilaze web services only if can't detect timezone by country code (when country has only one timezone) 

Procedure for detecting time zone:

1. Looks tah given country has only one time zone 
2. Fetching time zone data through web services if position (latitude and longitude) is given
3. First detects position for given country, city and region and then fetch timezone data from web

## Installation

Add this line to your application's Gemfile:

    gem 'tzdetect'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tzdetect

## Configuration 

Can be set through block:

    TZDetect::Configuration.begin do |c|
      c.username = 'your_geonames_username'
    end

or 
    TZDetect::Configuration.service = :geoname
    TZDetect::Configuration.username = "username"

Configuration params:

* service - service name can be :google or :geoname - default google
* username - username for geoname service
* google_client_key = google api key (not tested )
* google_signature = google api signature (not tested )
  
If you use geoname service, make sure you have a geonames username. It's free and easy to setup, you can do so [here](http://www.geonames.org/login).

## Usage

Country with many timezones without position data: System will find location for Miami and then find timezone
 
    tz = TimeZone.new("US", "Miami", "Florida")
    tz.timezone.name   #  "America/New_York"
    tz.latitude        #   25.774265 
    tz.longitude       #  -80.193658

Country with many time zones with position data: System will directly find timezone with position data

    tz = TimeZone.new("US", "Miami", "Florida", 25.774265, -80.193658)
    tz.timezone.name   #  "America/New_York"

Country with one time zone will not return location data 

    tz = TimeZone.new("RS", "Novi Sad")
    tz.timezone.name   #  "Europe/Belgrade"
    tz.latitude        #   nil 
    tz.longitude       #   nil


## Class methods  

### Get timezone by location

Return TZInfo object 

    tz = TimeZone.get!("RS", "Novi Sad")
    tz.name   #  "Europe/Belgrade" 
    
    tz = TimeZone.new("US", "Miami", "Florida", 25.774265, -80.193658)
    tz.name   #  "America/New_York"

###  Getting the timezone for a specific latitude and longitude

You can use class method by_location

    TZDetect::TimeZone.by_location! 44.21, 21.0 


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
