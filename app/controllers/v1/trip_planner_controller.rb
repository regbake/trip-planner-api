module V1
  class TripPlannerController < ApplicationController
    def initialize
      # Can begin by calling the Bank API
      # Keep the response as an Instance Variable
      get_country_data
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

    def capitals_by_area
      # sort by lat and long - then can return the capitals within there
    end

    def path_between
      # is there an API to return fastest path? GoogleWayFinder?
    end

    private

    def get_country_data
      # get the data from the Country API
      response = RestClient.get('http://api.worldbank.org/v2/country?format=json')
      # all country data - array of objects
      @country_data = JSON.parse(response)[1]
    end

    def valid_country_code(code)
      # only letters of length 3
      code.match? /^[a-zA-Z]{3}$/
    end
  end
end
