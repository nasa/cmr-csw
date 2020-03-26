require "spec_helper"

RSpec.describe "various GetRecords POST requests containing the AnyText ISO queryable", :type => :request do

  it 'correctly renders FULL RESULTS ISO MENDS (GMI) data in response to a keyword ONLY constraint POST request' do
    VCR.use_cassette 'requests/get_records/gmi/keyword_records1_gmi_full', :decode_compressed_response => true, :record => :once do
      # notice the outputSchema below http://www.isotc211.org/2005/gmi, which is not the GCMD one http://www.isotc211.org/2005/gmd
      # TODO - revisit this once CMR supports ISO 19115 gmd
      keyword_only_constraint_get_records_request_xml = <<-eos
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
                        <ogc:Literal>MODIS</ogc:Literal>
                    </ogc:PropertyIsLike>
                </ogc:And>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', :params => keyword_only_constraint_get_records_request_xml
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be 10 records
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata', 'gmi' => 'http://www.isotc211.org/2005/gmi',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(10)
      # There should be a SearchStatus with a timestamp
      search_status_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchStatus', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_status_node_set.size).to eq(1) # expect(search_status_node_set[0]['timestamp']).to_not eq(nil)
      # There should be a SearchResults with numberOfRecordsMatched="7" numberOfRecordsReturned="7" elementSet="full" nextRecord="0"
      search_results_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_results_node_set.size).to eq(1)
      expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('1014')
      expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq('10')
      expect(search_results_node_set[0]['nextRecord']).to eq('11')
      expect(search_results_node_set[0]['elementSet']).to eq('full')
      expect(search_results_node_set[0]['recordSchema']).to eq('http://www.isotc211.org/2005/gmi')
    end
  end

  it 'correctly renders BRIEF RESULTS ISO MENDS (GMI) data in response to a keyword ONLY constraint POST request' do
    VCR.use_cassette 'requests/get_records/gmi/keyword_records2_gmi_brief', :decode_compressed_response => true, :record => :once do
      # notice the outputSchema below http://www.isotc211.org/2005/gmi, which is not the GCMD one http://www.isotc211.org/2005/gmd
      # TODO - revisit this once CMR supports ISO 19115 gmd
      keyword_only_constraint_get_records_request_xml = <<-eos
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
                        <ogc:Literal>MODIS</ogc:Literal>
                    </ogc:PropertyIsLike>
                </ogc:And>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', :params => keyword_only_constraint_get_records_request_xml
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be 10 records
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata', 'gmi' => 'http://www.isotc211.org/2005/gmi',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(10)
      # There should be a SearchStatus with a timestamp
      search_status_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchStatus', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_status_node_set.size).to eq(1) # expect(search_status_node_set[0]['timestamp']).to_not eq(nil)
      # There should be a SearchResults with numberOfRecordsMatched="7" numberOfRecordsReturned="7" elementSet="full" nextRecord="0"
      search_results_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_results_node_set.size).to eq(1)
      expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('1014')
      expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq('10')
      expect(search_results_node_set[0]['nextRecord']).to eq('11')
      expect(search_results_node_set[0]['elementSet']).to eq('brief')
      expect(search_results_node_set[0]['recordSchema']).to eq('http://www.isotc211.org/2005/gmi')
      # The brief records should have an id, scope and identification info
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata/gmd:fileIdentifier/gco:CharacterString',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'gmi' => 'http://www.isotc211.org/2005/gmi',
                                    'gmd' => 'http://www.isotc211.org/2005/gmd',
                                    'gco' => 'http://www.isotc211.org/2005/gco')[0].text).to eq('C1235314678-ORNL_DAAC')
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata/gmd:hierarchyLevel/gmd:MD_ScopeCode',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'gmi' => 'http://www.isotc211.org/2005/gmi',
                                    'gmd' => 'http://www.isotc211.org/2005/gmd')[0].text).to eq('series')
      first_purpose_element = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:purpose',
                                                     'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                                     'gmi' => 'http://www.isotc211.org/2005/gmi',
                                                     'gmd' => 'http://www.isotc211.org/2005/gmd',
      )[0]
      expect(first_purpose_element['gco:nilReason']).to eq('missing')
    end
  end

  it 'correctly renders BRIEF CSW RESULTS data in response to a keyword ONLY constraint POST request' do
    VCR.use_cassette 'requests/get_records/gmi/keyword_records4_csw_brief', :decode_compressed_response => true, :record => :once do
      # notice the outputSchema below http://www.isotc211.org/2005/gmi, which is not the GCMD one http://www.isotc211.org/2005/gmd
      # TODO - revisit this once CMR supports ISO 19115 gmd
      keyword_only_constraint_get_records_request_xml = <<-eos
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
                        <ogc:Literal>MODIS</ogc:Literal>
                    </ogc:PropertyIsLike>
                </ogc:And>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', :params => keyword_only_constraint_get_records_request_xml
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be 10 records
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:BriefRecord', 'gmi' => 'http://www.isotc211.org/2005/gmi',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(10)
      # There should be a SearchStatus with a timestamp
      search_status_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchStatus', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_status_node_set.size).to eq(1) # expect(search_status_node_set[0]['timestamp']).to_not eq(nil)
      # There should be a SearchResults with numberOfRecordsMatched="7" numberOfRecordsReturned="7" elementSet="full" nextRecord="0"
      search_results_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_results_node_set.size).to eq(1)
      expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('1014')
      expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq('10')
      expect(search_results_node_set[0]['nextRecord']).to eq('11')
      expect(search_results_node_set[0]['elementSet']).to eq('brief')
      expect(search_results_node_set[0]['recordSchema']).to eq('http://www.opengis.net/cat/csw/2.0.2')

      # The brief record should have an id, title, type and bounding box
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:BriefRecord/dc:identifier',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'dc' => 'http://purl.org/dc/elements/1.1/')[0].text).to eq('C1235314678-ORNL_DAAC')
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:BriefRecord/dc:title',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'dc' => 'http://purl.org/dc/elements/1.1/')[0].text).to eq("gov.nasa.echo:MODIS NDVI Data, Smoothed and Gap-filled, for the Conterminous US: 2000-2014")
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:BriefRecord/dc:type',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'dc' => 'http://purl.org/dc/elements/1.1/')[0].text).to eq('dataset')

      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:BriefRecord/ows:WGS84BoundingBox',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'ows' => 'http://www.opengis.net/ows').size).to eq(10)
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:BriefRecord/ows:WGS84BoundingBox/ows:LowerCorner',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'ows' => 'http://www.opengis.net/ows')[0].text).to eq('-129.89 20.85')
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:BriefRecord/ows:WGS84BoundingBox/ows:UpperCorner',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'ows' => 'http://www.opengis.net/ows')[0].text).to eq('-62.56 50.56')

    end
  end

  it 'correctly renders HITS data in response to NO resultType (defaulted to hits) and keyword ONLY constraint POST request' do
    VCR.use_cassette 'requests/get_records/gmi/keyword_hits_result_type', :decode_compressed_response => true, :record => :once do
      # notice the outputSchema below http://www.isotc211.org/2005/gmi, which is not the GCMD one http://www.isotc211.org/2005/gmd
      # TODO - revisit this once CMR supports ISO 19115 gmd
      keyword_only_constraint_get_records_request_xml = <<-eos
