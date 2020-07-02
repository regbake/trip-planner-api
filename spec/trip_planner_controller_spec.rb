require 'rails_helper' # include for requests

RSpec.describe 'setup tests' do
  it 'should pass' do
    expect(10).to be(10)
    expect(20).not_to be(10)
  end

  xit 'should throw failure to verify no false positives' do
    expect(10).to be(20)
  end
end

RSpec.describe 'trip planner API', :type => :request do
  context 'an /index endpoint that serves JSON' do
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

  context 'an endpoint that returns the capital city' do
    # should GET a 3 digit country code and receive a capital city
    # should return 'not found' if unavailable or edge-case (numbers, >3 char)

    # Country: CHL, name: Chile, capital Santiago, long: "-70.6475" lat: "-33.475"
    # Country: CHN, Name: China, Capital: Beijing, long: "116.286" lat: "40.0495"
    it 'returns a valid status code' do
      get '/v1/capital_by_country', :params => {code: 'CHL'}

      expect(response).to have_http_status(200)
      expect(response).not_to have_http_status(404)
      expect(response).not_to have_http_status(500)
    end

    it 'returns "no results" for a non-numeric code' do
      get '/v1/capital_by_country', :params => {code: 'a99'}

      expect(JSON.parse(response.body)['response']).to eq('no results found')
    end

    it 'returns "no results" for a non-numeric code' do
      get '/v1/capital_by_country', :params => {code: 'a**'}

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

    it 'returns the capital of CHN as Beijing' do
      get '/v1/capital_by_country', :params => {code: 'chn'}

      expect(JSON.parse(response.body)['capital_city']).to eq('Beijing')
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

    it 'finds a capital city in Chile' do
      get '/v1/capitals_by_square', :params => {
        # around Chile, should target Santiago
        max_lat: '-30.000',
        min_lat: '-37.000',
        min_long: '-76.000',
        max_long: '-66.000'
      }

      capitals = JSON.parse(response.body)['capitals']

      expect(capitals).not_to be_empty
      expect(capitals[0]).to eq('Santiago')
    end

    it 'finds capital cities in Europe' do
      get '/v1/capitals_by_square', :params => {
        # Italy to Russia
        max_lat: '64.000',
        min_lat: '38.000',
        min_long: '8.000',
        max_long: '50.000'
      }

      capitals = JSON.parse(response.body)['capitals']

      expect(capitals).not_to be_empty
      expect(capitals).to include('Vienna')
    end

    it 'should find no capital cities' do
      get '/v1/capitals_by_square', :params => {
        # way north
        max_lat: '84.000',
        min_lat: '79.000',
        min_long: '123.000',
        max_long: '209.000'
      }

      capitals = JSON.parse(response.body)['capitals']

      expect(capitals).to be_empty
      expect(capitals).not_to include('Vienna')
    end
  end

  xcontext 'an endpoint that returns an efficient route between 4 capitals' do
  end
end