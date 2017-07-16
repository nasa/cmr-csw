require 'spec_helper'

describe "GetRecords gml:Line error cases" do
  it 'correctly renders default HITS data in response to an Line constraint (missing points) POST request' do
    VCR.use_cassette 'requests/get_records/gmi/line_error_postlist', :decode_compressed_response => true, :record => :once do
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
              <gml:LineString xmlns:gml="http://www.opengis.net/gml">
                <!-- missing postList
                <gml:posList>-165.938 47.517 -138.516 27.684 -78.047 28.922 -85.781 64.168 -160.313 66.231</gml:posList>
                -->
              </gml:LineString>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', get_records_request_xml
      expect(response).to have_http_status(:bad_request)
      expect(response).to render_template('shared/exception_report.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'ExceptionReport'
      # There should be a SearchStatus with a timestamp
      exception_node_set = records_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_node_set.size).to eq(1)
      expect(exception_node_set[0]['exceptionCode']).to eq('InvalidParameterValue')
      expect(exception_node_set[0]['locator']).to eq('LineString')
      exception_text = exception_node_set[0].at_xpath('//ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_text.text).to eq("not in the supported GML format. [\"Gml line gml:posList - must be a space separated string of LON LAT point coordinates\"]")
    end
  end


  it 'correctly renders the exception page in response to an invalid XML in the POST request' do
    VCR.use_cassette 'requests/get_records/gmi/line_error_malformed', :decode_compressed_response => true, :record => :once do
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
              <gml:LineString xmlns:gml="http://www.opengis.net/gml">
                <gml:posList>-165.938 47.517 -138.516 27.684 -78.047 28.922 -85.781 64.168 -160.313 66.231</gml:posList>
              </gml:LineString>
            </ogc:Filter>
        </csw:ConstraintBAD_BAD_BAD>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', get_records_request_xml
      expect(response).to render_template('shared/exception_report.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'ExceptionReport'
      # There should be a SearchStatus with a timestamp
      exception_node_set = records_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_node_set.size).to eq(1)
      expect(exception_node_set[0]['exceptionCode']).to eq('NoApplicableCode')
      expect(exception_node_set[0]['locator']).to eq('NoApplicableCode')
      exception_text = exception_node_set[0].at_xpath('//ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_text.text).to eq("Could not parse the GetRecords request body XML: Opening and ending tag mismatch: Constraint line 9 and ConstraintBAD_BAD_BAD")
    end
  end

  it 'correctly renders the exception page in response to an invalid gml:LineString (odd number of points) in the POST request' do
    VCR.use_cassette 'requests/get_records/gmi/line_error_oddpoints', :decode_compressed_response => true, :record => :once do
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
              <gml:LineString xmlns:gml="http://www.opengis.net/gml">
                <gml:posList>-165.938 47.517 -138.516 27.684 -78.047 28.922 -85.781 64.168 -160.313</gml:posList>
              </gml:LineString>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', get_records_request_xml
      expect(response).to render_template('shared/exception_report.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'ExceptionReport'
      # There should be a SearchStatus with a timestamp
      exception_node_set = records_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_node_set.size).to eq(1)
      expect(exception_node_set[0]['exceptionCode']).to eq('InvalidParameterValue')
      expect(exception_node_set[0]['locator']).to eq('LineString')
      exception_text = exception_node_set[0].at_xpath('//ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_text.text).to eq("not in the supported GML format. [\"Gml line gml:posList - must be a space separated string of LON LAT point coordinates\"]")
    end
  end

  it 'correctly renders the exception page in response to an invalid gml:LineString (invalid LON) in the POST request' do
    VCR.use_cassette 'requests/get_records/gmi/line_error_lon', :decode_compressed_response => true, :record => :once do
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
              <gml:LineString xmlns:gml="http://www.opengis.net/gml">
                <gml:posList>-165.938 47.517 -138.516 27.684 -78.047 28.922 -85.781 64.168 -180.313  66.231</gml:posList>
              </gml:LineString>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', get_records_request_xml
      expect(response).to render_template('shared/exception_report.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'ExceptionReport'
      # There should be a SearchStatus with a timestamp
      exception_node_set = records_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_node_set.size).to eq(1)
      expect(exception_node_set[0]['exceptionCode']).to eq('InvalidParameterValue')
      expect(exception_node_set[0]['locator']).to eq('LineString')
      exception_text = exception_node_set[0].at_xpath('//ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_text.text).to eq("not in the supported GML format. [\"Longitude -180.313 must be between -180 and 180 degrees\"]")
    end
  end

  it 'correctly renders the exception page in response to an invalid gml:LineString (invalid LAT) in the POST request' do
    VCR.use_cassette 'requests/get_records/gmi/line_error_lat', :decode_compressed_response => true, :record => :once do
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
              <gml:LineString xmlns:gml="http://www.opengis.net/gml">
                <gml:posList>-165.938 47.517 -138.516 27.684 -78.047 28.922 -85.781 64.168 -160.313  99.231</gml:posList>
              </gml:LineString>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', get_records_request_xml
      expect(response).to render_template('shared/exception_report.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'ExceptionReport'
      # There should be a SearchStatus with a timestamp
      exception_node_set = records_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_node_set.size).to eq(1)
      expect(exception_node_set[0]['exceptionCode']).to eq('InvalidParameterValue')
      expect(exception_node_set[0]['locator']).to eq('LineString')
      exception_text = exception_node_set[0].at_xpath('//ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_text.text).to eq("not in the supported GML format. [\"Latitude 99.231 must be between -90 and 90 degrees\"]")
    end
  end

  it 'correctly renders the exception page in response to an invalid gml:LineString (invalid LON LAT) in the POST request' do
    VCR.use_cassette 'requests/get_records/gmi/line_error_lonlat', :decode_compressed_response => true, :record => :once do
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
              <gml:LineString xmlns:gml="http://www.opengis.net/gml">
                <gml:posList>-165.938 47.517 -138.516 27.684 -78.047 28.922 -85.781 64.168 -190.313  99.231</gml:posList>
              </gml:LineString>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', get_records_request_xml
      expect(response).to render_template('shared/exception_report.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'ExceptionReport'
      # There should be a SearchStatus with a timestamp
      exception_node_set = records_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_node_set.size).to eq(1)
      expect(exception_node_set[0]['exceptionCode']).to eq('InvalidParameterValue')
      expect(exception_node_set[0]['locator']).to eq('LineString')
      exception_text = exception_node_set[0].at_xpath('//ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_text.text).to eq("not in the supported GML format. [\"Longitude -190.313 must be between -180 and 180 degrees\", \"Latitude 99.231 must be between -90 and 90 degrees\"]")
    end
  end

  it 'correctly renders the exception page in response to an invalid gml:LineString (repeating points) in the POST request' do
    VCR.use_cassette 'requests/get_records/gmi/line_error_rpoints', :decode_compressed_response => true, :record => :once do
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
              <gml:LineString xmlns:gml="http://www.opengis.net/gml">
                <gml:posList>-165.938 47.517 -138.516 27.684 -78.047 28.922 -85.781 64.168 -165.938 47.517 -78.047 28.922</gml:posList>
              </gml:LineString>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', get_records_request_xml
      expect(response).to render_template('shared/exception_report.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'ExceptionReport'
      # There should be a SearchStatus with a timestamp
      exception_node_set = records_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_node_set.size).to eq(1)
      expect(exception_node_set[0]['exceptionCode']).to eq('InvalidParameterValue')
      expect(exception_node_set[0]['locator']).to eq('LineString')
      exception_text = exception_node_set[0].at_xpath('//ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_text.text).to eq("not in the supported GML format. [\"Gml line gml:posList - cannot have duplicate points (-165.938 47.517\", \"Gml line gml:posList - cannot have duplicate points (-78.047 28.922\"]")
    end
  end
end
