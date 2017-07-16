require 'spec_helper'

RSpec.describe OgcFilterScienceKeywords do

  it 'is possible to extract the ScienceKeyword element and DEFAULT wildcard (*) and value from a GetRecords POST XML request' do
    constraint_get_records_request_xml = <<-eos
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
                    <ogc:PropertyIsLike escapeChar="\\" singleChar="?" wildCard="*">
                        <ogc:PropertyName>ScienceKeywords</ogc:PropertyName>
                        <ogc:Literal>*EARTH SCIENCE*</ogc:Literal>
                    </ogc:PropertyIsLike>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
    eos
    request_body_xml = Nokogiri::XML(constraint_get_records_request_xml)
    filter = request_body_xml.at_xpath("//csw:GetRecords//csw:Query//csw:Constraint//ogc:Filter",
                                       'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                       'ogc' => 'http://www.opengis.net/ogc')
    expect(filter).not_to eq nil
    helper = OgcFilterScienceKeywords.new
    cmr_query_params = helper.process(filter)
    expect(cmr_query_params['science_keywords[0][any]']).to eq('*EARTH SCIENCE*')
    expect(cmr_query_params['options[science_keywords][pattern]']).to eq(true)
  end

  it 'is possible to extract the Science element and NON-DEFAULT wildcard and value from a GetRecords POST XML request' do
    constraint_get_records_request_xml = <<-eos
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
                <ogc:And>
                    <ogc:PropertyIsLike escapeChar="\\" singleChar="?" wildCard="^">
                        <ogc:PropertyName>ScienceKeywords</ogc:PropertyName>
                        <ogc:Literal>^EARTH SCIENCE^</ogc:Literal>
                    </ogc:PropertyIsLike>
                </ogc:And>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
    eos
    request_body_xml = Nokogiri::XML(constraint_get_records_request_xml)
    filter = request_body_xml.at_xpath("//csw:GetRecords//csw:Query//csw:Constraint//ogc:Filter",
                                       'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                       'ogc' => 'http://www.opengis.net/ogc')
    expect(filter).not_to eq nil
    helper = OgcFilterScienceKeywords.new
    cmr_query_params = helper.process(filter)
    # the CMR wildcard character is '*'
    expect(cmr_query_params['science_keywords[0][any]']).to eq('*EARTH SCIENCE*')
    expect(cmr_query_params['options[science_keywords][pattern]']).to eq(true)
  end

  it 'is possible to extract the ScienceKeywords element (without wildcard) and value from a GetRecords POST XML request' do
    constraint_get_records_request_xml = <<-eos
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
                <ogc:And>
                    <ogc:PropertyIsLike escapeChar="\\" singleChar="?" wildCard="^">
                        <ogc:PropertyName>ScienceKeywords</ogc:PropertyName>
                        <ogc:Literal>EARTH SCIENCE</ogc:Literal>
                    </ogc:PropertyIsLike>
                </ogc:And>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
    eos
    request_body_xml = Nokogiri::XML(constraint_get_records_request_xml)
    filter = request_body_xml.at_xpath("//csw:GetRecords//csw:Query//csw:Constraint//ogc:Filter",
                                       'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                       'ogc' => 'http://www.opengis.net/ogc')
    expect(filter).not_to eq nil
    helper = OgcFilterScienceKeywords.new
    cmr_query_params = helper.process(filter)
    expect(cmr_query_params['science_keywords[0][any]']).to eq('EARTH SCIENCE')
    # no pattern was used in the filter
    expect(cmr_query_params['options[science_keywords][pattern]']).to eq(nil)
  end

end
