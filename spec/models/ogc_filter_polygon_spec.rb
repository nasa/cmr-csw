require 'spec_helper'

RSpec.describe OgcFilterPolygon do
  describe 'OGC polygon spatial Filter examples' do
    it "corectly produces a CMR query string from a valid gml:Polygon" do
      filter_xml_string = <<-eos
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
      eos
      filter_xml = Nokogiri::XML(filter_xml_string)
      polygon = GmlPolygon.new(filter_xml)
      expect(polygon.valid?).to eq true
      expect(polygon.to_cmr).to eq ('-165.938,47.517,-138.516,27.684,-78.047,28.922,-85.781,64.168,-160.313,66.231,-165.938,47.517')
    end

    it "corectly detects an invalid gml:Polygon which is not closed by having indentical first and last points" do
      filter_xml_string = <<-eos
            <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                <!-- Operator defaults to overlaps / intersects -->
                <ogc:PropertyName>Geometry</ogc:PropertyName>
                <gml:Polygon srsName="http://www.opengis.net/gml/srs/epsg.xml#4326" xmlns:gml="http://www.opengis.net/gml">
                  <gml:outerBoundaryIs>
                    <gml:LinearRing>
                      <gml:posList>-165.938 47.517 -138.516 27.684 -78.047 28.922 -85.781 64.168 -160.313 66.231 -165.938 0.000</gml:posList>
                    </gml:LinearRing>
                  </gml:outerBoundaryIs>
                </gml:Polygon>
            </ogc:Filter>
      eos
      filter_xml = Nokogiri::XML(filter_xml_string)
      polygon = GmlPolygon.new(filter_xml)
      expect(polygon.valid?).to eq false
      expect(polygon.errors.full_messages.to_s).to eq ("[\"Gml polygon gml:posList - first (-165.938 47.517) and last (-165.938 0.000) point of the polygon must be indentical\"]")
    end

    it "corectly detects an invalid gml:Polygon which does not have an even number of coordinates" do
      filter_xml_string = <<-eos
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
      eos
      filter_xml = Nokogiri::XML(filter_xml_string)
      polygon = GmlPolygon.new(filter_xml)
      expect(polygon.valid?).to eq false
      expect(polygon.errors.full_messages.to_s).to eq ("[\"Gml polygon gml:posList - must be a space separated string of LON LAT point coordinates\"]")
    end

    it "corectly detects an invalid gml:Polygon which does not have any coordinates" do
      filter_xml_string = <<-eos
            <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                <!-- Operator defaults to overlaps / intersects -->
                <ogc:PropertyName>Geometry</ogc:PropertyName>
                <gml:Polygon srsName="http://www.opengis.net/gml/srs/epsg.xml#4326" xmlns:gml="http://www.opengis.net/gml">
                  <gml:outerBoundaryIs>
                    <gml:LinearRing>
                      <gml:posList></gml:posList>
                    </gml:LinearRing>
                  </gml:outerBoundaryIs>
                </gml:Polygon>
            </ogc:Filter>
      eos
      filter_xml = Nokogiri::XML(filter_xml_string)
      polygon = GmlPolygon.new(filter_xml)
      expect(polygon.valid?).to eq false
      expect(polygon.errors.full_messages.to_s).to eq ("[\"Gml polygon gml:posList - must be a space separated string of LON LAT point coordinates\"]")
    end

    it "corectly detects an well formed gml:Polygon shape with invalid lon lat coordinates" do
      filter_xml_string = <<-eos
            <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                <!-- Operator defaults to overlaps / intersects -->
                <ogc:PropertyName>Geometry</ogc:PropertyName>
                <gml:Polygon srsName="http://www.opengis.net/gml/srs/epsg.xml#4326" xmlns:gml="http://www.opengis.net/gml">
                  <gml:outerBoundaryIs>
                    <gml:LinearRing>
                      <gml:posList>-181.938 91.517 180.516 90.684 -78.047 28.922 -85.781 64.168 -160.313 66.231 -181.938 91.517</gml:posList>
                    </gml:LinearRing>
                  </gml:outerBoundaryIs>
                </gml:Polygon>
            </ogc:Filter>
      eos
      filter_xml = Nokogiri::XML(filter_xml_string)
      polygon = GmlPolygon.new(filter_xml)
      expect(polygon.valid?).to eq false
      expect(polygon.errors.size).to eq 6
      expect(polygon.errors.full_messages[0]).to eq("Longitude -181.938 must be between -180 and 180 degrees")
      expect(polygon.errors.full_messages[1]).to eq("Longitude 180.516 must be between -180 and 180 degrees")
      expect(polygon.errors.full_messages[2]).to eq("Longitude -181.938 must be between -180 and 180 degrees")
      expect(polygon.errors.full_messages[3]).to eq("Latitude 91.517 must be between -90 and 90 degrees")
      expect(polygon.errors.full_messages[4]).to eq("Latitude 90.684 must be between -90 and 90 degrees")
      expect(polygon.errors.full_messages[5]).to eq("Latitude 91.517 must be between -90 and 90 degrees")
    end

    it 'is possible to generate a polygon CMR query from a GetRecords POST XML request' do
      get_records_request_xml = <<-eos
