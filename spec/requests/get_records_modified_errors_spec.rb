require 'spec_helper'

describe "GetRecords Modified error cases" do
  # No error, NO contraint CMR query
  it 'correctly renders default HITS data in response to the resultType missing and an incomplete Modified constraint POST request' do
    VCR.use_cassette 'requests/get_records/gmi/modified_error1', :decode_compressed_response => true, :record => :once do
      get_records_request_xml = <<-eos
<csw:GetRecords maxRecords="10" outputFormat="application/xml"
    outputSchema="http://www.isotc211.org/2005/gmi" service="CSW"
    startPosition="1" version="2.0.2" xmlns="http://www.opengis.net/cat/csw/2.0.2"
    xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
    <csw:Query typeNames="csw:Record">
        <csw:ElementSetName>full</csw:ElementSetName>
         <csw:Constraint version="1.1.0">
                <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                    <ogc:PropertyIsGreaterThanOrEqualTo>
                        <ogc:PropertyName>Modified</ogc:PropertyName>
                        <!-- Literal missing
                        <ogc:Literal>2016-04-01</ogc:Literal> -->
                    </ogc:PropertyIsGreaterThanOrEqualTo>
                </ogc:Filter>
         </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', :params => get_records_request_xml
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
    end
  end

  # This is a straight No Constraint request
  it 'correctly renders default HITS data in response to the resultType missing Modified POST request' do
    VCR.use_cassette 'requests/get_records/gmi/modified_error1', :decode_compressed_response => true, :record => :once do
      get_records_request_xml = <<-eos
<csw:GetRecords maxRecords="10" outputFormat="application/xml"
    outputSchema="http://www.isotc211.org/2005/gmi" service="CSW"
    startPosition="1" version="2.0.2" xmlns="http://www.opengis.net/cat/csw/2.0.2"
    xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
    <csw:Query typeNames="csw:Record">
        <csw:ElementSetName>full</csw:ElementSetName>
         <csw:Constraint version="1.1.0">
           <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">

           </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', :params => get_records_request_xml
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
    end
  end

  it 'correctly renders Exception page in response to an invalid XML POST request' do
    VCR.use_cassette 'requests/get_records/gmi/modified_error3', :decode_compressed_response => true, :record => :once do
      get_records_request_xml = <<-eos
<csw:GetRecords maxRecords="10" outputFormat="application/xml"
    outputSchema="http://www.isotc211.org/2005/gmi" service="CSW"
    startPosition="1" version="2.0.2" xmlns="http://www.opengis.net/cat/csw/2.0.2"
    xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
    <csw:Query typeNames="csw:Record">
        <csw:ElementSetName>full</csw:ElementSetName>
         <csw:Constraint version="1.1.0">
             <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                    <ogc:PropertyIsGreaterThanOrEqualTo>
                        <ogc:PropertyName>Modified</ogc:PropertyName>
                        <ogc:Literal>2016-04-01</ogc:Literal>
                    </ogc:PropertyIsGreaterThanOrEqualTo>
            </ogc:Filter>
        </csw:ConstraintBAD_BAD_BAD>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', :params => get_records_request_xml
      expect(response).to render_template('shared/exception_report.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'ExceptionReport'
      # There should be a SearchStatus with a timestamp
      exception_node_set = records_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_node_set.size).to eq(1)
      expect(exception_node_set[0]['exceptionCode']).to eq('NoApplicableCode')
      expect(exception_node_set[0]['locator']).to eq('NoApplicableCode')
      exception_text = exception_node_set[0].at_xpath('//ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_text.text).to eq("Could not parse the GetRecords request body XML: 16:37: FATAL: Opening and ending tag mismatch: Constraint line 9 and ConstraintBAD_BAD_BAD")
    end
  end

  it 'correctly renders the exception page in response to an invalid Modified in the POST request' do
    VCR.use_cassette 'requests/get_records/gmi/modified_error4', :decode_compressed_response => true, :record => :once do
      get_records_request_xml = <<-eos
<csw:GetRecords maxRecords="10" outputFormat="application/xml"
    outputSchema="http://www.isotc211.org/2005/gmi" service="CSW"
    startPosition="1" version="2.0.2" xmlns="http://www.opengis.net/cat/csw/2.0.2"
    xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
    <csw:Query typeNames="csw:Record">
        <csw:ElementSetName>full</csw:ElementSetName>
         <csw:Constraint version="1.1.0">
            <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                 <ogc:PropertyIsGreaterThanOrEqualTo>
                     <ogc:PropertyName>Modified</ogc:PropertyName>
                     <ogc:Literal>2016-31-01</ogc:Literal>
                 </ogc:PropertyIsGreaterThanOrEqualTo>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', :params => get_records_request_xml
      expect(response).to render_template('shared/exception_report.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'ExceptionReport'
      # There should be a SearchStatus with a timestamp
      exception_node_set = records_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_node_set.size).to eq(1)
      expect(exception_node_set[0]['exceptionCode']).to eq('InvalidParameterValue')
      expect(exception_node_set[0]['locator']).to eq('Modified')
      exception_text = exception_node_set[0].at_xpath('//ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_text.text).to eq("'2016-31-01' is NOT in the supported ISO8601 date format yyyy-MM-dd")
    end
  end

  # due to a potential bug in strptime, which allows %Y (four digit year) work with year string longer than 4 digits
  # we have a bad request that makes it to CMR, let's make sure that we correctly handle CMR reques failures
  it 'correctly renders the exception page in response to an invalid Modified in the POST request which passes CMR CSW validation' do
    VCR.use_cassette 'requests/get_records/gmi/modified_error5', :decode_compressed_response => true, :record => :once do
      get_records_request_xml = <<-eos
<csw:GetRecords maxRecords="10" outputFormat="application/xml"
    outputSchema="http://www.isotc211.org/2005/gmi" service="CSW"
    startPosition="1" version="2.0.2" xmlns="http://www.opengis.net/cat/csw/2.0.2"
    xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
    <csw:Query typeNames="csw:Record">
        <csw:ElementSetName>full</csw:ElementSetName>
         <csw:Constraint version="1.1.0">
            <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                 <ogc:PropertyIsGreaterThanOrEqualTo>
                     <ogc:PropertyName>Modified</ogc:PropertyName>
                     <ogc:Literal>200000015-01-01</ogc:Literal>
                 </ogc:PropertyIsGreaterThanOrEqualTo>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', :params => get_records_request_xml
      expect(response).to render_template('shared/exception_report.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'ExceptionReport'
      # There should be a SearchStatus with a timestamp
      exception_node_set = records_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_node_set.size).to eq(1)
      expect(exception_node_set[0]['exceptionCode']).to eq('NoApplicableCode')
      expect(exception_node_set[0]['locator']).to eq('NoApplicableCode')
      exception_text = exception_node_set[0].at_xpath('//ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_text.text).to eq("CMR call failure httpStatus: 400 message: 400 Bad Request response: updated_since datetime is invalid: [200000015-01-01] is not a valid datetime.")
    end
  end
end