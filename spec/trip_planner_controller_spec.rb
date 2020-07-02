require 'rails_helper'

RSpec.describe 'setup tests' do
  it 'should pass' do
    expect(10).to be(10)
    expect(20).not_to be(10)
  end

  xit 'should throw failure' do
    expect(10).to be(20)
  end
end

RSpec.describe 'trip planner API', :type => :request do
  xcontext 'an /index endpoint that serves JSON' do
    before(:all) do
      get '/v1/index'
    end

    it 'returns a valid status code' do
      expect(response).to have_http_status(200)
      expect(response).not_to have_http_status(404)
    end

    it 'returns JSON' do
      parsed_response = JSON.parse(response.body)

      expect(parsed_response['response']).to eq('from index')
    end
  end

  xcontext 'an endpoint that returns the capital city' do
    # should GET a 3 digit country code and receive a capital city
    # should return 'not found' if unavailable or edge-case (numbers, >3 char)

    # Country: CHL, name: Chile, capital Santiago, long: "-70.6475" lat: "-33.475"
    # Country: CHN, Name: China, Capital: Beijing, long: "116.286" lat: "40.0495"

    # before(:all) do

    # end

    it 'returns a valid status code' do
      get '/v1/capital_by_country', :params => {code: 'CHL'}

      expect(response).to have_http_status(200)
      expect(response).not_to have_http_status(404)
    end

    it 'returns "no results" for a non-numeric code' do
      get '/v1/capital_by_country', :params => {code: 'a99'}

      expect(JSON.parse(response.body)['response']).to eq('no results found')
    end

    it 'returns "no results" for a non-3 length string' do
      get '/v1/capital_by_country', :params => {code: 'abcd'}

      expect(JSON.parse(response.body)['response']).to eq('no results found')
    end

    it 'returns "no results" for a non-3 length string' do
      get '/v1/capital_by_country', :params => {code: 'ab'}

      expect(JSON.parse(response.body)['response']).to eq('no results found')
    end

    it 'returns the capital of CHL as Santiago' do
      get '/v1/capital_by_country', :params => {code: 'Chl'}

      expect(JSON.parse(response.body)['capital_city']).to eq('Santiago')
    end
  end

  context 'and endpoint that returns capital cities within lat/long' do
    it 'returns a valid status code' do
      get '/v1/capitals_by_square', :params => {
        # bottom left to top right of north america
        min_lat: '8.000',
        max_lat: '67.000',
        min_long: '-170.000',
        max_long: '-56.000'
      }

      expect(response).to have_http_status(200)
      expect(response).not_to have_http_status(500)
    end

    it 'finds a capital city' do
      get '/v1/capitals_by_square', :params => {
        # around Chile, should target Santiago
        min_lat: '-30.000',
        max_lat: '-37.000',
        min_long: '-76.000',
        max_long: '-66.000'
      }

      expect(JSON.parse(response.body)['capitals']).not_to be_empty
    end
  end

  xcontext 'an endpoint that returns an efficient route between 4 capitals' do
  end
end