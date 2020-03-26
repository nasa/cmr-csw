require "spec_helper"

RSpec.describe "various GetRecords requests to verify POINT spatial coverages in the CSW results output", :type => :request do

  it 'correctly renders CSW FULL RESULTS for a collection with Point Coverage in response to a POST request' do
    VCR.use_cassette 'requests/get_records/csw/point_coverage', :decode_compressed_response => true, :record => :once do
      get_records_request_xml = <<-eos
<csw:GetRecords maxRecords="10" outputFormat="application/xml"
    outputSchema="http://www.opengis.net/cat/csw/2.0.2" resultType="results" service="CSW"
    startPosition="1" version="2.0.2" xmlns="http://www.opengis.net/cat/csw/2.0.2"
    xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
    <csw:Query typeNames="csw:Record">
        <csw:ElementSetName>full</csw:ElementSetName>
        <csw:Constraint version="1.1.0" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2">
            <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                <ogc:PropertyIsLike escapeChar="\\" singleChar="?" wildCard="*">
                        <ogc:PropertyName>AnyText</ogc:PropertyName>
                        <ogc:Literal>SPURS1_MOORING_WHOI</ogc:Literal>
                </ogc:PropertyIsLike>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', :params => get_records_request_xml
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be 10 records
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:Record',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
      # There should be a SearchStatus with a timestamp
      search_status_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchStatus', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_status_node_set.size).to eq(1) # expect(search_status_node_set[0]['timestamp']).to_not eq(nil)
      search_results_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_results_node_set.size).to eq(1)
      expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('1')
      expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq('1')
      expect(search_results_node_set[0]['nextRecord']).to eq('0')
      expect(search_results_node_set[0]['elementSet']).to eq('full')
      expect(search_results_node_set[0]['recordSchema']).to eq('http://www.opengis.net/cat/csw/2.0.2')
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:Record/dct:spatial',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'dct' => 'http://purl.org/dc/terms/').first.text).to eq("gml:Point gml:pos\n        24.58111572265625 -38.0")
      # The csw results should validate against the csw.xsd schema
      # All schemas are local under the directory below
      xsd = Nokogiri::XML::Schema(File.open('spec/fixtures/requests/get_capabilities/csw.xsd'))
      error_message = ''
      xsd.validate(records_xml).each do |error|
        error_message.concat ("#{error.message} \n")
      end
      fail error_message unless error_message.blank?
    end
  end

  it 'correctly renders CSW SUMMARY RESULTS for a collection with Point Coverage in response to a POST request' do
    VCR.use_cassette 'requests/get_records/csw/point_coverage', :decode_compressed_response => true, :record => :once do
      get_records_request_xml = <<-eos
<csw:GetRecords maxRecords="10" outputFormat="application/xml"
    outputSchema="http://www.opengis.net/cat/csw/2.0.2" resultType="results" service="CSW"
    startPosition="1" version="2.0.2" xmlns="http://www.opengis.net/cat/csw/2.0.2"
    xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
    <csw:Query typeNames="csw:Record">
        <csw:ElementSetName>summary</csw:ElementSetName>
        <csw:Constraint version="1.1.0" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2">
            <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                <ogc:PropertyIsLike escapeChar="\\" singleChar="?" wildCard="*">
                        <ogc:PropertyName>AnyText</ogc:PropertyName>
                        <ogc:Literal>SPURS1_MOORING_WHOI</ogc:Literal>
                </ogc:PropertyIsLike>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', :params => get_records_request_xml
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be 10 records
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:SummaryRecord',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
      # There should be a SearchStatus with a timestamp
      search_status_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchStatus', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_status_node_set.size).to eq(1) # expect(search_status_node_set[0]['timestamp']).to_not eq(nil)
      search_results_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_results_node_set.size).to eq(1)
      expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('1')
      expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq('1')
      expect(search_results_node_set[0]['nextRecord']).to eq('0')
      expect(search_results_node_set[0]['elementSet']).to eq('summary')
      expect(search_results_node_set[0]['recordSchema']).to eq('http://www.opengis.net/cat/csw/2.0.2')
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:SummaryRecord/dct:spatial',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'dct' => 'http://purl.org/dc/terms/').first.text).to eq("gml:Point gml:pos\n        24.58111572265625 -38.0")
      # The csw results should validate against the csw.xsd schema
      # All schemas are local under the directory below
      xsd = Nokogiri::XML::Schema(File.open('spec/fixtures/requests/get_capabilities/csw.xsd'))
      error_message = ''
      xsd.validate(records_xml).each do |error|
        error_message.concat ("#{error.message} \n")
      end
      fail error_message unless error_message.blank?
    end
  end

  it 'correctly renders CSW BRIEF RESULTS for a collection with Point Coverage in response to a POST request' do
    VCR.use_cassette 'requests/get_records/csw/point_coverage', :decode_compressed_response => true, :record => :once do
      get_records_request_xml = <<-eos
<csw:GetRecords maxRecords="10" outputFormat="application/xml"
    outputSchema="http://www.opengis.net/cat/csw/2.0.2" resultType="results" service="CSW"
    startPosition="1" version="2.0.2" xmlns="http://www.opengis.net/cat/csw/2.0.2"
    xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
    <csw:Query typeNames="csw:Record">
        <csw:ElementSetName>brief</csw:ElementSetName>
        <csw:Constraint version="1.1.0" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2">
            <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                <ogc:PropertyIsLike escapeChar="\\" singleChar="?" wildCard="*">
                        <ogc:PropertyName>AnyText</ogc:PropertyName>
                        <ogc:Literal>SPURS1_MOORING_WHOI</ogc:Literal>
                </ogc:PropertyIsLike>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', :params => get_records_request_xml
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be 10 records
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:BriefRecord',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
      # There should be a SearchStatus with a timestamp
      search_status_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchStatus', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_status_node_set.size).to eq(1) # expect(search_status_node_set[0]['timestamp']).to_not eq(nil)
      search_results_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_results_node_set.size).to eq(1)
      expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('1')
      expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq('1')
      expect(search_results_node_set[0]['nextRecord']).to eq('0')
      expect(search_results_node_set[0]['elementSet']).to eq('brief')
      expect(search_results_node_set[0]['recordSchema']).to eq('http://www.opengis.net/cat/csw/2.0.2')
      # NO SPATIAL COVERAGE IN BRIEF CSW
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:BriefRecord/dct:spatial',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'dct' => 'http://purl.org/dc/terms/').first).to eq(nil)
      # The csw results should validate against the csw.xsd schema
      # All schemas are local under the directory below
      xsd = Nokogiri::XML::Schema(File.open('spec/fixtures/requests/get_capabilities/csw.xsd'))
      error_message = ''
      xsd.validate(records_xml).each do |error|
        error_message.concat ("#{error.message} \n")
      end
      fail error_message unless error_message.blank?
    end
  end
end