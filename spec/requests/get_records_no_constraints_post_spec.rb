require "spec_helper"

RSpec.describe "various GetRecords POST requests with NO CONSTRAINTS", :type => :request do

  it 'correctly renders RESULTS FULL ISO MENDS (gmi) data in response to a basic / no-constrains POST request' do
    VCR.use_cassette 'requests/get_records/gmi/ten_records', :decode_compressed_response => true, :record => :once do
      # notice the outputSchema below http://www.isotc211.org/2005/gmi, which is not the GCMD one http://www.isotc211.org/2005/gmd
      # TODO - revisit this once CMR supports ISO 19115 gmd
      no_constraints_get_records_request_xml = <<-eos
<?xml version="1.0" encoding="UTF-8"?>
<csw:GetRecords maxRecords="10" outputFormat="application/xml"
    outputSchema="http://www.isotc211.org/2005/gmi" resultType="results" service="CSW"
    startPosition="1" version="2.0.2" xmlns="http://www.opengis.net/cat/csw/2.0.2"
    xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
    <csw:Query typeNames="csw:Record">
        <csw:ElementSetName>full</csw:ElementSetName>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', :params => no_constraints_get_records_request_xml
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be 10 records
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata', 'gmi' => 'http://www.isotc211.org/2005/gmi',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(10)
    end
  end

  it 'correctly renders ISO MENDS (gmi) HITS data in response to a basic / no-constrains POST request' do
    VCR.use_cassette 'requests/get_records/gmi/no_constraints_hits', :decode_compressed_response => true, :record => :once do
      no_constraints_get_records_request_xml = <<-eos
<?xml version="1.0" encoding="UTF-8"?>
<csw:GetRecords maxRecords="10" outputFormat="application/xml"
    outputSchema="http://www.isotc211.org/2005/gmi" resultType="hits" service="CSW"
    startPosition="1" version="2.0.2" xmlns="http://www.opengis.net/cat/csw/2.0.2"
    xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
    <csw:Query typeNames="csw:Record">
        <csw:ElementSetName>full</csw:ElementSetName>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', :params => no_constraints_get_records_request_xml
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be a SearchStatus with a timestamp
      search_status_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchStatus', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_status_node_set.size).to eq(1) # expect(search_status_node_set[0]['timestamp']).to_not eq(nil)
      search_results_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_results_node_set.size).to eq(1)
      expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('31450')
      expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq('10')
      expect(search_results_node_set[0]['nextRecord']).to eq('11')
      expect(search_results_node_set[0]['elementSet']).to eq('full')
      # The SearchResults in the HITS response should NOT HAVE any child nodes
      children = search_results_node_set.children
      expect(children.size).to eq 0
    end
  end

  it 'correctly renders default ISO MENDS (gmi) HITS data in response to a basic / no-constrains POST request with NO resultType' do
    VCR.use_cassette 'requests/get_records/gmi/no_constraints_hits', :decode_compressed_response => true, :record => :once do
      no_constraints_get_records_request_xml = <<-eos
<?xml version="1.0" encoding="UTF-8"?>
<csw:GetRecords maxRecords="10" outputFormat="application/xml"
    outputSchema="http://www.isotc211.org/2005/gmi" service="CSW"
    startPosition="1" version="2.0.2" xmlns="http://www.opengis.net/cat/csw/2.0.2"
    xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
    <csw:Query typeNames="csw:Record">
        <csw:ElementSetName>full</csw:ElementSetName>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', :params => no_constraints_get_records_request_xml
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be a SearchStatus with a timestamp
      search_status_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchStatus', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_status_node_set.size).to eq(1) # expect(search_status_node_set[0]['timestamp']).to_not eq(nil)
      search_results_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_results_node_set.size).to eq(1)
      expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('31450')
      expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq('10')
      expect(search_results_node_set[0]['nextRecord']).to eq('11')
      expect(search_results_node_set[0]['elementSet']).to eq('full')
      # The SearchResults in the HITS response should NOT HAVE any child nodes
      children = search_results_node_set.children
      expect(children.size).to eq 0
    end
  end

  it 'returns ONLY the CWIC datasets if the originator is CWICSmart' do
    VCR.use_cassette 'requests/get_records/gmi/originator_cwic', :decode_compressed_response => true, :record => :once do
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
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', :params => valid_get_records_request_xml, headers: { "From-Cwic-Smart" => "Y" }
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be 10 records
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata', 'gmi' => 'http://www.isotc211.org/2005/gmi',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(10)
      # we have a total of 32166 datasets (from which a subset of 1798 are CWIC datasets)
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/@numberOfRecordsMatched', 'gmi' => 'http://www.isotc211.org/2005/gmi',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').first.value).to eq("1797")
    end
  end

  it 'returns both CWIC and non-CWIC datasets for a regular (non-CWICSmart) invocation' do
    VCR.use_cassette 'requests/get_records/gmi/originator_non_cwic', :decode_compressed_response => true, :record => :once do
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
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', :params => valid_get_records_request_xml
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be 10 records
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata', 'gmi' => 'http://www.isotc211.org/2005/gmi',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(10)
      # we have a total of 32166 datasets (from which a subset are CWIC datasets)
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/@numberOfRecordsMatched', 'gmi' => 'http://www.isotc211.org/2005/gmi',
                                   'csw' => 'http://www.opengis.net/cat/csw/2.0.2').first.value).to eq("32166")
    end
  end

end