<csw:GetRecords maxRecords="10" outputFormat="application/xml"
    outputSchema="http://www.isotc211.org/2005/gmi" service="CSW"
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
                        <ogc:Literal>MODIS</ogc:Literal>
                    </ogc:PropertyIsLike>
                </ogc:And>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', :params => keyword_only_constraint_get_records_request_xml
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be a SearchStatus with a timestamp
      search_status_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchStatus', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_status_node_set.size).to eq(1) # expect(search_status_node_set[0]['timestamp']).to_not eq(nil)
      # There should be a SearchResults with numberOfRecordsMatched="7" numberOfRecordsReturned="7" elementSet="full" nextRecord="0"
      search_results_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_results_node_set.size).to eq(1)
      expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('1095')
      expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq('10')
      expect(search_results_node_set[0]['nextRecord']).to eq('11')
      expect(search_results_node_set[0]['elementSet']).to eq('brief')
      # The SearchResults in the HITS response should NOT HAVE any child nodes
      children = search_results_node_set.children
      expect(children.size).to eq 0
    end
  end

  it 'correctly renders HITS data in response to a resultType hits and keyword ONLY constraint POST request' do
    VCR.use_cassette 'requests/get_records/gmi/keyword_hits_result_type', :decode_compressed_response => true, :record => :once do
      # notice the outputSchema below http://www.isotc211.org/2005/gmi, which is not the GCMD one http://www.isotc211.org/2005/gmd
      # TODO - revisit this once CMR supports ISO 19115 gmd
      keyword_only_constraint_get_records_request_xml = <<-eos
<csw:GetRecords maxRecords="10" outputFormat="application/xml"
    outputSchema="http://www.isotc211.org/2005/gmi" resultType="hits" service="CSW"
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
                        <ogc:Literal>MODIS</ogc:Literal>
                    </ogc:PropertyIsLike>
                </ogc:And>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', :params => keyword_only_constraint_get_records_request_xml
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be a SearchStatus with a timestamp
      search_status_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchStatus', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_status_node_set.size).to eq(1) # expect(search_status_node_set[0]['timestamp']).to_not eq(nil)
      # There should be a SearchResults with numberOfRecordsMatched="7" numberOfRecordsReturned="7" elementSet="full" nextRecord="0"
      search_results_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_results_node_set.size).to eq(1)
      expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('1095')
      expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq('10')
      expect(search_results_node_set[0]['nextRecord']).to eq('11')
      expect(search_results_node_set[0]['elementSet']).to eq('brief')
      # The SearchResults in the HITS response should NOT HAVE any child nodes
      children = search_results_node_set.children
      expect(children.size).to eq 0
    end
  end
end

