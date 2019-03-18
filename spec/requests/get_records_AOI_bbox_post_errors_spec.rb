require 'spec_helper'

describe "GetRecords BBOX error cases" do
  # No error, NO contraint CMR query
  it 'correctly renders default HITS data in response to the resultType missing and an ogc:BBOX with no Envelope constraint POST request' do
    VCR.use_cassette 'requests/get_records/gmi/bbox_error_missing_envelope', :decode_compressed_response => true, :record => :once do
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
                     <ogc:BBOX>
                        <ogc:PropertyName>iso:BoundingBox</ogc:PropertyName>
                        <!-- Envelope missing
                        <gml:Envelope xmlns:gml="http://www.opengis.net/gml">
                            <gml:lowerCorner>-180 -90</gml:lowerCorner>
                            <gml:upperCorner>180 90</gml:upperCorner>
                        </gml:Envelope> -->
                    </ogc:BBOX>
            </ogc:Filter>
         </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', get_records_request_xml
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
    end
  end

  it 'correctly renders default HITS data in response to the resultType missing and an ogc:BBOX with no lowerCorner constraint POST request' do
    VCR.use_cassette 'requests/get_records/gmi/bbox_error_missing_lower', :decode_compressed_response => true, :record => :once do
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
                     <ogc:BBOX>
                        <ogc:PropertyName>iso:BoundingBox</ogc:PropertyName>
                        <gml:Envelope xmlns:gml="http://www.opengis.net/gml">
                            <!-- LOWER CORNER MISSING <gml:lowerCorner>-180 -90</gml:lowerCorner> -->
                            <gml:upperCorner>180 90</gml:upperCorner>
                        </gml:Envelope>
                    </ogc:BBOX>
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
      expect(exception_node_set[0]['locator']).to eq('BoundingBox')
      exception_text = exception_node_set[0].at_xpath('//ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_text.text).to eq("not in the supported ISO format. [\"Lowercorner longitude  must be between -180 and 180 degrees\", \"Lowercorner longitude must be between -180 and 180 degrees\", \"Lowercorner latitude  must be between -90 and 90 degrees\", \"Lowercorner latitude must be between -90 and 90 degrees\"]")
    end
  end

  it 'correctly renders default HITS data in response to the resultType missing and an ogc:BBOX with no upper Corner constraint POST request' do
    VCR.use_cassette 'requests/get_records/gmi/bbox_error_missing_upper', :decode_compressed_response => true, :record => :once do
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
                     <ogc:BBOX>
                        <ogc:PropertyName>iso:BoundingBox</ogc:PropertyName>
                        <gml:Envelope xmlns:gml="http://www.opengis.net/gml">
                            <gml:lowerCorner>-180 -90</gml:lowerCorner>
                            <!-- UPPER CORNER MISSING  <gml:upperCorner>180 90</gml:upperCorner> -->
                        </gml:Envelope>
                    </ogc:BBOX>
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
      expect(exception_node_set[0]['locator']).to eq('BoundingBox')
      exception_text = exception_node_set[0].at_xpath('//ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_text.text).to eq("not in the supported ISO format. [\"Uppercorner longitude  must be between -180 and 180 degrees\", \"Uppercorner longitude must be between -180 and 180 degrees\", \"Uppercorner latitude  must be between -90 and 90 degrees\", \"Uppercorner latitude must be between -90 and 90 degrees\"]")
    end
  end

  it 'correctly renders Exception page in response to an invalid XML POST request' do
    VCR.use_cassette 'requests/get_records/gmi/bbox_malformed', :decode_compressed_response => true, :record => :once do
      get_records_request_xml = <<-eos
<csw:GetRecords maxRecords="10" outputFormat="application/xml"
    outputSchema="http://www.isotc211.org/2005/gmi" service="CSW"
    startPosition="1" version="2.0.2" xmlns="http://www.opengis.net/cat/csw/2.0.2"
    xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
    <csw:Query typeNames="csw:Record">
        <csw:ElementSetName>full</csw:ElementSetName>
        <csw:Constraint>
            <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                     <ogc:BBOX>
                        <ogc:PropertyName>iso:BoundingBox</ogc:PropertyName>
                        <gml:Envelope xmlns:gml="http://www.opengis.net/gml">
                            <gml:lowerCorner>-180 -90</gml:lowerCorner>
                            <gml:upperCorner>180 90</gml:upperCorner>
                        </gml:Envelope>
                    </ogc:BBOX>
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
      expect(exception_text.text).to eq("Could not parse the GetRecords request body XML: 19:37: FATAL: Opening and ending tag mismatch: Constraint line 9 and ConstraintBAD_BAD_BAD")
    end
  end

  it 'correctly renders Exception page in response to an XML POST BBOX request with invalid lowerCorner LON coordinates' do
    VCR.use_cassette 'requests/get_records/gmi/bbox_error_lon', :decode_compressed_response => true, :record => :once do
      get_records_request_xml = <<-eos
<csw:GetRecords maxRecords="10" outputFormat="application/xml"
    outputSchema="http://www.isotc211.org/2005/gmi" service="CSW"
    startPosition="1" version="2.0.2" xmlns="http://www.opengis.net/cat/csw/2.0.2"
    xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
    <csw:Query typeNames="csw:Record">
        <csw:ElementSetName>full</csw:ElementSetName>
        <csw:Constraint>
            <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                     <ogc:BBOX>
                        <ogc:PropertyName>iso:BoundingBox</ogc:PropertyName>
                        <gml:Envelope xmlns:gml="http://www.opengis.net/gml">
                            <gml:lowerCorner>-181 -90</gml:lowerCorner>
                            <gml:upperCorner>180 90</gml:upperCorner>
                        </gml:Envelope>
                    </ogc:BBOX>
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
      expect(exception_node_set[0]['locator']).to eq('BoundingBox')
      exception_text = exception_node_set[0].at_xpath('//ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_text.text).to eq("not in the supported ISO format. [\"Lowercorner longitude -181.0 must be between -180 and 180 degrees\"]")
    end
  end

  it 'correctly renders Exception page in response to an XML POST BBOX request with invalid lowerCorner LAT coordinates' do
    VCR.use_cassette 'requests/get_records/gmi/bbox_error_lat', :decode_compressed_response => true, :record => :once do
      get_records_request_xml = <<-eos
<csw:GetRecords maxRecords="10" outputFormat="application/xml"
    outputSchema="http://www.isotc211.org/2005/gmi" service="CSW"
    startPosition="1" version="2.0.2" xmlns="http://www.opengis.net/cat/csw/2.0.2"
    xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
    <csw:Query typeNames="csw:Record">
        <csw:ElementSetName>full</csw:ElementSetName>
        <csw:Constraint>
            <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                     <ogc:BBOX>
                        <ogc:PropertyName>iso:BoundingBox</ogc:PropertyName>
                        <gml:Envelope xmlns:gml="http://www.opengis.net/gml">
                            <gml:lowerCorner>-180 -91</gml:lowerCorner>
                            <gml:upperCorner>180 90</gml:upperCorner>
                        </gml:Envelope>
                    </ogc:BBOX>
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
      expect(exception_node_set[0]['locator']).to eq('BoundingBox')
      exception_text = exception_node_set[0].at_xpath('//ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_text.text).to eq("not in the supported ISO format. [\"Lowercorner latitude -91.0 must be between -90 and 90 degrees\"]")
    end
  end

  it 'correctly renders Exception page in response to an XML POST BBOX request with invalid lowerCorner LON LAT coordinates' do
    VCR.use_cassette 'requests/get_records/gmi/bbox_error_lon_lat', :decode_compressed_response => true, :record => :once do
      get_records_request_xml = <<-eos
<csw:GetRecords maxRecords="10" outputFormat="application/xml"
    outputSchema="http://www.isotc211.org/2005/gmi" service="CSW"
    startPosition="1" version="2.0.2" xmlns="http://www.opengis.net/cat/csw/2.0.2"
    xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
    <csw:Query typeNames="csw:Record">
        <csw:ElementSetName>full</csw:ElementSetName>
        <csw:Constraint>
            <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                     <ogc:BBOX>
                        <ogc:PropertyName>iso:BoundingBox</ogc:PropertyName>
                        <gml:Envelope xmlns:gml="http://www.opengis.net/gml">
                            <gml:lowerCorner>-181 -91</gml:lowerCorner>
                            <gml:upperCorner>180 90</gml:upperCorner>
                        </gml:Envelope>
                    </ogc:BBOX>
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
      expect(exception_node_set[0]['locator']).to eq('BoundingBox')
      exception_text = exception_node_set[0].at_xpath('//ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_text.text).to eq("not in the supported ISO format. [\"Lowercorner longitude -181.0 must be between -180 and 180 degrees\", \"Lowercorner latitude -91.0 must be between -90 and 90 degrees\"]")
    end
  end

end