require "spec_helper"

RSpec.describe "various GetRecords POST requests based on the Title ISO queryable", :type => :request do

  it 'correctly renders FULL RESULTS ISO MENDS (GMI) data in response to a Title ONLY constraint POST request' do
    VCR.use_cassette 'requests/get_records/gmi/title_records1_gmi_full', :decode_compressed_response => true, :record => :once do
      # notice the outputSchema below http://www.isotc211.org/2005/gmi, which is not the GCMD one http://www.isotc211.org/2005/gmd
      # TODO - revisit this once CMR supports ISO 19115 gmd
      bbox_constraint_get_records_request_xml = <<-eos
<?xml version="1.0"?>
<csw:GetRecords xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" resultType="results"
    xmlns:gmd="http://www.isotc211.org/2005/gmi" service="CSW" version="2.0.2">
    <csw:Query typeNames="csw:Record">
        <csw:ElementSetName>full</csw:ElementSetName>
        <csw:Constraint version="1.1.0">
            <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                    <ogc:PropertyIsLike escapeChar="\\" singleChar="?" wildCard="*">
                        <ogc:PropertyName>Title</ogc:PropertyName>
                        <ogc:Literal>*MODIS*</ogc:Literal>
                    </ogc:PropertyIsLike>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', :params => bbox_constraint_get_records_request_xml
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
      search_results_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_results_node_set.size).to eq(1)
      expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('775')
      expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq('10')
      expect(search_results_node_set[0]['nextRecord']).to eq('11')
      expect(search_results_node_set[0]['elementSet']).to eq('full')
      expect(search_results_node_set[0]['recordSchema']).to eq('http://www.isotc211.org/2005/gmi')
    end
  end

  it 'correctly renders BRIEF RESULTS ISO MENDS (GMI) data in response to a Title ONLY constraint POST request' do
    VCR.use_cassette 'requests/get_records/gmi/title_records2_gmi_brief', :decode_compressed_response => true, :record => :once do
      # notice the outputSchema below http://www.isotc211.org/2005/gmi, which is not the GCMD one http://www.isotc211.org/2005/gmd
      # TODO - revisit this once CMR supports ISO 19115 gmd
      bbox_only_constraint_get_records_request_xml = <<-eos
<csw:GetRecords xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" resultType="results"
    xmlns:gmd="http://www.isotc211.org/2005/gmi" service="CSW" version="2.0.2">
    <csw:Query typeNames="csw:Record">
        <csw:ElementSetName>brief</csw:ElementSetName>
        <csw:Constraint version="1.1.0">
            <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                    <ogc:PropertyIsLike escapeChar="\\" singleChar="?" wildCard="*">
                        <ogc:PropertyName>Title</ogc:PropertyName>
                        <ogc:Literal>*MODIS*</ogc:Literal>
                    </ogc:PropertyIsLike>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', :params => bbox_only_constraint_get_records_request_xml
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
      search_results_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_results_node_set.size).to eq(1)
      expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('775')
      expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq('10')
      expect(search_results_node_set[0]['nextRecord']).to eq('11')
      expect(search_results_node_set[0]['elementSet']).to eq('brief')
      expect(search_results_node_set[0]['recordSchema']).to eq('http://www.isotc211.org/2005/gmi')
      # The brief records should have an id, scope and identification info
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata/gmd:fileIdentifier/gco:CharacterString',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'gmi' => 'http://www.isotc211.org/2005/gmi',
                                    'gmd' => 'http://www.isotc211.org/2005/gmd',
                                    'gco' => 'http://www.isotc211.org/2005/gco')[0].text).to eq("C1224520058-NOAA_NCEI")
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata/gmd:hierarchyLevel/gmd:MD_ScopeCode',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'gmi' => 'http://www.isotc211.org/2005/gmi',
                                    'gmd' => 'http://www.isotc211.org/2005/gmd')[0].text).to eq('series')
      first_purpose_element = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:purpose/gco:CharacterString',
                                                     'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                                     'gmi' => 'http://www.isotc211.org/2005/gmi',
                                                     'gmd' => 'http://www.isotc211.org/2005/gmd',
                                                     'gco' => 'http://www.isotc211.org/2005/gco'
      )[0]
      expect(first_purpose_element.text).to eq('To serve a wide user community by providing albedo data for the continent of Africa that can be used to predict soil properties as well as for a range of other applications, including erosion and landslide risk.')
    end
  end

  it 'correctly renders BRIEF CSW RESULTS data in response to a Title ONLY constraint POST request' do
    VCR.use_cassette 'requests/get_records/gmi/title_records4_csw_brief', :decode_compressed_response => true, :record => :once do
      # notice the outputSchema below http://www.isotc211.org/2005/gmi, which is not the GCMD one http://www.isotc211.org/2005/gmd
      # TODO - revisit this once CMR supports ISO 19115 gmd
      bbox_only_constraint_get_records_request_xml = <<-eos
