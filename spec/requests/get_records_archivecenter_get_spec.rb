RSpec.describe "various successful GetRecords GET requests with the ArchiveCenter constraint", :type => :request do

  it 'correctly renders RESULTS FULL ISO MENDS (gmi) data in response to an ArchiveCenter IsGeoss constraint GET request' do
    VCR.use_cassette 'requests/get_records/gmi/dhs_1', :decode_compressed_response => true, :record => :once do
      get '/collections', :request => 'GetRecords', :service => 'CSW', :version => '2.0.2', :ElementSetName => 'full',
          :resultType => 'results', :constraint => 'ArchiveCenter=DHS* and IsGeoss=true', :CONSTRAINTLANGUAGE => 'CQL_TEXT'
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be 4 records
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata', 'gmi' => 'http://www.isotc211.org/2005/gmi',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(4)
      # There should be a SearchStatus with a timestamp
      search_status_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchStatus', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_status_node_set.size).to eq(1)
      search_results_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_results_node_set.size).to eq(1)
      expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('4')
      expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq('4')
      expect(search_results_node_set[0]['nextRecord']).to eq('0')
      expect(search_results_node_set[0]['elementSet']).to eq('full')
      expect(search_results_node_set[0]['recordSchema']).to eq('http://www.isotc211.org/2005/gmi')
    end
  end

  it 'correctly renders HITS data in response to an ArchiveCenter IsGeoss constraint and resultType HITS GET request' do
    VCR.use_cassette 'requests/get_records/gmi/dhs_2', :decode_compressed_response => true, :record => :once do
      get '/collections', :request => 'GetRecords', :service => 'CSW', :version => '2.0.2', :ElementSetName => 'full',
          :constraint => 'ArchiveCenter=DHS* and IsGeoss=true', :CONSTRAINTLANGUAGE => 'CQL_TEXT', :resultType => 'hits'
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be a SearchStatus with a timestamp
      search_status_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchStatus', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_status_node_set.size).to eq(1) # expect(search_status_node_set[0]['timestamp']).to_not eq(nil)
      search_results_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_results_node_set.size).to eq(1)
      expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('4')
      expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq('4')
      expect(search_results_node_set[0]['nextRecord']).to eq('0')
      expect(search_results_node_set[0]['elementSet']).to eq('full')
      # The SearchResults in the HITS response should NOT HAVE any child nodes
      children = search_results_node_set.children
      expect(children.size).to eq 0
    end
  end

end