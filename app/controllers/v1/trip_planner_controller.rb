module V1
  class TripPlannerController < ApplicationController
    def initialize
      # Can begin by calling the Bank API
      # Keep the response as an Instance Variable
      @country_data = get_country_data
    end

    def index
      render json: {"response": "from index"}
    end

    # accepts the country code - query string params
    # returns the capital city - as json
    def capital_by_country
      # first check for a 3 digit numeric query string
      country_code = params['code'].upcase
      response = {
        country_code: '',
        capital_city: ''
      }

      if valid_country_code(country_code)
        # use @country_data to get the capital.
        @country_data.each do |country|
          if country_code == country['id']
            response['country_code'] = country_code
            response['capital_city'] = country['capitalCity']

            break
          end
        end
      else
        response = {"response": "no results found"}
      end

      render json: response
    end

    def capitals_by_square
      # sort by lat and long - then return the capitals within
      # north of equator = positive lat; south of equator = negative lat
      # west of GMT is negative long; east of GMT is positive long
      coords = {
        min_lat: params['min_lat'].to_f,
        min_long: params['min_long'].to_f,
        max_lat: params['max_lat'].to_f,
        max_long: params['max_long'].to_f,
      }
      response = {
        capitals: []
      }

      @country_data.each do |country|
        if ( country['latitude'] != '' && country['longitude'] != '' )
          # check max/min of input coords
          is_within_area = ( country['latitude'].to_f >= coords[:min_lat] &&
            country['latitude'].to_f <= coords[:max_lat] &&
            country['longitude'].to_f >= coords[:min_long] &&
            country['longitude'].to_f <= coords[:max_long] )

          if is_within_area
            response[:capitals] << country['capitalCity']
          end
        end
      end

      render json: response
    end

    def path_between
      # is there an API to return fastest path? GoogleRoute Finder?
    end

    private

    def get_country_data
      # get the data from the Country API
      response = RestClient.get('http://api.worldbank.org/v2/country?format=json')
      # all country data - array of objects
      JSON.parse(response)[1]
    end

    def valid_country_code(code)
      # only string of letters with length 3
      code.match? /^[a-zA-Z]{3}$/
    end
  end
end
