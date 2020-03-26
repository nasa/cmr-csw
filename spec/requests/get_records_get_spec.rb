require "spec_helper"

RSpec.describe "various successful GetRecords GET requests with BoundingBox, TimeExtent_begin, TimeExtent_end, AnyText CONSTRAINTS", :type => :request do

  it 'correctly renders RESULTS FULL ISO MENDS (gmi) data in response to a basic BBOX constraint GET request' do
    VCR.use_cassette 'requests/get_records/gmi/bbox_1', :decode_compressed_response => true, :record => :once do
      get '/collections', :params => {  :request => 'GetRecords', :service => 'CSW', :version => '2.0.2', :ElementSetName => 'full',
          :resultType => 'results', :constraint => 'BoundingBox=-180.00,-90.00,180.000,90', :CONSTRAINTLANGUAGE => 'CQL_TEXT' }
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be 10 records
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata', 'gmi' => 'http://www.isotc211.org/2005/gmi',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(10)
    end
  end

  it 'correctly renders RESULTS FULL ISO MENDS (gmi) data in response to a basic BBOX and AnyText constraints GET request' do
    VCR.use_cassette 'requests/get_records/gmi/bbox_2', :decode_compressed_response => true, :record => :once do
      get '/collections', :params => {  :request => 'GetRecords', :service => 'CSW', :version => '2.0.2', :ElementSetName => 'full',
          :resultType => 'results', :constraint => 'BoundingBox=-180.00,-90.00,180.000,90 and AnyText=MODIS',
          :CONSTRAINTLANGUAGE => 'CQL_TEXT' }
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be 10 records
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata', 'gmi' => 'http://www.isotc211.org/2005/gmi',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(10)
    end
  end

  # resulting CMR Query is:
  # search/collections?bounding_box=-180.00,-90.00,180.000,90&include_tags=org.ceos.wgiss.cwic.granules.prod,org.geo.geoss_data-core&keyword=MODIS&temporal=1990-09-03T00:00:01Z/
  it 'correctly renders RESULTS FULL ISO MENDS (gmi) data in response to a basic BBOX AnyText, TempExtent_begin constraints GET request' do
    VCR.use_cassette 'requests/get_records/gmi/bbox_3', :decode_compressed_response => true, :record => :once do
      get '/collections', :params => {  :request => 'GetRecords', :service => 'CSW', :version => '2.0.2', :ElementSetName => 'full',
          :resultType => 'results',
          :constraint => 'BoundingBox=-180.00,-90.00,180.000,90 and AnyText=MODIS and TempExtent_begin=1990-09-03T00:00:01Z',
          :CONSTRAINTLANGUAGE => 'CQL_TEXT' }
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be 10 records
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata', 'gmi' => 'http://www.isotc211.org/2005/gmi',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(10)
    end
  end

  # resulting query is:
  # search/collections?bounding_box=-180.00,-90.00,180.000,90&include_tags=org.ceos.wgiss.cwic.granules.prod,org.geo.geoss_data-core&keyword=MODIS&temporal=/2008-09-06T23:59:59Z
  it 'correctly renders RESULTS FULL ISO MENDS (gmi) data in response to a basic BBOX AnyText, TempExtent_end constraints GET request' do
    VCR.use_cassette 'requests/get_records/gmi/bbox_4', :decode_compressed_response => true, :record => :once do
      get '/collections', :params => {  :request => 'GetRecords', :service => 'CSW', :version => '2.0.2', :ElementSetName => 'full',
          :resultType => 'results',
          :constraint => 'BoundingBox=-180.00,-90.00,180.000,90 and AnyText=MODIS and TempExtent_end=2008-09-06T23:59:59Z',
          :CONSTRAINTLANGUAGE => 'CQL_TEXT' }
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be 10 records
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata', 'gmi' => 'http://www.isotc211.org/2005/gmi',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(10)
    end
  end

  # resulting query is
  # search/collections?bounding_box=-180.00,-90.00,180.000,90&include_tags=org.ceos.wgiss.cwic.granules.prod,org.geo.geoss_data-core&keyword=MODIS&temporal=1990-09-03T00:00:01Z/2008-09-06T23:59:59Z
  it 'correctly renders RESULTS FULL ISO MENDS (gmi) data in response to a basic BBOX AnyText, TempExtent_begin and TempExtent_end constraints GET request' do
    VCR.use_cassette 'requests/get_records/gmi/bbox_5', :decode_compressed_response => true, :record => :once do
      get '/collections', :params => {  :request => 'GetRecords', :service => 'CSW', :version => '2.0.2', :ElementSetName => 'full',
          :resultType => 'results',
          :constraint => 'BoundingBox=-180.00,-90.00,180.000,90 and AnyText=MODIS and TempExtent_begin=1990-09-03T00:00:01Z and TempExtent_end=2008-09-06T23:59:59Z',
          :CONSTRAINTLANGUAGE => 'CQL_TEXT' }
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be 10 records
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata', 'gmi' => 'http://www.isotc211.org/2005/gmi',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(10)
    end
  end

  # gmi
  # :outputSchema => 'http://www.isotc211.org/2005/gmi'
  it 'correctly renders RESULTS FULL ISO MENDS (gmi based on output schema) data in response to a basic BBOX AnyText, TempExtent_begin and TempExtent_end constraints GET request' do
    VCR.use_cassette 'requests/get_records/gmi/bbox_5', :decode_compressed_response => true, :record => :once do
      get '/collections', :params => {  :request => 'GetRecords', :service => 'CSW', :version => '2.0.2', :ElementSetName => 'full',
          :resultType => 'results',
          :constraint => 'BoundingBox=-180.00,-90.00,180.000,90 and AnyText=MODIS and TempExtent_begin=1990-09-03T00:00:01Z and TempExtent_end=2008-09-06T23:59:59Z',
          :CONSTRAINTLANGUAGE => 'CQL_TEXT', :outputSchema => 'http://www.isotc211.org/2005/gmi' }
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be 10 records
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata', 'gmi' => 'http://www.isotc211.org/2005/gmi',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(10)
    end
  end

  # gmd
  # :outputSchema => 'http://www.isotc211.org/2005/gmd'
  it 'correctly renders RESULTS FULL ISO GMD (gmi based on output schema) data in response to a basic BBOX AnyText, TempExtent_begin and TempExtent_end constraints GET request' do
    VCR.use_cassette 'requests/get_records/gmi/bbox_5', :decode_compressed_response => true, :record => :once do
      get '/collections', :params => {  :request => 'GetRecords', :service => 'CSW', :version => '2.0.2', :ElementSetName => 'full',
          :resultType => 'results',
          :constraint => 'BoundingBox=-180.00,-90.00,180.000,90 and AnyText=MODIS and TempExtent_begin=1990-09-03T00:00:01Z and TempExtent_end=2008-09-06T23:59:59Z',
          :CONSTRAINTLANGUAGE => 'CQL_TEXT', :outputSchema => 'http://www.isotc211.org/2005/gmd' }
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be 10 records
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmd:MD_Metadata', 'gmd' => 'http://www.isotc211.org/2005/gmd',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(10)
    end
  end

  # CSW FULL
  # :outputSchema => 'http://www.opengis.net/cat/csw/2.0.2'
  it 'correctly renders RESULTS FULL CSW (based on output schema) data in response to a basic BBOX AnyText, TempExtent_begin and TempExtent_end constraints GET request' do
    VCR.use_cassette 'requests/get_records/gmi/bbox_5', :decode_compressed_response => true, :record => :once do
      get '/collections', :params => {  :request => 'GetRecords', :service => 'CSW', :version => '2.0.2', :ElementSetName => 'full',
          :resultType => 'results',
          :constraint => 'BoundingBox=-180.00,-90.00,180.000,90 and AnyText=MODIS and TempExtent_begin=1990-09-03T00:00:01Z and TempExtent_end=2008-09-06T23:59:59Z',
          :CONSTRAINTLANGUAGE => 'CQL_TEXT', :outputSchema => 'http://www.opengis.net/cat/csw/2.0.2' }
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be 10 records
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:Record', 'gmi' => 'http://www.isotc211.org/2005/gmi',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(10)
      # There should be a SearchStatus with a timestamp
      search_status_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchStatus', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
    end
  end

  # CSW BRIEF
  it 'correctly renders RESULTS BRIEF CSW (based on output schema) data in response to a basic BBOX AnyText, TempExtent_begin and TempExtent_end constraints GET request' do
    VCR.use_cassette 'requests/get_records/gmi/bbox_5', :decode_compressed_response => true, :record => :once do
      get '/collections', :params => {  :request => 'GetRecords', :service => 'CSW', :version => '2.0.2', :ElementSetName => 'full',
          :resultType => 'results',
          :constraint => 'BoundingBox=-180.00,-90.00,180.000,90 and AnyText=MODIS and TempExtent_begin=1990-09-03T00:00:01Z and TempExtent_end=2008-09-06T23:59:59Z',
          :CONSTRAINTLANGUAGE => 'CQL_TEXT', :outputSchema => 'http://www.opengis.net/cat/csw/2.0.2', :ElementSetName => 'brief' }
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be 10 records
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:BriefRecord', 'gmi' => 'http://www.isotc211.org/2005/gmi',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(10)
      # There should be a SearchStatus with a timestamp
      search_status_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchStatus', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
    end
  end

  # CSW SUMMARY
  it 'correctly renders RESULTS SUMMARY CSW (based on output schema) data in response to a basic BBOX AnyText, TempExtent_begin and TempExtent_end constraints GET request' do
    VCR.use_cassette 'requests/get_records/gmi/bbox_5', :decode_compressed_response => true, :record => :once do
      get '/collections', :params => {  :request => 'GetRecords', :service => 'CSW', :version => '2.0.2', :ElementSetName => 'full',
          :resultType => 'results',
          :constraint => 'BoundingBox=-180.00,-90.00,180.000,90 and AnyText=MODIS and TempExtent_begin=1990-09-03T00:00:01Z and TempExtent_end=2008-09-06T23:59:59Z',
          :CONSTRAINTLANGUAGE => 'CQL_TEXT', :outputSchema => 'http://www.opengis.net/cat/csw/2.0.2', :ElementSetName => 'summary' }
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be 10 records
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:SummaryRecord', 'gmi' => 'http://www.isotc211.org/2005/gmi',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(10)
      # There should be a SearchStatus with a timestamp
      search_status_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchStatus', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
    end
  end

  # hits vs results
  it 'correctly renders HITS CSW (based on output schema) data in response to a basic BBOX AnyText, TempExtent_begin and TempExtent_end constraints GET request' do
    VCR.use_cassette 'requests/get_records/gmi/bbox_5', :decode_compressed_response => true, :record => :once do
      get '/collections', :params => {  :request => 'GetRecords', :service => 'CSW', :version => '2.0.2', :ElementSetName => 'full',
          :resultType => 'hits',
          :constraint => 'BoundingBox=-180.00,-90.00,180.000,90 and AnyText=MODIS and TempExtent_begin=1990-09-03T00:00:01Z and TempExtent_end=2008-09-06T23:59:59Z',
          :CONSTRAINTLANGUAGE => 'CQL_TEXT', :outputSchema => 'http://www.opengis.net/cat/csw/2.0.2', :ElementSetName => 'summary' }
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be a SearchStatus with a timestamp
      search_status_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchStatus', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_status_node_set.size).to eq(1) # expect(search_status_node_set[0]['timestamp']).to_not eq(nil)
      search_results_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_results_node_set.size).to eq(1)
      expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('704')
      expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq('10')
      expect(search_results_node_set[0]['nextRecord']).to eq('11')
      expect(search_results_node_set[0]['elementSet']).to eq('summary')
      # The SearchResults in the HITS response should NOT HAVE any child nodes
      children = search_results_node_set.children
      expect(children.size).to eq 0
    end
  end

  # startPosition, maxRecords
  it 'correctly renders HITS with startPosition, maxRecords, CSW (based on output schema) data in response to a basic BBOX AnyText, TempExtent_begin and TempExtent_end constraints GET request' do
    VCR.use_cassette 'requests/get_records/gmi/bbox_6', :decode_compressed_response => true, :record => :once do
      get '/collections', :params => {  :request => 'GetRecords', :service => 'CSW', :version => '2.0.2', :ElementSetName => 'full',
          :resultType => 'hits', :startPosition => 47, :maxRecords => 53,
          :constraint => 'BoundingBox=-180.00,-90.00,180.000,90 and AnyText=MODIS and TempExtent_begin=1990-09-03T00:00:01Z and TempExtent_end=2008-09-06T23:59:59Z',
          :CONSTRAINTLANGUAGE => 'CQL_TEXT', :outputSchema => 'http://www.opengis.net/cat/csw/2.0.2', :ElementSetName => 'summary' }
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be a SearchStatus with a timestamp
      search_status_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchStatus', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_status_node_set.size).to eq(1) # expect(search_status_node_set[0]['timestamp']).to_not eq(nil)
      search_results_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_results_node_set.size).to eq(1)
      expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('704')
      expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq('53')
      # TODO - fix the nexRecord bug - shouldn't be 54, should be 47 + 53 + 1
      expect(search_results_node_set[0]['nextRecord']).to eq('101')
      expect(search_results_node_set[0]['elementSet']).to eq('summary')
      # The SearchResults in the HITS response should NOT HAVE any child nodes
      children = search_results_node_set.children
      expect(children.size).to eq 0
    end
  end

end
