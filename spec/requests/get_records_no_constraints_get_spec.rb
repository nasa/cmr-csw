require "spec_helper"

RSpec.describe "various GetRecords GET requests with NO CONSTRAINTS", :type => :request do

  it 'correctly renders RESULTS FULL ISO MENDS (gmi) data in response to a basic / no-constrains GET request' do
    VCR.use_cassette 'requests/get_records/gmi/ten_records', :decode_compressed_response => true, :record => :once do
      get '/collections', :params => {  :request => 'GetRecords', :service => 'CSW', :version => '2.0.2', :ElementSetName => 'full', :resultType => 'results' }
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be 10 records
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata', 'gmi' => 'http://www.isotc211.org/2005/gmi',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(10)
    end
  end

  it 'correctly renders RESULTS SUMMARY ISO MENDS (gmi) data in response to a basic / no-constrains GET request' do
    VCR.use_cassette 'requests/get_records/gmi/ten_records', :decode_compressed_response => true, :record => :once do
      get '/collections', :params => {  :request => 'GetRecords', :service => 'CSW', :version => '2.0.2', :ElementSetName => 'summary', :resultType => 'results' }
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be 10 records
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata', 'gmi' => 'http://www.isotc211.org/2005/gmi',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(10)
    end
  end

  it 'correctly renders HITS ISO MENDS (gmi) data in response to a basic / no-constrains GET request' do
    VCR.use_cassette 'requests/get_records/gmi/no_constraints_hits', :decode_compressed_response => true, :record => :once do
      get '/collections', :params => {  :request => 'GetRecords', :service => 'CSW', :version => '2.0.2', :ElementSetName => 'full', :resultType => 'hits' }
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

  it 'correctly renders default ISO MENDS (gmi) HITS data in response to a basic / no-constrains GET request with NO resultType' do
    VCR.use_cassette 'requests/get_records/gmi/no_constraints_hits', :decode_compressed_response => true, :record => :once do
      get '/collections', :params => {  :request => 'GetRecords', :service => 'CSW', :version => '2.0.2', :ElementSetName => 'full' }
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

  it 'correctly reports an error when a constraint with no CONSTRAINTLANGUAGE parameter is present' do
    VCR.use_cassette 'requests/get_records/gmi/no_constraints_hits', :decode_compressed_response => true, :record => :once do
      get '/collections', :params => {  :service => 'CSW', :request => 'GetRecords', :version => '2.0.2', :outputSchema => 'http://www.isotc211.org/2005/gmi',
          :ElementSetName => 'full', :constraint => 'SAMPLE CONSTRAINT HERE' }
      expect(response).to have_http_status(:bad_request)
      exception_xml = Nokogiri::XML(response.body)
      expect(exception_xml.root.name).to eq 'ExceptionReport'
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows').size).to eq(1)
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@locator', 'ows' => 'http://www.opengis.net/ows').text).to eq('CONSTRAINTLANGUAGE')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@exceptionCode', 'ows' => 'http://www.opengis.net/ows').text).to eq('MissingParameterValue')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows').text).to eq("GetRecords GET request error: the CONSTRAINTLANGUAGE query parameter cannot be blank and must equal 'CQL_TEXT' when the [constraint=SAMPLE CONSTRAINT HERE] is specified.")
    end
  end

  it 'correctly reports an error when a constraint with an invalid CONSTRAINTLANGUAGE parameter is present' do
    VCR.use_cassette 'requests/get_records/gmi/no_constraints_hits', :decode_compressed_response => true, :record => :once do
      get '/collections', :params => {  :service => 'CSW', :request => 'GetRecords', :version => '2.0.2', :outputSchema => 'http://www.isotc211.org/2005/gmi',
          :ElementSetName => 'full', :constraint => 'SAMPLE CONSTRAINT HERE', :CONSTRAINTLANGUAGE => 'FILTER (not supported)' }
      expect(response).to have_http_status(:bad_request)
      exception_xml = Nokogiri::XML(response.body)
      expect(exception_xml.root.name).to eq 'ExceptionReport'
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows').size).to eq(1)
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@locator', 'ows' => 'http://www.opengis.net/ows').text).to eq('CONSTRAINTLANGUAGE')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@exceptionCode', 'ows' => 'http://www.opengis.net/ows').text).to eq('InvalidParameterValue')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows').text).to eq("GetRecords GET request error: the CONSTRAINTLANGUAGE query parameter value 'FILTER (not supported)' is not supported. The only supported value is CQL.")
    end
  end

  it 'returns ONLY the CWIC datasets if the originator is CWICSmart' do
    VCR.use_cassette 'requests/get_records/gmi/originator_cwic_get', :decode_compressed_response => true, :record => :once do
      get '/collections', :params => {  :service => 'CSW', :request => 'GetRecords', :version => '2.0.2', :ElementSetName => 'summary', :resultType => 'results' }, :headers => { "From-Cwic-Smart" => "Y" }
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be 10 records
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata', 'gmi' => 'http://www.isotc211.org/2005/gmi',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(10)
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/@numberOfRecordsMatched', 'gmi' => 'http://www.isotc211.org/2005/gmi',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').first.value).to eq("3169")
    end
  end

  it 'returns both CWIC and non-CWIC datasets for a regular (non-CWICSmart) invocation' do
    VCR.use_cassette 'requests/get_records/gmi/originator_non_cwic_get', :decode_compressed_response => true, :record => :once do
      get '/collections', :params => {  :service => 'CSW', :request => 'GetRecords', :version => '2.0.2', :ElementSetName => 'summary', :resultType => 'results' }
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
