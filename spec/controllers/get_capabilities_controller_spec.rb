require 'spec_helper'

RSpec.describe GetCapabilitiesController, type: :controller do

  describe 'GetCapabilities GET requests' do
    it 'returns http success for a valid GET request' do
      get :index, :params => { :request => 'GetCapabilities', :service => 'CSW', :version => '2.0.2' }
      expect(response).to have_http_status(:success)
    end

    it 'returns bad request for a GET request with an invalid \'service\' parameter' do
      get :index, :params => { :request => 'GetCapabilities', :service => 'BAD', :version => '2.0.2' }
      expect(response).to have_http_status(:bad_request)
    end

    it 'returns bad request for a GET request with an invalid \'version\' parameter' do
      get :index, :params => { :request => 'GetCapabilities', :service => 'CSW', :version => 'BAD_VERSION' }
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe 'GetCapabilities POST requests' do
    it 'returns http success for a valid POST request' do
      valid_get_capabilities_request_xml  = <<-eos
<?xml version="1.0" encoding="UTF-8"?>
<csw:GetCapabilities xmlns:ows="http://www.opengis.net/ows"
        xmlns:xlink="http://www.w3.org/1999/xlink"
        xmlns:gml="http://www.opengis.net/gml"
        xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
        xmlns:ogc="http://www.opengis.net/ogc"
        xmlns:sch="http://www.ascc.net/xml/schematron"
        xmlns:smil20="http://www.w3.org/2001/SMIL20/"
        xmlns:smil20lang="http://www.w3.org/2001/SMIL20/Language"
        xmlns:dct="http://purl.org/dc/terms/"
        xmlns:dc="http://purl.org/dc/elements/1.1/"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://www.opengis.net/cat/csw/2.0.2 CSW-discovery.xsd" service="CSW" version="2.0.2">
</csw:GetCapabilities>
eos
      post :index, body: valid_get_capabilities_request_xml
      expect(response).to have_http_status(:success)
    end
  end

end
