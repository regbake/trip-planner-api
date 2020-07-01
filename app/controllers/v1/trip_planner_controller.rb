module V1
  class TripPlannerController < ApplicationController
    def initialize

    end

    def index
      render json: {"response": "from index"}
    end

    def capital_by_country
      # accepts the country code
      # returns the capital city
    end

    def capitals_by_area
    end

    def path_between
      #
    end
  end
end
