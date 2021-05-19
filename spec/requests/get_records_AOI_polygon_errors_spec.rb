require 'spec_helper'

describe "GetRecords gml:Polygon error cases" do
  it 'correctly renders default HITS data in response to an Polygon constraint (missing points) POST request' do
    VCR.use_cassette 'requests/get_records/gmi/polygon_error_postlist', :decode_compressed_response => true, :record => :once do
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
                <!-- Operator defaults to overlaps / intersects -->
                <ogc:PropertyName>Geometry</ogc:PropertyName>
                <gml:Polygon srsName="http://www.opengis.net/gml/srs/epsg.xml#4326" xmlns:gml="http://www.opengis.net/gml">
                  <gml:outerBoundaryIs>
                    <gml:LinearRing>
                      <!-- MISSING posList
                      <gml:posList>-165.938 47.517 -138.516 27.684 -78.047 28.922 -85.781 64.168 -160.313 66.231 -165.938 47.517</gml:posList> -->
                    </gml:LinearRing>
                  </gml:outerBoundaryIs>
                </gml:Polygon>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', :params => get_records_request_xml
      expect(response).to have_http_status(:bad_request)
      expect(response).to render_template('shared/exception_report.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'ExceptionReport'
      # There should be a SearchStatus with a timestamp
      exception_node_set = records_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_node_set.size).to eq(1)
      expect(exception_node_set[0]['exceptionCode']).to eq('InvalidParameterValue')
      expect(exception_node_set[0]['locator']).to eq('Polygon')
      exception_text = exception_node_set[0].at_xpath('//ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_text.text).to eq("not in the supported GML format. [\"Gml polygon gml:posList - must be a space separated string of LON LAT point coordinates\"]")
    end
  end


  it 'correctly renders the exception page in response to an invalid XML in the POST request' do
    VCR.use_cassette 'requests/get_records/gmi/polygon_error_malformed', :decode_compressed_response => true, :record => :once do
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
                <!-- Operator defaults to overlaps / intersects -->
                <ogc:PropertyName>Geometry</ogc:PropertyName>
                <gml:Polygon srsName="http://www.opengis.net/gml/srs/epsg.xml#4326" xmlns:gml="http://www.opengis.net/gml">
                  <gml:outerBoundaryIs>
                    <gml:LinearRing>
                      <gml:posList>-165.938 47.517 -138.516 27.684 -78.047 28.922 -85.781 64.168 -160.313 66.231 -165.938 47.517</gml:posList>
                    </gml:LinearRing>
                  </gml:outerBoundaryIs>
                </gml:Polygon>
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
      expect(exception_text.text).to eq("Could not parse the GetRecords request body XML: 21:38: FATAL: Opening and ending tag mismatch: Constraint line 9 and ConstraintBAD_BAD_BAD")
    end
  end

  it 'correctly renders the exception page in response to an invalid XML in the POST request' do
    VCR.use_cassette 'requests/get_records/gmi/polygon_error_malformed_1', :decode_compressed_response => true, :record => :once do
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
                <!-- Operator defaults to overlaps / intersects -->
                <ogc:PropertyName>Geometry</ogc:PropertyName>
                <gml:Polygon srsName="http://www.opengis.net/gml/srs/epsg.xml#4326" xmlns:gml="http://www.opengis.net/gml">
                  <gml:outerBoundaryIs>
                    <gml:LinearRing>
                      <gml:posList>-165.938 47.517 -138.516 27.684 -78.047 28.922 -85.781 64.168 -160.313 66.231 -165.938 47.517</gml:posList>
                    </gml:LinearRing>
                  </gml:outerBoundaryIs>
                </gml:Polygon>
           <!-- NO CLOSING FILTER </ogc:Filter> -->
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
      expect(exception_text.text).to eq("Could not parse the GetRecords request body XML: 24:1: FATAL: Premature end of data in tag GetRecords line 1")
    end
  end

  it 'correctly renders the exception page in response to an invalid gml:Polygon (odd number of points) in the POST request' do
    VCR.use_cassette 'requests/get_records/gmi/polygon_error_oddpoints', :decode_compressed_response => true, :record => :once do
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
                <!-- Operator defaults to overlaps / intersects -->
                <ogc:PropertyName>Geometry</ogc:PropertyName>
                <gml:Polygon srsName="http://www.opengis.net/gml/srs/epsg.xml#4326" xmlns:gml="http://www.opengis.net/gml">
                  <gml:outerBoundaryIs>
                    <gml:LinearRing>
                      <gml:posList>-165.938 47.517 -138.516 27.684 -78.047 28.922 -85.781 64.168 -160.313 66.231 -165.938</gml:posList>
                    </gml:LinearRing>
                  </gml:outerBoundaryIs>
                </gml:Polygon>
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
      expect(exception_node_set[0]['locator']).to eq('Polygon')
      exception_text = exception_node_set[0].at_xpath('//ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_text.text).to eq("not in the supported GML format. [\"Gml polygon gml:posList - must be a space separated string of LON LAT point coordinates\"]")
    end
  end

  it 'correctly renders the exception page in response to an invalid gml:Polygon (different 1st and last points) in the POST request' do
    VCR.use_cassette 'requests/get_records/gmi/polygon_error_notclosed', :decode_compressed_response => true, :record => :once do
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
                <!-- Operator defaults to overlaps / intersects -->
                <ogc:PropertyName>Geometry</ogc:PropertyName>
                <gml:Polygon srsName="http://www.opengis.net/gml/srs/epsg.xml#4326" xmlns:gml="http://www.opengis.net/gml">
                  <gml:outerBoundaryIs>
                    <gml:LinearRing>
                      <gml:posList>-165.938 47.517 -138.516 27.684 -78.047 28.922 -85.781 64.168 -160.313 66.231 -165.938 47.5177777</gml:posList>
                    </gml:LinearRing>
                  </gml:outerBoundaryIs>
                </gml:Polygon>
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
      expect(exception_node_set[0]['locator']).to eq('Polygon')
      exception_text = exception_node_set[0].at_xpath('//ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_text.text).to eq("not in the supported GML format. [\"Gml polygon gml:posList - first (-165.938 47.517) and last (-165.938 47.5177777) point of the polygon must be indentical\"]")
    end
  end

  it 'correctly renders the exception page in response to an invalid gml:Polygon (invalid LON) in the POST request' do
    VCR.use_cassette 'requests/get_records/gmi/polygon_error_lon', :decode_compressed_response => true, :record => :once do
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
                <!-- Operator defaults to overlaps / intersects -->
                <ogc:PropertyName>Geometry</ogc:PropertyName>
                <gml:Polygon srsName="http://www.opengis.net/gml/srs/epsg.xml#4326" xmlns:gml="http://www.opengis.net/gml">
                  <gml:outerBoundaryIs>
                    <gml:LinearRing>
                      <gml:posList>-165.938 47.517 -195.938 27.684 -78.047 28.922 -85.781 64.168 -160.313 66.231 -165.938 47.517</gml:posList>
                    </gml:LinearRing>
                  </gml:outerBoundaryIs>
                </gml:Polygon>
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
      expect(exception_node_set[0]['locator']).to eq('Polygon')
      exception_text = exception_node_set[0].at_xpath('//ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_text.text).to eq("not in the supported GML format. [\"Longitude -195.938 must be between -180 and 180 degrees\"]")
    end
  end

  it 'correctly renders the exception page in response to an invalid gml:Polygon (invalid LAT) in the POST request' do
    VCR.use_cassette 'requests/get_records/gmi/polygon_error_lat', :decode_compressed_response => true, :record => :once do
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
                <!-- Operator defaults to overlaps / intersects -->
                <ogc:PropertyName>Geometry</ogc:PropertyName>
                <gml:Polygon srsName="http://www.opengis.net/gml/srs/epsg.xml#4326" xmlns:gml="http://www.opengis.net/gml">
                  <gml:outerBoundaryIs>
                    <gml:LinearRing>
                      <gml:posList>-165.938 47.517 -138.516 97.684 -78.047 28.922 -85.781 64.168 -160.313 66.231 -165.938 47.517</gml:posList>
                    </gml:LinearRing>
                  </gml:outerBoundaryIs>
                </gml:Polygon>
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
      expect(exception_node_set[0]['locator']).to eq('Polygon')
      exception_text = exception_node_set[0].at_xpath('//ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_text.text).to eq("not in the supported GML format. [\"Latitude 97.684 must be between -90 and 90 degrees\"]")
    end
  end

  it 'correctly renders the exception page in response to an invalid gml:Polygon (invalid LON LAT) in the POST request' do
    VCR.use_cassette 'requests/get_records/gmi/polygon_error_lonlat', :decode_compressed_response => true, :record => :once do
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
                <!-- Operator defaults to overlaps / intersects -->
                <ogc:PropertyName>Geometry</ogc:PropertyName>
                <gml:Polygon srsName="http://www.opengis.net/gml/srs/epsg.xml#4326" xmlns:gml="http://www.opengis.net/gml">
                  <gml:outerBoundaryIs>
                    <gml:LinearRing>
                      <gml:posList>-165.938 47.517 -198.516 97.684 -78.047 28.922 -85.781 64.168 -160.313 66.231 -165.938 47.517</gml:posList>
                    </gml:LinearRing>
                  </gml:outerBoundaryIs>
                </gml:Polygon>
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
      expect(exception_node_set[0]['locator']).to eq('Polygon')
      exception_text = exception_node_set[0].at_xpath('//ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows')
      expect(exception_text.text).to eq("not in the supported GML format. [\"Longitude -198.516 must be between -180 and 180 degrees\", \"Latitude 97.684 must be between -90 and 90 degrees\"]")
    end
  end
end
