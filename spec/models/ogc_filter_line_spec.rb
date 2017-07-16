require 'spec_helper'

RSpec.describe OgcFilterLine do
  describe 'OGC LineString spatial Filter examples' do
    it "corectly produces a CMR query string from a valid gml:LineString" do
      filter_xml_string = <<-eos
            <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
              <gml:LineString xmlns:gml="http://www.opengis.net/gml">
                <gml:posList>-165.938 47.517 -138.516 27.684 -78.047 28.922 -85.781 64.168 -160.313 66.231</gml:posList>
              </gml:LineString>
            </ogc:Filter>
      eos
      filter_xml = Nokogiri::XML(filter_xml_string)
      line = GmlLine.new(filter_xml)
      expect(line.valid?).to eq true
      expect(line.to_cmr).to eq ('-165.938,47.517,-138.516,27.684,-78.047,28.922,-85.781,64.168,-160.313,66.231')
    end

    it "corectly detects an invalid gml:LineString which has repeating points" do
      filter_xml_string = <<-eos
             <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
              <gml:LineString xmlns:gml="http://www.opengis.net/gml">
                <gml:posList>-165.938 47.517 -138.516 27.684 -78.047 28.922 -85.781 64.168 -160.313 66.231 -165.938 47.517</gml:posList>
              </gml:LineString>
            </ogc:Filter>
      eos
      filter_xml = Nokogiri::XML(filter_xml_string)
      line = GmlLine.new(filter_xml)
      expect(line.valid?).to eq false
      expect(line.errors.full_messages.to_s).to eq ("[\"Gml line gml:posList - cannot have duplicate points (-165.938 47.517\"]")
    end

    it "corectly detects an invalid gml:LineString which does not have an even number of coordinates" do
      filter_xml_string = <<-eos
             <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
              <gml:LineString xmlns:gml="http://www.opengis.net/gml">
                <gml:posList>-165.938 47.517 -138.516 27.684 -78.047 28.922 -85.781 64.168 -160.313</gml:posList>
              </gml:LineString>
            </ogc:Filter>
      eos
      filter_xml = Nokogiri::XML(filter_xml_string)
      line = GmlLine.new(filter_xml)
      expect(line.valid?).to eq false
      expect(line.errors.full_messages.to_s).to eq ("[\"Gml line gml:posList - must be a space separated string of LON LAT point coordinates\"]")
    end

    it "corectly detects an invalid gml:LineString which does not have any coordinates" do
      filter_xml_string = <<-eos
            <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
              <gml:LineString xmlns:gml="http://www.opengis.net/gml">
                <gml:posList></gml:posList>
              </gml:LineString>
            </ogc:Filter>
      eos
      filter_xml = Nokogiri::XML(filter_xml_string)
      line = GmlLine.new(filter_xml)
      expect(line.valid?).to eq false
      expect(line.errors.full_messages.to_s).to eq ("[\"Gml line gml:posList - must be a space separated string of LON LAT point coordinates\"]")
    end

    it "corectly detects an well formed gml:Line with invalid lon lat coordinates" do
      filter_xml_string = <<-eos
           <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
              <gml:LineString xmlns:gml="http://www.opengis.net/gml">
                <gml:posList>-181.938 90.517 -138.516 27.684 -200.047 -90.922 -85.781 64.168 -160.313 91.231</gml:posList>
              </gml:LineString>
            </ogc:Filter>
      eos
      filter_xml = Nokogiri::XML(filter_xml_string)
      line = GmlLine.new(filter_xml)
      expect(line.valid?).to eq false
      expect(line.errors.size).to eq 5
      expect(line.errors.full_messages[0]).to eq("Longitude -181.938 must be between -180 and 180 degrees")
      expect(line.errors.full_messages[1]).to eq("Longitude -200.047 must be between -180 and 180 degrees")
      expect(line.errors.full_messages[2]).to eq("Latitude 90.517 must be between -90 and 90 degrees")
      expect(line.errors.full_messages[3]).to eq("Latitude -90.922 must be between -90 and 90 degrees")
      expect(line.errors.full_messages[4]).to eq("Latitude 91.231 must be between -90 and 90 degrees")
    end

    it 'is possible to generate a line CMR query from a GetRecords POST XML request' do
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
              <gml:LineString xmlns:gml="http://www.opengis.net/gml">
                <gml:posList>-165.938 47.517 -138.516 27.684 -78.047 28.922 -85.781 64.168 -160.313 66.231</gml:posList>
              </gml:LineString>
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
      helper = OgcFilterLine.new
      cmr_query_params = helper.process(filter)
      expect(cmr_query_params['line']).to eq('-165.938,47.517,-138.516,27.684,-78.047,28.922,-85.781,64.168,-160.313,66.231')
    end

    it 'is NOT possible to generate a CMR query from a GetRecords POST XML request with an invalid gml:LineString' do
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
              <gml:LineString xmlns:gml="http://www.opengis.net/gml">
                <gml:posList>-165.938 47.517 -138.516 27.684 -78.047 28.922 -85.781 64.168 -160.313 66.231 -165.938 47.517</gml:posList>
              </gml:LineString>
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
      cmr_query_params = Hash.new
      helper = OgcFilterLine.new
      begin
        cmr_query_params = helper.process(filter)
      rescue OwsException => e
        expect(e.text).to eq("not in the supported GML format. [\"Gml line gml:posList - cannot have duplicate points (-165.938 47.517\"]")
        expect(e.code).to eq('InvalidParameterValue')
        expect(e.locator).to eq('LineString')
      end
    end
  end
end