<csw:GetRecords maxRecords="10" outputFormat="application/xml"
    outputSchema="http://www.isotc211.org/2005/gmd" resultType="results" service="CSW"
    startPosition="1" version="2.0.2" xmlns="http://www.opengis.net/cat/csw/2.0.2"
    xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
    <csw:Query typeNames="csw:Record">
        <csw:ElementSetName>full</csw:ElementSetName>
        <csw:Constraint version="1.1.0" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2">
            <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                <!-- Operator defaults to overlaps / intersects -->
                <PropertyName>Geometry</PropertyName>
                <gml:Polygon srsName="http://www.opengis.net/gml/srs/epsg.xml#4326">
                  <gml:outerBoundaryIs>
                    <gml:LinearRing>
                      <gml:posList>-165.938 47.517 -138.516 27.684 -78.047 28.922 -85.781 64.168 -160.313 66.231 -165.938 47.517</gml:posList>
                    </gml:LinearRing>
                  </gml:outerBoundaryIs>
                </gml:Polygon>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      request_body_xml = Nokogiri::XML(get_records_request_xml)
      filter = request_body_xml.at_xpath("//csw:GetRecords//csw:Query//csw:Constraint//ogc:Filter",
                                         'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                         'ogc' => 'http://www.opengis.net/ogc')
      expect(filter).not_to eq nil
      helper = OgcFilterPolygon.new
      cmr_query_params = helper.process(filter)
      expect(cmr_query_params['polygon']).to eq('-165.938,47.517,-138.516,27.684,-78.047,28.922,-85.781,64.168,-160.313,66.231,-165.938,47.517')
    end

    it 'is NOT possible to generate a CMR query from a GetRecords POST XML request with an invalid gml:Polygon' do
      start_time_only_constraint_get_records_request_xml = <<-eos
<csw:GetRecords maxRecords="10" outputFormat="application/xml"
    outputSchema="http://www.isotc211.org/2005/gmd" resultType="results" service="CSW"
    startPosition="1" version="2.0.2" xmlns="http://www.opengis.net/cat/csw/2.0.2"
    xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
    <csw:Query typeNames="csw:Record">
        <csw:ElementSetName>full</csw:ElementSetName>
        <csw:Constraint version="1.1.0" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2">
            <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                <!-- Operator defaults to overlaps / intersects -->
                <ogc:PropertyName>Geometry</ogc:PropertyName>
                <gml:Polygon srsName="http://www.opengis.net/gml/srs/epsg.xml#4326" xmlns:gml="http://www.opengis.net/gml">
                  <gml:outerBoundaryIs>
                    <gml:LinearRing>
                      <gml:posList>-165.938 47.517 -138.516 27.684 -78.047 28.922 -85.781 64.168 -160.313 66.231 -165.938 0.000</gml:posList>
                    </gml:LinearRing>
                  </gml:outerBoundaryIs>
                </gml:Polygon>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      request_body_xml = Nokogiri::XML(start_time_only_constraint_get_records_request_xml)
      filter = request_body_xml.at_xpath("//csw:GetRecords//csw:Query//csw:Constraint//ogc:Filter",
                                         'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                         'ogc' => 'http://www.opengis.net/ogc')
      expect(filter).not_to eq nil
      cmr_query_params = Hash.new
      helper = OgcFilterPolygon.new
      begin
        cmr_query_params = helper.process(filter)
      rescue OwsException => e
        expect(e.text).to eq("not in the supported GML format. [\"Gml polygon gml:posList - first (-165.938 47.517) and last (-165.938 0.000) point of the polygon must be indentical\"]")
        expect(e.code).to eq('InvalidParameterValue')
        expect(e.locator).to eq('Polygon')
      end
    end
  end
end