require 'spec_helper'

RSpec.describe HealthController do
  describe 'GET index' do
    it 'returns good status' do
      VCR.use_cassette 'models/health/cmr_good', :decode_compressed_response => true, :record => :once do
        get :index, :format => :json 
        expect(response.code.to_s).to eq('200')
        expect(response.body).to eq('{"cmr-search":{"ok?":true}}')
      end
    end
    it 'returns bad status' do
      VCR.use_cassette 'models/health/cmr_bad', :decode_compressed_response => true, :record => :once do
        get :index, :format => :json
        expect(response.code.to_s).to eq('503')
        expect(response.body).to eq('{"cmr-search":{"ok?":false}}')
      end
    end
  end
end
