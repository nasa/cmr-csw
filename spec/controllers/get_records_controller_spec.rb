require 'spec_helper'

RSpec.describe GetRecordsController, type: :controller do

  describe 'GetRecords GET requests' do
    it "returns bad request for a GET request with an invalid 'service' parameter" do
      get :index, :params => { :request => 'GetRecords', :service => 'BAD', :version => '2.0.2' }
      expect(response).to have_http_status(:bad_request)
    end

    it "returns bad request for a GET request with an invalid 'version' parameter" do
      get :index, :params => { :request => 'GetRecords', :service => 'CSW', :version => 'BAD_VERSION' }
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe 'GetRecords POST requests' do
    it 'returns http success for a valid POST request' do
      VCR.use_cassette 'requests/get_records/gmi/controller_success', :decode_compressed_response => true, :record => :once do
        valid_get_records_request_xml = <<-eos
<?xml version="1.0" encoding="UTF-8"?>
<csw:GetRecords maxRecords="10" outputFormat="application/xml"
    outputSchema="http://www.isotc211.org/2005/gmi" resultType="results" service="CSW"
    startPosition="1" version="2.0.2" xmlns="http://www.opengis.net/cat/csw/2.0.2"
    xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
    <csw:Query typeNames="csw:Record">
        <csw:ElementSetName>full</csw:ElementSetName>
        <csw:Constraint version="1.1.0" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2">
            <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                <ogc:And>
                    <ogc:PropertyIsLike escapeChar="\\" singleChar="?" wildCard="*">
                        <ogc:PropertyName>AnyText</ogc:PropertyName>
                        <ogc:Literal>CWIC</ogc:Literal>
                    </ogc:PropertyIsLike>
                    <ogc:PropertyIsLike escapeChar="\\" singleChar="?\" wildCard="*\">
                        <ogc:PropertyName>Location</ogc:PropertyName>
                        <ogc:Literal>*BRAZIL*</ogc:Literal>
                    </ogc:PropertyIsLike>
                </ogc:And>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
        eos
        post :index, body: valid_get_records_request_xml
        expect(response).to have_http_status(:success)
      end
    end
  end
end
