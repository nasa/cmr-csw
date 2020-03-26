RSpec.describe 'various successful GetRecords GET requests with the IsGeoss constraints', :type => :request do

  it 'correctly renders RESULTS FULL ISO MENDS (gmi) data in response to a basic IsGeoss constraint GET request' do
    VCR.use_cassette 'requests/get_records/gmi/geoss_1', :decode_compressed_response => true, :record => :once do
      get '/collections', :params => {  :request => 'GetRecords', :service => 'CSW', :version => '2.0.2', :ElementSetName => 'full',
          :resultType => 'results', :constraint => 'IsGeoss=true', :CONSTRAINTLANGUAGE => 'CQL_TEXT' }
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be 10 records
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata', 'gmi' => 'http://www.isotc211.org/2005/gmi',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(10)
      # There should be a SearchStatus with a timestamp
      search_status_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchStatus', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_status_node_set.size).to eq(1) # expect(search_status_node_set[0]['timestamp']).to_not eq(nil)
      search_results_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_results_node_set.size).to eq(1)
      # ALL GEOSS DATASETS (as opposed to ALL 32205 CMR datasets)
      expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('1800')
      expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq('10')
      expect(search_results_node_set[0]['nextRecord']).to eq('11')
      expect(search_results_node_set[0]['elementSet']).to eq('full')
      expect(search_results_node_set[0]['recordSchema']).to eq('http://www.isotc211.org/2005/gmi')

      get '/collections', :params => {  :request => 'GetRecords', :service => 'CSW', :version => '2.0.2', :ElementSetName => 'full',
          :resultType => 'results' }
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be 10 records
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata', 'gmi' => 'http://www.isotc211.org/2005/gmi',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(10)
      # There should be a SearchStatus with a timestamp
      search_status_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchStatus', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_status_node_set.size).to eq(1) # expect(search_status_node_set[0]['timestamp']).to_not eq(nil)
      search_results_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_results_node_set.size).to eq(1)
      # ALL 32205 CMR DATASETS (as opposed to the 1800 GEOSS datasets above)
      expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('32205')
      expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq('10')
      expect(search_results_node_set[0]['nextRecord']).to eq('11')
      expect(search_results_node_set[0]['elementSet']).to eq('full')
      expect(search_results_node_set[0]['recordSchema']).to eq('http://www.isotc211.org/2005/gmi')
    end
  end

  it 'correctly renders FULL RESULTS ISO MENDS (GMI) data in response to a AOI_TOI_AnyText_Title_IsGeoss constraint GET request' do
    VCR.use_cassette 'requests/get_records/gmi/geoss_2', :decode_compressed_response => true, :record => :once do
      get '/collections', :params => {  :request => 'GetRecords', :service => 'CSW', :version => '2.0.2', :ElementSetName => 'full',
          :resultType => 'results',
          :constraint => 'BoundingBox=-180.00,-90.00,180.000,90 and AnyText=*MODIS* and TempExtent_begin=1990-09-03T00:00:01Z and TempExtent_end=2008-09-06T23:59:59Z and IsGeoss=true',
          :CONSTRAINTLANGUAGE => 'CQL_TEXT' }
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be 10 records
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata', 'gmi' => 'http://www.isotc211.org/2005/gmi',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(10)
      # There should be a SearchStatus with a timestamp
      search_status_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchStatus', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_status_node_set.size).to eq(1) # expect(search_status_node_set[0]['timestamp']).to_not eq(nil)
      search_results_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_results_node_set.size).to eq(1)
      # without isCwic we get 985
      expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('221')
      expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq('10')
      expect(search_results_node_set[0]['nextRecord']).to eq('11')
      expect(search_results_node_set[0]['elementSet']).to eq('full')
      expect(search_results_node_set[0]['recordSchema']).to eq('http://www.isotc211.org/2005/gmi')
    end
  end

  it 'correctly renders HITS data in response to an IsGeoss ONLY constraint and resultType HITS GET request' do
    VCR.use_cassette 'requests/get_records/gmi/geoss_3', :decode_compressed_response => true, :record => :once do
      get '/collections', :params => {  :request => 'GetRecords', :service => 'CSW', :version => '2.0.2', :ElementSetName => 'full',
          :constraint => 'IsGeoss=true', :CONSTRAINTLANGUAGE => 'CQL_TEXT', :resultType => 'hits' }
      expect(response).to have_http_status(:success)
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be a SearchStatus with a timestamp
      search_status_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchStatus', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_status_node_set.size).to eq(1) # expect(search_status_node_set[0]['timestamp']).to_not eq(nil)
      search_results_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_results_node_set.size).to eq(1)
      expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('1800')
      expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq('10')
      expect(search_results_node_set[0]['nextRecord']).to eq('11')
      expect(search_results_node_set[0]['elementSet']).to eq('full')
      # The SearchResults in the HITS response should NOT HAVE any child nodes
      children = search_results_node_set.children
      expect(children.size).to eq 0

      get '/collections', :params => {  :request => 'GetRecords', :service => 'CSW', :version => '2.0.2', :ElementSetName => 'full',
          :resultType => 'hits' }
      expect(response).to have_http_status(:success)
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be a SearchStatus with a timestamp
      search_status_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchStatus', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_status_node_set.size).to eq(1) # expect(search_status_node_set[0]['timestamp']).to_not eq(nil)
      search_results_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_results_node_set.size).to eq(1)
      expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('32205')
      expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq('10')
      expect(search_results_node_set[0]['nextRecord']).to eq('11')
      expect(search_results_node_set[0]['elementSet']).to eq('full')
      # The SearchResults in the HITS response should NOT HAVE any child nodes
      children = search_results_node_set.children
      expect(children.size).to eq 0
    end
  end

  it 'correctly renders HITS data (default) in response to an IsGeoss ONLY constraint and NO resultType GET request' do
    VCR.use_cassette 'requests/get_records/gmi/geoss_4', :decode_compressed_response => true, :record => :once do
      get '/collections', :params => {  :request => 'GetRecords', :service => 'CSW', :version => '2.0.2', :ElementSetName => 'full',
          :constraint => 'IsGeoss=true', :CONSTRAINTLANGUAGE => 'CQL_TEXT' }
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be a SearchStatus with a timestamp
      search_status_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchStatus', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_status_node_set.size).to eq(1) # expect(search_status_node_set[0]['timestamp']).to_not eq(nil)
      search_results_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_results_node_set.size).to eq(1)
      expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('1800')
      expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq('10')
      expect(search_results_node_set[0]['nextRecord']).to eq('11')
      expect(search_results_node_set[0]['elementSet']).to eq('full')
      # The SearchResults in the HITS response should NOT HAVE any child nodes
      children = search_results_node_set.children
      expect(children.size).to eq 0
    end
  end

  it 'correctly renders the exception page in response to an invalid IsGeoss value in the POST request' do
      VCR.use_cassette 'requests/get_records/gmi/isgeoss_error', :decode_compressed_response => true, :record => :once do
      get '/collections', :params => {  :request => 'GetRecords', :service => 'CSW', :version => '2.0.2', :ElementSetName => 'full',
          :resultType => 'results', :constraint => 'IsGeoss=True', :CONSTRAINTLANGUAGE => 'CQL_TEXT' }
        expect(response).to render_template('shared/exception_report.xml.erb')
        records_xml = Nokogiri::XML(response.body)
        expect(records_xml.root.name).to eq 'ExceptionReport'
        # There should be a SearchStatus with a timestamp
        exception_node_set = records_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows')
        expect(exception_node_set.size).to eq(1)
        expect(exception_node_set[0]['exceptionCode']).to eq('InvalidParameterValue')
        expect(exception_node_set[0]['locator']).to eq('IsGeoss')
        exception_text = exception_node_set[0].at_xpath('//ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows')
        expect(exception_text.text).to eq("True is not supported. Value must be set to 'true' in order to search only GEOSS datasets")
      end
    end

    it 'correctly renders the exception page in when there is NO IsGeoss value in the POST request' do
      VCR.use_cassette 'requests/get_records/gmi/isgeoss_error', :decode_compressed_response => true, :record => :once do
        get '/collections', :params => {  :request => 'GetRecords', :service => 'CSW', :version => '2.0.2', :ElementSetName => 'full',
            :resultType => 'results', :constraint => 'IsGeoss', :CONSTRAINTLANGUAGE => 'CQL_TEXT' }
        expect(response).to render_template('shared/exception_report.xml.erb')
        records_xml = Nokogiri::XML(response.body)
        expect(records_xml.root.name).to eq 'ExceptionReport'
        # There should be a SearchStatus with a timestamp
        exception_node_set = records_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows')
        expect(exception_node_set.size).to eq(1)
        expect(exception_node_set[0]['exceptionCode']).to eq('InvalidParameterValue')
        expect(exception_node_set[0]['locator']).to eq('constraint')
        exception_text = exception_node_set[0].at_xpath('//ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows')
        expect(exception_text.text).to include("The value for 'constraint' query parameter is not supported and cannot be parsed:")
      end
    end
end
