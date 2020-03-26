describe "GetRecords IsCwic error cases for GET requests" do

  it 'correctly renders the exception page in response to an invalid IsCwic value in the POST request' do
    VCR.use_cassette 'requests/get_records/gmi/iscwic_error1', :decode_compressed_response => true, :record => :once do
    get '/collections', :params => {  :request => 'GetRecords', :service => 'CSW', :version => '2.0.2', :ElementSetName => 'full',
        :resultType => 'results', :constraint => 'IsCwic=True', :CONSTRAINTLANGUAGE => 'CQL_TEXT' }
      expect(response).to render_template('shared/exception_report.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'ExceptionReport'
      # There should be a SearchStatus with a timestamp
      exception_node_set = records_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_node_set.size).to eq(1)
      expect(exception_node_set[0]['exceptionCode']).to eq('InvalidParameterValue')
      expect(exception_node_set[0]['locator']).to eq('IsCwic')
      exception_text = exception_node_set[0].at_xpath('//ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_text.text).to eq("True is not supported. Value must be set to 'true' in order to search only CWIC datasets")
    end
  end

  it 'correctly renders the exception page in when there is NO IsCwic value in the POST request' do
    VCR.use_cassette 'requests/get_records/gmi/iscwic_error2', :decode_compressed_response => true, :record => :once do
      get '/collections', :params => {  :request => 'GetRecords', :service => 'CSW', :version => '2.0.2', :ElementSetName => 'full',
          :resultType => 'results', :constraint => 'IsCwic', :CONSTRAINTLANGUAGE => 'CQL_TEXT' }
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
