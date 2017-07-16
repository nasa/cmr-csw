require 'spec_helper'

RSpec.describe 'result set navigation for GetRecords', :type => :request do

  it 'correctly returns the first result plus page size' do
    VCR.use_cassette 'requests/get_records/gmi/first', :decode_compressed_response => true, :record => :once do
      post_xml = <<-eos
<csw:GetRecords maxRecords="12" outputFormat="application/xml"
    outputSchema="http://www.isotc211.org/2005/gmi" resultType="results" service="CSW"
    startPosition="1" version="2.0.2" xmlns="http://www.opengis.net/cat/csw/2.0.2"
    xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
    <csw:Query typeNames="csw:Record">
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', post_xml
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata', 'gmi' => 'http://www.isotc211.org/2005/gmi',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(12)
      search_status_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchStatus', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_status_node_set.size).to eq(1)
      search_results_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_results_node_set.size).to eq(1)
      expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('36528')
      expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq('12')
      expect(search_results_node_set[0]['nextRecord']).to eq('13')
      expect(search_results_node_set[0]['elementSet']).to eq('brief')
      expect(search_results_node_set[0]['recordSchema']).to eq('http://www.isotc211.org/2005/gmi')
    end
  end

  it 'correctly returns the second result plus page size' do
      VCR.use_cassette 'requests/get_records/gmi/second', :decode_compressed_response => true, :record => :once do
        post_xml = <<-eos
  <csw:GetRecords maxRecords="13" outputFormat="application/xml"
      outputSchema="http://www.isotc211.org/2005/gmi" resultType="results" service="CSW"
      startPosition="2" version="2.0.2" xmlns="http://www.opengis.net/cat/csw/2.0.2"
      xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd"
      xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc"
      xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
      <csw:Query typeNames="csw:Record">
      </csw:Query>
  </csw:GetRecords>
        eos
        post '/collections', post_xml
        expect(response).to have_http_status(:success)
        expect(response).to render_template('get_records/index.xml.erb')
        records_xml = Nokogiri::XML(response.body)
        expect(records_xml.root.name).to eq 'GetRecordsResponse'
        expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata', 'gmi' => 'http://www.isotc211.org/2005/gmi',
                                      'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(13)
        search_status_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchStatus', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
        expect(search_status_node_set.size).to eq(1)
        search_results_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
        expect(search_results_node_set.size).to eq(1)
        expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('36528')
        expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq('13')
        expect(search_results_node_set[0]['nextRecord']).to eq('16')
        expect(search_results_node_set[0]['elementSet']).to eq('brief')
        expect(search_results_node_set[0]['recordSchema']).to eq('http://www.isotc211.org/2005/gmi')
      end
    end
end

