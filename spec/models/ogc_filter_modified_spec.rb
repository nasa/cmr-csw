require 'spec_helper'

RSpec.describe OgcFilterModified do
  describe 'OGC Modified (CMR updated_since) Filter Tests' do
    it 'is possible to generate an updated_since CMR query from a GetRecords POST XML request' do
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
                    <ogc:PropertyIsGreaterThanOrEqualTo>
                        <ogc:PropertyName>Modified</ogc:PropertyName>
                        <ogc:Literal>2016-04-01</ogc:Literal>
                    </ogc:PropertyIsGreaterThanOrEqualTo>
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
      helper = OgcFilterModified.new
      cmr_query_params = helper.process(filter)
      expect(cmr_query_params['updated_since']).to eq('2016-04-01')
    end
  end

  describe 'ERROR cases for OGC Modified (CMR updated_since) Filter Tests' do
    it 'is NOT possible to generate an updated_since CMR query from a GetRecords POST XML request with an invalid Modified date' do
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
                    <ogc:PropertyIsGreaterThanOrEqualTo>
                        <ogc:PropertyName>Modified</ogc:PropertyName>
                        <ogc:Literal>INVALID_DATE_HERE</ogc:Literal>
                    </ogc:PropertyIsGreaterThanOrEqualTo>
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
      helper = OgcFilterModified.new
      begin
        cmr_query_params = helper.process(filter)
      rescue OwsException => e
        expect(e.text).to eq("'INVALID_DATE_HERE' is NOT in the supported ISO8601 date format yyyy-MM-dd")
        expect(e.code).to eq('InvalidParameterValue')
        expect(e.locator).to eq('Modified')
      end
    end

    it 'is NOT possible to generate an updated_since CMR updated_since query from a GetRecords POST XML request with an invalid Modified date operand' do
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
                    <ogc:PropertyIsGreaterThanOrEqualTo>
                        <ogc:PropertyName>Modified</ogc:PropertyName>
                        <!-- literal value / operand missing -->
                    </ogc:PropertyIsGreaterThanOrEqualTo>
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
      helper = OgcFilterModified.new
      # no error, empty query
      cmr_query_params = helper.process(filter)
      expect(cmr_query_params).to be_empty
    end

    it 'is NOT possible to generate an updated_since CMR updated_since query from a GetRecords POST XML request without a Modified property' do
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
                    <ogc:PropertyIsGreaterThanOrEqualTo>
                        <!-- PropertyName missing -->
                        <ogc:Literal>2016-04-01</ogc:Literal>
                    </ogc:PropertyIsGreaterThanOrEqualTo>
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
      helper = OgcFilterModified.new
      # no error, empty query
      cmr_query_params = helper.process(filter)
      expect(cmr_query_params).to be_empty
    end

    it 'is NOT possible to generate an updated_since CMR query from a GetRecords POST XML request without an operator for the Modified property' do
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
              <!-- Operator PropertyIsGreaterThanOrEqualTo or PropertyIsGreaterThan missing -->
              <ogc:PropertyName>Modified</ogc:PropertyName>
              <ogc:Literal>2016-04-01</ogc:Literal>
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
      helper = OgcFilterModified.new
      begin
        cmr_query_params = helper.process(filter)
      rescue OwsException => e
        expect(e.text).to eq("OgcFilterModified.process_modified_date: invalid operator value Filter for Modified, supported values are [\"PropertyIsGreaterThanOrEqualTo\", \"PropertyIsGreaterThan\"]")
        expect(e.code).to eq('InvalidParameterValue')
        expect(e.locator).to eq('None')
      end
    end
  end
end
