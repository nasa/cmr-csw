require 'spec_helper'

RSpec.describe OgcFilterPoint do
  describe 'OGC Point spatial Filter examples' do
    it "corectly produces a CMR query string from a valid gml:Point" do
      filter_xml_string = <<-eos
            <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
              <gml:Point xmlns:gml="http://www.opengis.net/gml">
                <gml:pos>-165.938 47.517</gml:pos>
              </gml:Point>
            </ogc:Filter>
      eos
      filter_xml = Nokogiri::XML(filter_xml_string)
      point = GmlPoint.new(nil,nil,filter_xml)
      expect(point.valid?).to eq true
      expect(point.to_cmr).to eq ('-165.938,47.517')
    end

    it "corectly detects an invalid gml:Point which has a single coordinate" do
      filter_xml_string = <<-eos
             <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
              <gml:Point xmlns:gml="http://www.opengis.net/gml">
                <gml:pos>-165.938</gml:pos>
              </gml:Point>
            </ogc:Filter>
      eos
      filter_xml = Nokogiri::XML(filter_xml_string)
      point = GmlPoint.new(nil,nil,filter_xml)
      expect(point.valid?).to eq false
      expect(point.errors.full_messages.to_s).to eq ("[\"Longitude  must be between -180 and 180 degrees\", \"Longitude must be provided\", \"Latitude  must be between -90 and 90 degrees\", \"Latitude must be provided\"]")
    end

    it "corectly detects an invalid gml:Point which has more than two coordinates" do
      filter_xml_string = <<-eos
             <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
              <gml:Point xmlns:gml="http://www.opengis.net/gml">
                <gml:pos>-165.938  47.517 165.938  47.517</gml:pos>
              </gml:Point>
            </ogc:Filter>
      eos
      filter_xml = Nokogiri::XML(filter_xml_string)
      point = GmlPoint.new(nil,nil,filter_xml)
      expect(point.valid?).to eq false
      expect(point.errors.full_messages.to_s).to eq ("[\"Longitude  must be between -180 and 180 degrees\", \"Longitude must be provided\", \"Latitude  must be between -90 and 90 degrees\", \"Latitude must be provided\"]")
    end

    it "corectly detects an invalid gml:Point which does not have any coordinates" do
      filter_xml_string = <<-eos
             <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
              <gml:Point xmlns:gml="http://www.opengis.net/gml">
                <gml:pos></gml:pos>
              </gml:Point>
            </ogc:Filter>
      eos
      filter_xml = Nokogiri::XML(filter_xml_string)
      point = GmlPoint.new(nil,nil,filter_xml)
      expect(point.valid?).to eq false
      expect(point.errors.full_messages.to_s).to eq ("[\"Longitude  must be between -180 and 180 degrees\", \"Longitude must be provided\", \"Latitude  must be between -90 and 90 degrees\", \"Latitude must be provided\"]")
    end

    it "corectly detects an well formed gml:Point with invalid lon lat coordinates" do
      filter_xml_string = <<-eos
            <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
              <gml:Point xmlns:gml="http://www.opengis.net/gml">
                <gml:pos>-195.938  97.517</gml:pos>
              </gml:Point>
            </ogc:Filter>
      eos
      filter_xml = Nokogiri::XML(filter_xml_string)
      point = GmlPoint.new(nil,nil,filter_xml)
      expect(point.valid?).to eq false
      expect(point.errors.size).to eq 2
      expect(point.errors.full_messages[0]).to eq("Longitude -195.938 must be between -180 and 180 degrees")
      expect(point.errors.full_messages[1]).to eq("Latitude 97.517 must be between -90 and 90 degrees")
    end

    it 'is possible to generate a point CMR query from a GetRecords POST XML request' do
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
              <gml:Point xmlns:gml="http://www.opengis.net/gml">
                <gml:pos>-165.938  47.517</gml:pos>
              </gml:Point>
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
      helper = OgcFilterPoint.new
      cmr_query_params = helper.process(filter)
      expect(cmr_query_params['point']).to eq('-165.938,47.517')
    end

    it 'is NOT possible to generate a CMR query from a GetRecords POST XML request with an invalid gml:Point' do
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
              <gml:Point xmlns:gml="http://www.opengis.net/gml">
                <gml:pos>-195.938  47.517</gml:pos>
              </gml:Point>
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
      helper = OgcFilterPoint.new
      begin
        cmr_query_params = helper.process(filter)
      rescue OwsException => e
        expect(e.text).to eq("not in the supported GML format. [\"Longitude -195.938 must be between -180 and 180 degrees\"]")
        expect(e.code).to eq('InvalidParameterValue')
        expect(e.locator).to eq('Point')
      end
    end
  end
end