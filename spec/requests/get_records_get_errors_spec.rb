
# invalid queryable bbox syntax
RSpec.describe "various ERROR scenarios for GetRecords GET requests with BoundingBox, TimeExtent_begin, TimeExtent_end and AnyText CONSTRAINTS", :type => :request do

  it 'correctly detects an invalid syntax for a BoundingBox GET request' do
    VCR.use_cassette 'requests/get_records/gmi/error_1', :decode_compressed_response => true, :record => :once do
      get '/collections', :params => {  :request => 'GetRecords', :service => 'CSW', :version => '2.0.2', :ElementSetName => 'full',
          :resultType => 'results', :constraint => 'BoundingBox=-180.00 ,-90.00  ,180.000,90', :CONSTRAINTLANGUAGE => 'CQL_TEXT' }
      expect(response).to have_http_status(:bad_request)
      expect(response).to render_template('shared/exception_report.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'ExceptionReport'
      exception_node_set = records_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_node_set.size).to eq(1)
      expect(exception_node_set[0]['exceptionCode']).to eq('InvalidParameterValue')
      expect(exception_node_set[0]['locator']).to eq('constraint')
      exception_text = exception_node_set[0].at_xpath('//ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_text.text).to include("The value for 'constraint' query parameter is not supported and cannot be parsed")
    end
  end

  # invalid queryable bbox values (bbox validation is left to CMR for now)
  it 'correctly detects an invalid BoundingBox value for a GetRecords GET request' do
    VCR.use_cassette 'requests/get_records/gmi/error_1', :decode_compressed_response => true, :record => :once do
      get '/collections', :params => {  :request => 'GetRecords', :service => 'CSW', :version => '2.0.2', :ElementSetName => 'full',
          :resultType => 'results', :constraint => 'BoundingBox=-185.00,-91.00,180.3460,90', :CONSTRAINTLANGUAGE => 'CQL_TEXT' }
      expect(response).to have_http_status(:bad_request)
      expect(response).to render_template('shared/exception_report.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'ExceptionReport'
      exception_node_set = records_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_node_set.size).to eq(1)
      expect(exception_node_set[0]['exceptionCode']).to eq('NoApplicableCode')
      expect(exception_node_set[0]['locator']).to eq('NoApplicableCode')
      exception_text = exception_node_set[0].at_xpath('//ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_text.text).to include("West must be within [-180.0] and [180.0] but was [-185.0].")
    end
  end

  # TOI syntax in local, TOI begin vs. end positioning is in CMR
  it 'correctly detects an invalid syntax for a TempExtent_begin GET request' do
    VCR.use_cassette 'requests/get_records/gmi/error_1', :decode_compressed_response => true, :record => :once do
      get '/collections', :params => {  :request => 'GetRecords', :service => 'CSW', :version => '2.0.2', :ElementSetName => 'full',
          :resultType => 'results', :constraint => 'TempExtent_begin=1990-09-03BAD00:00:01Z', :CONSTRAINTLANGUAGE => 'CQL_TEXT' }
      expect(response).to have_http_status(:bad_request)
      expect(response).to render_template('shared/exception_report.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'ExceptionReport'
      exception_node_set = records_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_node_set.size).to eq(1)
      expect(exception_node_set[0]['exceptionCode']).to eq('InvalidParameterValue')
      expect(exception_node_set[0]['locator']).to eq('TempExtent_begin')
      exception_text = exception_node_set[0].at_xpath('//ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_text.text).to include("'1990-09-03BAD00:00:01Z' is NOT in the supported ISO8601 format yyyy-MM-ddTHH:mm:ssZ")
    end
  end

  it 'correctly detects an invalid syntax for a TempExtent_end GET request' do
    VCR.use_cassette 'requests/get_records/gmi/error_1', :decode_compressed_response => true, :record => :once do
      get '/collections', :params => {  :request => 'GetRecords', :service => 'CSW', :version => '2.0.2', :ElementSetName => 'full',
          :resultType => 'results', :constraint => 'TempExtent_end=1990-09-03BAD00:00:01Z', :CONSTRAINTLANGUAGE => 'CQL_TEXT' }
      expect(response).to have_http_status(:bad_request)
      expect(response).to render_template('shared/exception_report.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'ExceptionReport'
      exception_node_set = records_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_node_set.size).to eq(1)
      expect(exception_node_set[0]['exceptionCode']).to eq('InvalidParameterValue')
      expect(exception_node_set[0]['locator']).to eq('TempExtent_end')
      exception_text = exception_node_set[0].at_xpath('//ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_text.text).to include("'1990-09-03BAD00:00:01Z' is NOT in the supported ISO8601 format yyyy-MM-ddTHH:mm:ssZ")
    end
  end

  it 'correctly detects an invalid TempExtent_end relative to TempExtent_begin' do
    VCR.use_cassette 'requests/get_records/gmi/error_2', :decode_compressed_response => true, :record => :once do
      get '/collections', :params => {  :request => 'GetRecords', :service => 'CSW', :version => '2.0.2', :ElementSetName => 'full',
          :resultType => 'results', :constraint => 'TempExtent_begin=1990-09-03T00:00:01Z and TempExtent_end=1989-09-03T00:00:01Z', :CONSTRAINTLANGUAGE => 'CQL_TEXT' }
      expect(response).to have_http_status(:bad_request)
      expect(response).to render_template('shared/exception_report.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'ExceptionReport'
      exception_node_set = records_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_node_set.size).to eq(1)
      expect(exception_node_set[0]['exceptionCode']).to eq('NoApplicableCode')
      expect(exception_node_set[0]['locator']).to eq('NoApplicableCode')
      exception_text = exception_node_set[0].at_xpath('//ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_text.text).to include("CMR call failure httpStatus: 422 message: 422 Unprocessable Entity response: [1990-09-03T00:00:01Z/1989-09-03T00:00:01Z] is not a valid date-range")
    end
  end


end
