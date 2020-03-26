require 'spec_helper'

RSpec.describe DescribeRecordController, type: :controller do

  describe 'GET #index' do
    it 'returns http success' do
      get :index, :params => { :request => 'DescribeRecord', :service => 'CSW', :version => '2.0.2' }
      expect(response).to have_http_status(:success)
    end
  end

end
