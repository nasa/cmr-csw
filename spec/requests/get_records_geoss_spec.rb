require 'spec_helper'

RSpec.describe 'GetRecords CWIC functionality', :type => :request do

  it 'correctly adds a GEOSS keyword for full ISO GMI' do
    VCR.use_cassette 'requests/get_records/gmi/geoss_single', :decode_compressed_response => true, :record => :once do
      request_xml = <<-eos
<csw:GetRecords maxRecords="10" outputFormat="application/xml"
    outputSchema="http://www.isotc211.org/2005/gmi" resultType="results" service="CSW"
    startPosition="1" version="2.0.2" xmlns="http://www.opengis.net/cat/csw/2.0.2"
    xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
    <csw:Query typeNames="csw:Record">
        <csw:ElementSetName>full</csw:ElementSetName>
        <csw:Constraint version="1.1.0" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2">
            <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                <ogc:And>
                    <ogc:PropertyIsLike escapeChar="\\" singleChar="?" wildCard="*">
                        <ogc:PropertyName>AnyText</ogc:PropertyName>
                        <ogc:Literal>C1000000247-DEMO_PROV</ogc:Literal>
                    </ogc:PropertyIsLike>
                </ogc:And>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', request_xml
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'gmi' => 'http://www.isotc211.org/2005/gmi').size).to eq(1)
      # The full record should have a keyword of value 'geossDataCore'
      expect(records_xml.root.xpath("//gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString[text()='geossDataCore']", 'gmd' => 'http://www.isotc211.org/2005/gmd', 'gco' => 'http://www.isotc211.org/2005/gco').size).to eq(1)
      expect(records_xml.root.xpath("//gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString[text()='geossNoMonetaryCharge']", 'gmd' => 'http://www.isotc211.org/2005/gmd', 'gco' => 'http://www.isotc211.org/2005/gco').size).to eq(1)
      expect(records_xml.root.xpath("//gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString[text()='CWIC > CEOS WGISS Integrated Catalog']", 'gmd' => 'http://www.isotc211.org/2005/gmd', 'gco' => 'http://www.isotc211.org/2005/gco').size).to eq(0)

    end
  end

  it 'correctly adds a CWIC keyword for one full ISO GMI and not the other' do
    VCR.use_cassette 'requests/get_records/gmi/geoss_multiple', :decode_compressed_response => true, :record => :once do
      request_xml = <<-eos
  <csw:GetRecords maxRecords="10" outputFormat="application/xml"
      outputSchema="http://www.isotc211.org/2005/gmi" resultType="results" service="CSW"
      startPosition="1" version="2.0.2" xmlns="http://www.opengis.net/cat/csw/2.0.2"
      xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd"
      xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc"
      xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
      <csw:Query typeNames="csw:Record">
          <csw:ElementSetName>full</csw:ElementSetName>
          <csw:Constraint version="1.1.0" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2">
              <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                  <ogc:And>
                      <ogc:PropertyIsLike escapeChar="\\" singleChar="?" wildCard="*">
                          <ogc:PropertyName>AnyText</ogc:PropertyName>
                          <ogc:Literal>DEMO_PROV</ogc:Literal>
                      </ogc:PropertyIsLike>
                  </ogc:And>
              </ogc:Filter>
          </csw:Constraint>
      </csw:Query>
  </csw:GetRecords>
      eos
      post '/collections', request_xml
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'gmi' => 'http://www.isotc211.org/2005/gmi').size).to eq(2)
      # Only one record should have a keyword of value 'geossDataCore'
      expect(records_xml.root.xpath("//gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString[text()='geossDataCore']", 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'gmd' => 'http://www.isotc211.org/2005/gmd', 'gco' => 'http://www.isotc211.org/2005/gco').size).to eq(1)
      expect(records_xml.root.xpath("//gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString[text()='geossNoMonetaryCharge']", 'gmd' => 'http://www.isotc211.org/2005/gmd', 'gco' => 'http://www.isotc211.org/2005/gco').size).to eq(1)
    end
  end

  it 'correctly adds a CWIC keyword for full CSW' do
    VCR.use_cassette 'requests/get_records/gmi/geoss_single', :decode_compressed_response => true, :record => :once do
      request_xml = <<-eos
  <csw:GetRecords maxRecords="10" outputFormat="application/xml"
      outputSchema="http://www.opengis.net/cat/csw/2.0.2" resultType="results" service="CSW"
      startPosition="1" version="2.0.2" xmlns="http://www.opengis.net/cat/csw/2.0.2"
      xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd"
      xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc"
      xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
      <csw:Query typeNames="csw:Record">
          <csw:ElementSetName>full</csw:ElementSetName>
          <csw:Constraint version="1.1.0" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2">
              <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                  <ogc:And>
                      <ogc:PropertyIsLike escapeChar="\\" singleChar="?" wildCard="*">
                          <ogc:PropertyName>AnyText</ogc:PropertyName>
                          <ogc:Literal>C1000000247-DEMO_PROV</ogc:Literal>
                      </ogc:PropertyIsLike>
                  </ogc:And>
              </ogc:Filter>
          </csw:Constraint>
      </csw:Query>
  </csw:GetRecords>
      eos
      post '/collections', request_xml
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:Record', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
      # The full record should have a keyword of value 'geossDataCore'
      expect(records_xml.root.xpath("//dc:subject[text()='geossDataCore']", 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dc' => 'http://purl.org/dc/elements/1.1/').size).to eq(1)
      expect(records_xml.root.xpath("//dc:subject[text()='geossNoMonetaryCharge']", 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dc' => 'http://purl.org/dc/elements/1.1/').size).to eq(1)
    end
  end

  it 'correctly adds a CWIC keyword for one full CSW and not the other' do
    VCR.use_cassette 'requests/get_records/gmi/geoss_multiple', :decode_compressed_response => true, :record => :once do
      request_xml = <<-eos
    <csw:GetRecords maxRecords="10" outputFormat="application/xml"
        outputSchema="http://www.opengis.net/cat/csw/2.0.2" resultType="results" service="CSW"
        startPosition="1" version="2.0.2" xmlns="http://www.opengis.net/cat/csw/2.0.2"
        xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd"
        xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc"
        xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
        <csw:Query typeNames="csw:Record">
            <csw:ElementSetName>full</csw:ElementSetName>
            <csw:Constraint version="1.1.0" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2">
                <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                    <ogc:And>
                        <ogc:PropertyIsLike escapeChar="\\" singleChar="?" wildCard="*">
                            <ogc:PropertyName>AnyText</ogc:PropertyName>
                            <ogc:Literal>DEMO_PROV</ogc:Literal>
                        </ogc:PropertyIsLike>
                    </ogc:And>
                </ogc:Filter>
            </csw:Constraint>
        </csw:Query>
    </csw:GetRecords>
      eos
      post '/collections', request_xml
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:Record', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(2)
      # Only one record should have a keyword of value 'geossDataCore'
      expect(records_xml.root.xpath("//dc:subject[text()='geossDataCore']", 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dc' => 'http://purl.org/dc/elements/1.1/').size).to eq(1)
      expect(records_xml.root.xpath("//dc:subject[text()='geossNoMonetaryCharge']", 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dc' => 'http://purl.org/dc/elements/1.1/').size).to eq(1)
    end
  end

  it 'correctly adds a CWIC keyword for summary ISO GMI' do
    VCR.use_cassette 'requests/get_records/gmi/geoss_single', :decode_compressed_response => true, :record => :once do
      request_xml = <<-eos
  <csw:GetRecords maxRecords="10" outputFormat="application/xml"
      outputSchema="http://www.isotc211.org/2005/gmi" resultType="results" service="CSW"
      startPosition="1" version="2.0.2" xmlns="http://www.opengis.net/cat/csw/2.0.2"
      xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd"
      xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc"
      xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
      <csw:Query typeNames="csw:Record">
          <csw:ElementSetName>summary</csw:ElementSetName>
          <csw:Constraint version="1.1.0" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2">
              <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                  <ogc:And>
                      <ogc:PropertyIsLike escapeChar="\\" singleChar="?" wildCard="*">
                          <ogc:PropertyName>AnyText</ogc:PropertyName>
                          <ogc:Literal>C1000000247-DEMO_PROV</ogc:Literal>
                      </ogc:PropertyIsLike>
                  </ogc:And>
              </ogc:Filter>
          </csw:Constraint>
      </csw:Query>
  </csw:GetRecords>
      eos
      post '/collections', request_xml
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'gmi' => 'http://www.isotc211.org/2005/gmi').size).to eq(1)
      # The full record should have a keyword of value 'geossDataCore'
      expect(records_xml.root.xpath("//gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString[text()='geossDataCore']", 'gmd' => 'http://www.isotc211.org/2005/gmd', 'gco' => 'http://www.isotc211.org/2005/gco').size).to eq(1)
      expect(records_xml.root.xpath("//gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString[text()='geossNoMonetaryCharge']", 'gmd' => 'http://www.isotc211.org/2005/gmd', 'gco' => 'http://www.isotc211.org/2005/gco').size).to eq(1)
    end
  end

  it 'correctly adds a CWIC keyword for brief ISO GMI' do
    VCR.use_cassette 'requests/get_records/gmi/geoss_single', :decode_compressed_response => true, :record => :once do
      request_xml = <<-eos
  <csw:GetRecords maxRecords="10" outputFormat="application/xml"
      outputSchema="http://www.isotc211.org/2005/gmi" resultType="results" service="CSW"
      startPosition="1" version="2.0.2" xmlns="http://www.opengis.net/cat/csw/2.0.2"
      xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd"
      xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc"
      xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
      <csw:Query typeNames="csw:Record">
          <csw:ElementSetName>brief</csw:ElementSetName>
          <csw:Constraint version="1.1.0" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2">
              <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                  <ogc:And>
                      <ogc:PropertyIsLike escapeChar="\\" singleChar="?" wildCard="*">
                          <ogc:PropertyName>AnyText</ogc:PropertyName>
                          <ogc:Literal>C1000000247-DEMO_PROV</ogc:Literal>
                      </ogc:PropertyIsLike>
                  </ogc:And>
              </ogc:Filter>
          </csw:Constraint>
      </csw:Query>
  </csw:GetRecords>
      eos
      post '/collections', request_xml
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'gmi' => 'http://www.isotc211.org/2005/gmi').size).to eq(1)
      # The full record should have a keyword of value 'geossDataCore'
      expect(records_xml.root.xpath("//gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString[text()='geossDataCore']", 'gmd' => 'http://www.isotc211.org/2005/gmd', 'gco' => 'http://www.isotc211.org/2005/gco').size).to eq(1)
      expect(records_xml.root.xpath("//gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString[text()='geossNoMonetaryCharge']", 'gmd' => 'http://www.isotc211.org/2005/gmd', 'gco' => 'http://www.isotc211.org/2005/gco').size).to eq(1)
    end
  end

  it 'correctly adds a CWIC keyword for summary CSW' do
    VCR.use_cassette 'requests/get_records/gmi/geoss_single', :decode_compressed_response => true, :record => :once do
      request_xml = <<-eos
    <csw:GetRecords maxRecords="10" outputFormat="application/xml"
        outputSchema="http://www.opengis.net/cat/csw/2.0.2" resultType="results" service="CSW"
        startPosition="1" version="2.0.2" xmlns="http://www.opengis.net/cat/csw/2.0.2"
        xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd"
        xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc"
        xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
        <csw:Query typeNames="csw:Record">
            <csw:ElementSetName>summary</csw:ElementSetName>
            <csw:Constraint version="1.1.0" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2">
                <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                    <ogc:And>
                        <ogc:PropertyIsLike escapeChar="\\" singleChar="?" wildCard="*">
                            <ogc:PropertyName>AnyText</ogc:PropertyName>
                            <ogc:Literal>C1000000247-DEMO_PROV</ogc:Literal>
                        </ogc:PropertyIsLike>
                    </ogc:And>
                </ogc:Filter>
            </csw:Constraint>
        </csw:Query>
    </csw:GetRecords>
      eos
      post '/collections', request_xml
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:SummaryRecord', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
      # The full record should have a keyword of value 'geossDataCore'
      expect(records_xml.root.xpath("//dc:subject[text()='geossDataCore']", 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dc' => 'http://purl.org/dc/elements/1.1/').size).to eq(1)
      expect(records_xml.root.xpath("//dc:subject[text()='geossNoMonetaryCharge']", 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dc' => 'http://purl.org/dc/elements/1.1/').size).to eq(1)
    end
  end

  it 'correctly adds a CWIC keyword for brief CSW' do
    VCR.use_cassette 'requests/get_records/gmi/geoss_single', :decode_compressed_response => true, :record => :once do
      request_xml = <<-eos
    <csw:GetRecords maxRecords="10" outputFormat="application/xml"
        outputSchema="http://www.opengis.net/cat/csw/2.0.2" resultType="results" service="CSW"
        startPosition="1" version="2.0.2" xmlns="http://www.opengis.net/cat/csw/2.0.2"
        xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd"
        xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc"
        xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
        <csw:Query typeNames="csw:Record">
            <csw:ElementSetName>brief</csw:ElementSetName>
            <csw:Constraint version="1.1.0" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2">
                <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                    <ogc:And>
                        <ogc:PropertyIsLike escapeChar="\\" singleChar="?" wildCard="*">
                            <ogc:PropertyName>AnyText</ogc:PropertyName>
                            <ogc:Literal>C1000000247-DEMO_PROV</ogc:Literal>
                        </ogc:PropertyIsLike>
                    </ogc:And>
                </ogc:Filter>
            </csw:Constraint>
        </csw:Query>
    </csw:GetRecords>
      eos
      post '/collections', request_xml
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:BriefRecord', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
      # The brief record should have a keyword of value 'geossDataCore'
      expect(records_xml.root.xpath("//dc:subject[text()='geossDataCore']", 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dc' => 'http://purl.org/dc/elements/1.1/').size).to eq(0)
      expect(records_xml.root.xpath("//dc:subject[text()='geossNoMonetaryCharge']", 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dc' => 'http://purl.org/dc/elements/1.1/').size).to eq(0)
    end
  end

  it 'correctly adds a CWIC keyword for brief CSW' do
      VCR.use_cassette 'requests/get_records/gmi/geoss_cwic_combi', :decode_compressed_response => true, :record => :once do
        request_xml = <<-eos
      <csw:GetRecords maxRecords="10" outputFormat="application/xml"
          outputSchema="http://www.opengis.net/cat/csw/2.0.2" resultType="results" service="CSW"
          startPosition="1" version="2.0.2" xmlns="http://www.opengis.net/cat/csw/2.0.2"
          xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd"
          xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc"
          xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
          <csw:Query typeNames="csw:Record">
              <csw:ElementSetName>brief</csw:ElementSetName>
              <csw:Constraint version="1.1.0" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2">
                  <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                      <ogc:And>
                          <ogc:PropertyIsLike escapeChar="\\" singleChar="?" wildCard="*">
                              <ogc:PropertyName>AnyText</ogc:PropertyName>
                              <ogc:Literal>C1000000247-DEMO_PROV</ogc:Literal>
                          </ogc:PropertyIsLike>
                      </ogc:And>
                  </ogc:Filter>
              </csw:Constraint>
          </csw:Query>
      </csw:GetRecords>
        eos
        post '/collections', request_xml
        expect(response).to have_http_status(:success)
        expect(response).to render_template('get_records/index.xml.erb')
        records_xml = Nokogiri::XML(response.body)
        expect(records_xml.root.name).to eq 'GetRecordsResponse'
        expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:BriefRecord', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
        # The brief record should have a keyword of value 'geossDataCore'
        expect(records_xml.root.xpath("//dc:subject[text()='geossDataCore']", 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dc' => 'http://purl.org/dc/elements/1.1/').size).to eq(0)
        expect(records_xml.root.xpath("//dc:subject[text()='geossNoMonetaryCharge']", 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dc' => 'http://purl.org/dc/elements/1.1/').size).to eq(0)
        expect(records_xml.root.xpath("//dc:subject[text()='CWIC > CEOS WGISS Integrated Catalog']", 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dc' => 'http://purl.org/dc/elements/1.1/').size).to eq(0)
      end
    end

end