<csw:GetRecords maxRecords="10" outputFormat="application/xml"
    outputSchema="http://www.opengis.net/cat/csw/2.0.2" resultType="results" service="CSW"
    startPosition="1" version="2.0.2" xmlns="http://www.opengis.net/cat/csw/2.0.2"
    xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
    <csw:Query typeNames="csw:Record">
        <csw:ElementSetName>brief</csw:ElementSetName>
         <csw:Constraint version="1.1.0">
            <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                    <ogc:PropertyIsLike escapeChar="\\" singleChar="?" wildCard="*">
                        <ogc:PropertyName>Title</ogc:PropertyName>
                        <ogc:Literal>*MODIS*</ogc:Literal>
                    </ogc:PropertyIsLike>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', :params => bbox_only_constraint_get_records_request_xml
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
      search_results_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_results_node_set.size).to eq(1)
      expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('775')
      expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq('10')
      expect(search_results_node_set[0]['nextRecord']).to eq('11')
      expect(search_results_node_set[0]['elementSet']).to eq('brief')
      expect(search_results_node_set[0]['recordSchema']).to eq('http://www.opengis.net/cat/csw/2.0.2')

      # The brief record should have an id, title, type and bounding box
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:BriefRecord/dc:identifier',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'dc' => 'http://purl.org/dc/elements/1.1/')[0].text).to eq('C1224520058-NOAA_NCEI')
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:BriefRecord/dc:title',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'dc' => 'http://purl.org/dc/elements/1.1/')[0].text).to eq("\nGHRSST Level 2P Global Skin Sea Surface Temperature from the Moderate Resolution Imaging Spectroradiometer (MODIS) on the NASA Aqua satellite\n")
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:BriefRecord/dc:type',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'dc' => 'http://purl.org/dc/elements/1.1/')[0].text).to eq('dataset')

      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:BriefRecord/ows:WGS84BoundingBox',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'ows' => 'http://www.opengis.net/ows').size).to eq(10)
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:BriefRecord/ows:WGS84BoundingBox/ows:LowerCorner',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'ows' => 'http://www.opengis.net/ows')[0].text).to eq('-180.0 -90.0')
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:BriefRecord/ows:WGS84BoundingBox/ows:UpperCorner',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'ows' => 'http://www.opengis.net/ows')[0].text).to eq('180.0 90.0')
    end
  end

  it 'correctly renders FULL RESULTS ISO MENDS (GMI) data in response to a AOI_TOI_AnyText_Title constraint POST request' do
    VCR.use_cassette 'requests/get_records/gmi/aoi_toi_anytext_title_records1_gmi_full', :decode_compressed_response => true, :record => :once do
      # notice the outputSchema below http://www.isotc211.org/2005/gmi, which is not the GCMD one http://www.isotc211.org/2005/gmd
      # TODO - revisit this once CMR supports ISO 19115 gmd
      bbox_only_constraint_get_records_request_xml = <<-eos
