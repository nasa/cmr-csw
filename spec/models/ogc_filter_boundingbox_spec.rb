require 'spec_helper'

RSpec.describe OgcFilterBoundingBox do
  describe 'OGC boundingbox spatial Filter examples' do
    it 'is possible to generate a bounding box CMR query from a GetRecords POST XML request' do
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
              <ogc:BBOX>
                <ogc:PropertyName>iso:BoundingBox</ogc:PropertyName>
                <gml:Envelope xmlns:gml="http://www.opengis.net/gml">
                  <gml:lowerCorner>13 14</gml:lowerCorner>
                  <gml:upperCorner>15 16</gml:upperCorner>
                </gml:Envelope>
              </ogc:BBOX>
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
      helper = OgcFilterBoundingBox.new
      cmr_query_params = helper.process(filter)
      expect(cmr_query_params['bounding_box']).to eq('13,14,15,16')
    end

    it 'is NOT possible to generate a CMR query from a GetRecords POST XML request with an invalid iso:BoundingBox envelope' do
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
              <ogc:BBOX>
                <ogc:PropertyName>iso:BoundingBox</ogc:PropertyName>
                <gml:Envelope xmlns:gml="http://www.opengis.net/gml">
                  <gml:lowerCorner>-181 -91</gml:lowerCorner>
                  <gml:upperCorner>182 92</gml:upperCorner>
                </gml:Envelope>
              </ogc:BBOX>
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
      helper = OgcFilterBoundingBox.new
      begin
        cmr_query_params = helper.process(filter)
      rescue OwsException => e
        expect(e.text).to eq("not in the supported ISO format. [\"Lowercorner longitude -181.0 must be between -180 and 180 degrees\", \"Lowercorner latitude -91.0 must be between -90 and 90 degrees\", \"Uppercorner longitude 182.0 must be between -180 and 180 degrees\", \"Uppercorner latitude 92.0 must be between -90 and 90 degrees\"]")
        expect(e.code).to eq('InvalidParameterValue')
        expect(e.locator).to eq('BoundingBox')
      end
    end
  end
end