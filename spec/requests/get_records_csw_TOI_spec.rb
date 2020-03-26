require 'spec_helper'

RSpec.describe "various GetRecords requests to verify TOI coverages in the CSW results output", :type => :request do

  it 'correctly renders CSW FULL RESULTS for a collection with TOI PERIOD Coverage in response to a POST request' do
    VCR.use_cassette 'requests/get_records/csw/toi_range_both', :decode_compressed_response => true, :record => :once do
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
                        <ogc:Literal>MOD10A1</ogc:Literal>
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
      # There should be 1 record
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
      # Polygon info is in
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:Record/dct:spatial',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'dct' => 'http://purl.org/dc/terms/').first.text).to eq("gml:Polygon gml:posList\n          -27.3888342321754 -172.532315594937 -27.0216316035307 -172.880269105471 64.5031953793999 -147.324714606274 64.6013536280256 -147.320615822351 69.2592496790039 -49.8719158453424 69.1780886242131 -49.7043561399798 -18.8673664895838 -62.3059597437661 -23.0963231922105 -62.9581785137324 -26.1981987409613 -143.266130463967")
      # Temporal period is correct
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:Record/dct:temporal',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'dct' => 'http://purl.org/dc/terms/').first.text).to eq("1999-12-18T00:00:00Z/2000-12-18T00:00:00Z")
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

  it 'correctly renders CSW FULL RESULTS for a collection with TOI open ended END PERIOD Coverage in response to a POST request' do
    VCR.use_cassette 'requests/get_records/csw/toi_range_begin', :decode_compressed_response => true, :record => :once do
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
                        <ogc:Literal>MOD10A1</ogc:Literal>
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
      # There should be 1 record
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
      # Polygon info is in
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:Record/dct:spatial',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'dct' => 'http://purl.org/dc/terms/').first.text).to eq("gml:Polygon gml:posList\n          -27.3888342321754 -172.532315594937 -27.0216316035307 -172.880269105471 64.5031953793999 -147.324714606274 64.6013536280256 -147.320615822351 69.2592496790039 -49.8719158453424 69.1780886242131 -49.7043561399798 -18.8673664895838 -62.3059597437661 -23.0963231922105 -62.9581785137324 -26.1981987409613 -143.266130463967")
      # Temporal period is correct
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:Record/dct:temporal',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'dct' => 'http://purl.org/dc/terms/').first.text).to eq("1999-12-18T00:00:00Z/")
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

  it 'correctly renders CSW FULL RESULTS for a collection with TOI open ended BEGIN PERIOD Coverage in response to a POST request' do
    VCR.use_cassette 'requests/get_records/csw/toi_range_end', :decode_compressed_response => true, :record => :once do
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
                        <ogc:Literal>MOD10A1</ogc:Literal>
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
      # There should be 1 record
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
      # Polygon info is in
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:Record/dct:spatial',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'dct' => 'http://purl.org/dc/terms/').first.text).to eq("gml:Polygon gml:posList\n          -27.3888342321754 -172.532315594937 -27.0216316035307 -172.880269105471 64.5031953793999 -147.324714606274 64.6013536280256 -147.320615822351 69.2592496790039 -49.8719158453424 69.1780886242131 -49.7043561399798 -18.8673664895838 -62.3059597437661 -23.0963231922105 -62.9581785137324 -26.1981987409613 -143.266130463967")
      # Temporal period is correct
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:Record/dct:temporal',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'dct' => 'http://purl.org/dc/terms/').first.text).to eq("/1999-12-18T00:00:00Z")
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

  it 'correctly renders CSW FULL RESULTS for a collection with an unprocessable CMR TOI entry in response to a POST request' do
    VCR.use_cassette 'requests/get_records/csw/toi_not_processed', :decode_compressed_response => true, :record => :once do
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
                        <ogc:Literal>MOD10A1</ogc:Literal>
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
      # There should be 1 record
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
      # Polygon info is in
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:Record/dct:spatial',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'dct' => 'http://purl.org/dc/terms/').first.text).to eq("gml:Polygon gml:posList\n          -27.3888342321754 -172.532315594937 -27.0216316035307 -172.880269105471 64.5031953793999 -147.324714606274 64.6013536280256 -147.320615822351 69.2592496790039 -49.8719158453424 69.1780886242131 -49.7043561399798 -18.8673664895838 -62.3059597437661 -23.0963231922105 -62.9581785137324 -26.1981987409613 -143.266130463967")
      # Temporal period is correct
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:Record/dct:temporal',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'dct' => 'http://purl.org/dc/terms/').first.text).to eq("Functionality to process the current entry temporal coverage from the CMR ISO 19115 response by CMR CSW does not exist.")
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

  it 'correctly renders CSW FULL RESULTS for a collection with TOI POINT / SingleDateTime Coverage in response to a POST request' do
    VCR.use_cassette 'requests/get_records/csw/toi_point', :decode_compressed_response => true, :record => :once do
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
                        <ogc:Literal>MOD10A1</ogc:Literal>
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
      # There should be 1 record
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
      # Polygon info is in
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:Record/dct:spatial',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'dct' => 'http://purl.org/dc/terms/').first.text).to eq("gml:Polygon gml:posList\n          -27.3888342321754 -172.532315594937 -27.0216316035307 -172.880269105471 64.5031953793999 -147.324714606274 64.6013536280256 -147.320615822351 69.2592496790039 -49.8719158453424 69.1780886242131 -49.7043561399798 -18.8673664895838 -62.3059597437661 -23.0963231922105 -62.9581785137324 -26.1981987409613 -143.266130463967")
      # Temporal point is correct
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:Record/dct:temporal',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'dct' => 'http://purl.org/dc/terms/').first.text).to eq("2000-03-04T20:34:04.227000Z")
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