<csw:GetRecords maxRecords="10" outputFormat="application/xml"
    outputSchema="http://www.isotc211.org/2005/gmi" resultType="results" service="CSW"
    startPosition="1" version="2.0.2" xmlns="http://www.opengis.net/cat/csw/2.0.2"
    xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
    <csw:Query typeNames="csw:Record">
        <csw:ElementSetName>full</csw:ElementSetName>
         <csw:Constraint version="1.1.0">
            <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                <ogc:And>
                    <ogc:PropertyIsGreaterThanOrEqualTo>
                        <ogc:PropertyName>TempExtent_begin</ogc:PropertyName>
                        <ogc:Literal>1990-09-03T00:00:01Z</ogc:Literal>
                    </ogc:PropertyIsGreaterThanOrEqualTo>
                    <ogc:PropertyIsLessThanOrEqualTo>
                        <ogc:PropertyName>TempExtent_end</ogc:PropertyName>
                        <ogc:Literal>2008-09-06T23:59:59Z</ogc:Literal>
                    </ogc:PropertyIsLessThanOrEqualTo>
                    <ogc:BBOX>
                        <ogc:PropertyName>iso:BoundingBox</ogc:PropertyName>
                        <gml:Envelope xmlns:gml="http://www.opengis.net/gml">
                            <gml:lowerCorner>-180 -90</gml:lowerCorner>
                            <gml:upperCorner>180 90</gml:upperCorner>
                        </gml:Envelope>
                    </ogc:BBOX>
                    <ogc:PropertyIsLike escapeChar="\\" singleChar="?" wildCard="*">
                        <ogc:PropertyName>Title</ogc:PropertyName>
                        <ogc:Literal>*MODIS*</ogc:Literal>
                    </ogc:PropertyIsLike>
                </ogc:And>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', :params => bbox_only_constraint_get_records_request_xml
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
      search_results_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_results_node_set.size).to eq(1)
      expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('672')
      expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq('10')
      expect(search_results_node_set[0]['nextRecord']).to eq('11')
      expect(search_results_node_set[0]['elementSet']).to eq('full')
      expect(search_results_node_set[0]['recordSchema']).to eq('http://www.isotc211.org/2005/gmi')
    end
  end

  it 'correctly renders HITS data in response to a Title ONLY constraint and resultType HITS POST request' do
    VCR.use_cassette 'requests/get_records/gmi/title_hits', :decode_compressed_response => true, :record => :once do
      # notice the outputSchema below http://www.isotc211.org/2005/gmi, which is not the GCMD one http://www.isotc211.org/2005/gmd
      # TODO - revisit this once CMR supports ISO 19115 gmd
      title_only_constraint_get_records_request_xml = <<-eos
<csw:GetRecords maxRecords="10" outputFormat="application/xml"
    outputSchema="http://www.isotc211.org/2005/gmi" resultType="hits" service="CSW"
    startPosition="1" version="2.0.2" xmlns="http://www.opengis.net/cat/csw/2.0.2"
    xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
    <csw:Query typeNames="csw:Record">
        <csw:ElementSetName>full</csw:ElementSetName>
         <csw:Constraint version="1.1.0">
            <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                    <ogc:PropertyIsLike escapeChar="\\" singleChar="?" wildCard="*">
                        <ogc:PropertyName>Title</ogc:PropertyName>
                        <ogc:Literal>*MODIS*</ogc:Literal>
                    </ogc:PropertyIsLike>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', :params => title_only_constraint_get_records_request_xml
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be a SearchStatus with a timestamp
      search_status_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchStatus', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_status_node_set.size).to eq(1) # expect(search_status_node_set[0]['timestamp']).to_not eq(nil)
      search_results_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_results_node_set.size).to eq(1)
      expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('855')
      expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq('10')
      expect(search_results_node_set[0]['nextRecord']).to eq('11')
      expect(search_results_node_set[0]['elementSet']).to eq('full')
      # The SearchResults in the HITS response should NOT HAVE any child nodes
      children = search_results_node_set.children
      expect(children.size).to eq 0
    end
  end

  it 'correctly renders HITS data (default) in response to a Title ONLY constraint and NO resultType POST request' do
    VCR.use_cassette 'requests/get_records/gmi/title_hits', :decode_compressed_response => true, :record => :once do
      # notice the outputSchema below http://www.isotc211.org/2005/gmi, which is not the GCMD one http://www.isotc211.org/2005/gmd
      # TODO - revisit this once CMR supports ISO 19115 gmd
      title_only_constraint_get_records_request_xml = <<-eos
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
                    <ogc:PropertyIsLike escapeChar="\\" singleChar="?" wildCard="*">
                        <ogc:PropertyName>Title</ogc:PropertyName>
                        <ogc:Literal>*MODIS*</ogc:Literal>
                    </ogc:PropertyIsLike>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', :params => title_only_constraint_get_records_request_xml
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be a SearchStatus with a timestamp
      search_status_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchStatus', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_status_node_set.size).to eq(1) # expect(search_status_node_set[0]['timestamp']).to_not eq(nil)
      search_results_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_results_node_set.size).to eq(1)
      expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('855')
      expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq('10')
      expect(search_results_node_set[0]['nextRecord']).to eq('11')
      expect(search_results_node_set[0]['elementSet']).to eq('full')
      # The SearchResults in the HITS response should NOT HAVE any child nodes
      children = search_results_node_set.children
      expect(children.size).to eq 0
    end
  end
end