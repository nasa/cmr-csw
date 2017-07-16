require 'spec_helper'

RSpec.describe "various GetRecords POST requests based on the ScienceKeywords queryable", :type => :request do
  it 'correctly renders FULL RESULTS ISO MENDS (GMI) data in response to a ScienceKeywords ONLY constraint POST request' do
    VCR.use_cassette 'requests/get_records/gmi/science_keywords_records1_gmi_full', :decode_compressed_response => true, :record => :once do
      # notice the outputSchema below http://www.isotc211.org/2005/gmi, which is not the GCMD one http://www.isotc211.org/2005/gmd
      # TODO - revisit this once CMR supports ISO 19115 gmd
      constraint_get_records_request_xml = <<-eos
<?xml version="1.0"?>
<csw:GetRecords xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" resultType="results"
    xmlns:gmd="http://www.isotc211.org/2005/gmi" service="CSW" version="2.0.2">
    <csw:Query typeNames="csw:Record">
        <csw:ElementSetName>full</csw:ElementSetName>
        <csw:Constraint version="1.1.0">
            <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                    <ogc:PropertyIsLike escapeChar="\\" singleChar="?" wildCard="*">
                        <ogc:PropertyName>ScienceKeywords</ogc:PropertyName>
                        <ogc:Literal>EARTH SCIENCE</ogc:Literal>
                    </ogc:PropertyIsLike>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', constraint_get_records_request_xml
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
      expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('31071')
      expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq('10')
      expect(search_results_node_set[0]['nextRecord']).to eq('11')
      expect(search_results_node_set[0]['elementSet']).to eq('full')
      expect(search_results_node_set[0]['recordSchema']).to eq('http://www.isotc211.org/2005/gmi')
    end
  end

  it 'correctly renders BRIEF RESULTS ISO MENDS (GMI) data in response to a ScienceKeyword ONLY constraint POST request' do
    VCR.use_cassette 'requests/get_records/gmi/science_keywords_records1_gmi_full', :decode_compressed_response => true, :record => :once do
      # notice the outputSchema below http://www.isotc211.org/2005/gmi, which is not the GCMD one http://www.isotc211.org/2005/gmd
      # TODO - revisit this once CMR supports ISO 19115 gmd
      constraint_get_records_request_xml = <<-eos
<csw:GetRecords xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" resultType="results"
    xmlns:gmd="http://www.isotc211.org/2005/gmi" service="CSW" version="2.0.2">
    <csw:Query typeNames="csw:Record">
        <csw:ElementSetName>brief</csw:ElementSetName>
        <csw:Constraint version="1.1.0">
            <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                    <ogc:PropertyIsLike escapeChar="\\" singleChar="?" wildCard="*">
                        <ogc:PropertyName>ScienceKeywords</ogc:PropertyName>
                        <ogc:Literal>EARTH SCIENCE</ogc:Literal>
                    </ogc:PropertyIsLike>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', constraint_get_records_request_xml
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
      expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('31071')
      expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq('10')
      expect(search_results_node_set[0]['nextRecord']).to eq('11')
      expect(search_results_node_set[0]['elementSet']).to eq('brief')
      expect(search_results_node_set[0]['recordSchema']).to eq('http://www.isotc211.org/2005/gmi')
      # The brief records should have an id, scope and identification info
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata/gmd:fileIdentifier/gco:CharacterString',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'gmi' => 'http://www.isotc211.org/2005/gmi',
                                    'gmd' => 'http://www.isotc211.org/2005/gmd',
                                    'gco' => 'http://www.isotc211.org/2005/gco')[0].text).to eq("C1224520098-NOAA_NCEI")
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata/gmd:hierarchyLevel/gmd:MD_ScopeCode',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'gmi' => 'http://www.isotc211.org/2005/gmi',
                                    'gmd' => 'http://www.isotc211.org/2005/gmd')[0].text).to eq('series')
      first_purpose_element = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:purpose',
                                                     'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                                     'gmi' => 'http://www.isotc211.org/2005/gmi',
                                                     'gmd' => 'http://www.isotc211.org/2005/gmd',
                                                     'gco' => 'http://www.isotc211.org/2005/gco'
      )[0]
      expect(first_purpose_element['gco:nilReason']).to eq(nil)
    end
  end

  it 'correctly renders FULL CSW RESULTS data in response to a ScienceKeywords ONLY constraint POST request' do
    VCR.use_cassette 'requests/get_records/gmi/science_keywords_records1_gmi_full', :decode_compressed_response => true, :record => :once do
      # notice the outputSchema below http://www.isotc211.org/2005/gmi, which is not the GCMD one http://www.isotc211.org/2005/gmd
      # TODO - revisit this once CMR supports ISO 19115 gmd
      constraint_get_records_request_xml = <<-eos
<csw:GetRecords xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" resultType="results"
    xmlns:gmd="http://www.isotc211.org/2005/gmi" service="CSW" version="2.0.2" outputSchema="http://www.opengis.net/cat/csw/2.0.2">
    <csw:Query typeNames="csw:Record">
        <csw:ElementSetName>full</csw:ElementSetName>
        <csw:Constraint version="1.1.0">
            <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                    <ogc:PropertyIsLike escapeChar="\\" singleChar="?" wildCard="*">
                        <ogc:PropertyName>ScienceKeywords</ogc:PropertyName>
                        <ogc:Literal>EARTH SCIENCE</ogc:Literal>
                    </ogc:PropertyIsLike>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', constraint_get_records_request_xml
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      # There should be 10 records
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:Record', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(10)
      # There should be a SearchStatus with a timestamp
      search_status_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchStatus', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_status_node_set.size).to eq(1) # expect(search_status_node_set[0]['timestamp']).to_not eq(nil)
      search_results_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_results_node_set.size).to eq(1)
      expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('31071')
      expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq('10')
      expect(search_results_node_set[0]['nextRecord']).to eq('11')
      expect(search_results_node_set[0]['elementSet']).to eq('full')
      expect(search_results_node_set[0]['recordSchema']).to eq('http://www.opengis.net/cat/csw/2.0.2')
      # The brief records should have an id, scope and identification info
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:Record/dc:identifier',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'dc' => 'http://purl.org/dc/elements/1.1/'
      )[0].text).to eq("C1224520098-NOAA_NCEI")
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:Record/dc:title',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'dc' => 'http://purl.org/dc/elements/1.1/'
      )[0].text).to include('GHRSST Level 2P Central Pacific Regional Skin Sea Surface Temperature from the Geostationary')
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:Record/dc:type',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'dc' => 'http://purl.org/dc/elements/1.1/'
      )[0].text).to eq('dataset')
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:Record/ows:WGS84BoundingBox/ows:LowerCorner',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'ows' => 'http://www.opengis.net/ows'
      )[0].text).to eq('146.0 -44.0')
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:Record/ows:WGS84BoundingBox/ows:UpperCorner',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'ows' => 'http://www.opengis.net/ows'
      )[0].text).to eq('-105.0 72.0')
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:Record/dc:subject',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'dc' => 'http://purl.org/dc/elements/1.1/'
      )[0].text).to eq('EARTH SCIENCE>OCEANS>OCEAN TEMPERATURE>WATER TEMPERATURE>NONE>NONE>NONE')
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:Record/dct:modified',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'dct' => 'http://purl.org/dc/terms/'
      )[0].text).to eq('2015-02-18T00:00:00.000Z')
      expect(records_xml.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:Record/dc:title',
                               'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                               'dc' => 'http://purl.org/dc/elements/1.1/'
      )[0].text).to include('GHRSST Level 2P Central Pacific Regional')
      expect(records_xml.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:Record/dc:source',
                               'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                               'dc' => 'http://purl.org/dc/elements/1.1/'
      )[0].text).to eq('GHRSST')
      expect(records_xml.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:Record/dct:references',
                               'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                               'dct' => 'http://purl.org/dc/terms/'
      )[0].text).to include('http://data.nodc.noaa.gov/thredds/catalog/ghrsst/L2P/GOES15/OSPO/')
      expect(records_xml.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:Record/dc:language',
                               'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                               'dc' => 'http://purl.org/dc/elements/1.1/'
      )[0].text).to eq('')
    end
  end

  it 'correctly renders BRIEF CSW RESULTS data in response to a ScienceKeywords ONLY constraint POST request' do
    VCR.use_cassette 'requests/get_records/gmi/science_keywords_records1_gmi_full', :decode_compressed_response => true, :record => :once do
      # notice the outputSchema below http://www.isotc211.org/2005/gmi, which is not the GCMD one http://www.isotc211.org/2005/gmd
      # TODO - revisit this once CMR supports ISO 19115 gmd
      constraint_get_records_request_xml = <<-eos
<csw:GetRecords xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" resultType="results"
    xmlns:gmd="http://www.isotc211.org/2005/gmi" service="CSW" version="2.0.2" outputSchema="http://www.opengis.net/cat/csw/2.0.2">
    <csw:Query typeNames="csw:Record">
        <csw:ElementSetName>brief</csw:ElementSetName>
        <csw:Constraint version="1.1.0">
            <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                    <ogc:PropertyIsLike escapeChar="\\" singleChar="?" wildCard="*">
                        <ogc:PropertyName>ScienceKeywords</ogc:PropertyName>
                        <ogc:Literal>EARTH SCIENCE</ogc:Literal>
                    </ogc:PropertyIsLike>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', constraint_get_records_request_xml
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
      expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('31071')
      expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq('10')
      expect(search_results_node_set[0]['nextRecord']).to eq('11')
      expect(search_results_node_set[0]['elementSet']).to eq('brief')
      expect(search_results_node_set[0]['recordSchema']).to eq('http://www.opengis.net/cat/csw/2.0.2')

      # The brief record should have an id, title, type and bounding box
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:BriefRecord/dc:identifier',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'dc' => 'http://purl.org/dc/elements/1.1/')[0].text).to eq('C1224520098-NOAA_NCEI')
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:BriefRecord/dc:title',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'dc' => 'http://purl.org/dc/elements/1.1/')[0].text).to include("GHRSST Level 2P Central Pacific Regional Skin Sea Surface Temperature")
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:BriefRecord/dc:type',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'dc' => 'http://purl.org/dc/elements/1.1/')[0].text).to eq('dataset')

      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:BriefRecord/ows:WGS84BoundingBox',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'ows' => 'http://www.opengis.net/ows').size).to eq(10)
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:BriefRecord/ows:WGS84BoundingBox/ows:LowerCorner',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'ows' => 'http://www.opengis.net/ows')[0].text).to eq('146.0 -44.0')
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:BriefRecord/ows:WGS84BoundingBox/ows:UpperCorner',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'ows' => 'http://www.opengis.net/ows')[0].text).to eq('-105.0 72.0')
    end
  end

  it 'correctly renders FULL RESULTS ISO MENDS (GMI) data in response to a AOI_TOI_AnyText_Title_Platform_ScienceKeywords constraint POST request' do
    VCR.use_cassette 'requests/get_records/gmi/science_keywords_others_records1_gmi_full', :decode_compressed_response => true, :record => :once do
      # notice the outputSchema below http://www.isotc211.org/2005/gmi, which is not the GCMD one http://www.isotc211.org/2005/gmd
      # TODO - revisit this once CMR supports ISO 19115 gmd
      combined_constraint_get_records_request_xml = <<-eos
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
                    <ogc:PropertyIsLike escapeChar="\\" singleChar="?" wildCard="*">
                        <ogc:PropertyName>Platform</ogc:PropertyName>
                        <ogc:Literal>*AQUA*</ogc:Literal>
                    </ogc:PropertyIsLike>
                   <ogc:PropertyIsLike escapeChar="\\" singleChar="?" wildCard="*">
                        <ogc:PropertyName>ScienceKeywords</ogc:PropertyName>
                        <ogc:Literal>EARTH SCIENCE</ogc:Literal>
                    </ogc:PropertyIsLike>
                </ogc:And>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', combined_constraint_get_records_request_xml
      # Generated CMR query is:
      # https://cmr.earthdata.nasa.gov/search/collections?bounding_box=-180,-90,180,90&entry_title=*MODIS*&
      # options[entry_title][pattern]=true&
      # options[platform][pattern]=true&
      # options[science_keywords][or]=true
      # &platform=*AQUA*&science_keywords[0][category]=EARTH SCIENCE&science_keywords[1][topic]=EARTH SCIENCE&
      # science_keywords[2][term]=EARTH SCIENCE&science_keywords[3][variable_level_1]=EARTH SCIENCE&
      # science_keywords[4][variable_level_2]=EARTH SCIENCE&science_keywords[5][variable_level_3]=EARTH SCIENCE&
      # temporal[]=1990-09-03T00:00:01Z/2008-09-06T23:59:59Z
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
      expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('357')
      expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq('10')
      expect(search_results_node_set[0]['nextRecord']).to eq('11')
      expect(search_results_node_set[0]['elementSet']).to eq('full')
      expect(search_results_node_set[0]['recordSchema']).to eq('http://www.isotc211.org/2005/gmi')
    end
  end

  it 'correctly renders SUMMARY RESULTS ISO MENDS data in response to a ScienceKeywords ONLY constraint POST request' do
    VCR.use_cassette 'requests/get_records/gmi/science_keywords_records1_gmi_full', :decode_compressed_response => true, :record => :once do
      # notice the outputSchema below http://www.isotc211.org/2005/gmi, which is not the GCMD one http://www.isotc211.org/2005/gmd
      # TODO - revisit this once CMR supports ISO 19115 gmd
      constraint_get_records_request_xml = <<-eos
<csw:GetRecords xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" resultType="results"
    xmlns:gmd="http://www.isotc211.org/2005/gmi" service="CSW" version="2.0.2">
    <csw:Query typeNames="csw:Record">
        <csw:ElementSetName>summary</csw:ElementSetName>
        <csw:Constraint version="1.1.0">
            <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                    <ogc:PropertyIsLike escapeChar="\\" singleChar="?" wildCard="*">
                        <ogc:PropertyName>ScienceKeywords</ogc:PropertyName>
                        <ogc:Literal>EARTH SCIENCE</ogc:Literal>
                    </ogc:PropertyIsLike>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', constraint_get_records_request_xml
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
      expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('31071')
      expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq('10')
      expect(search_results_node_set[0]['nextRecord']).to eq('11')
      expect(search_results_node_set[0]['elementSet']).to eq('summary')
      expect(search_results_node_set[0]['recordSchema']).to eq('http://www.isotc211.org/2005/gmi')
      # The brief records should have an id, scope and identification info
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata/gmd:fileIdentifier/gco:CharacterString',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'gmi' => 'http://www.isotc211.org/2005/gmi',
                                    'gmd' => 'http://www.isotc211.org/2005/gmd',
                                    'gco' => 'http://www.isotc211.org/2005/gco')[0].text).to eq("C1224520098-NOAA_NCEI")
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata/gmd:hierarchyLevel/gmd:MD_ScopeCode',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'gmi' => 'http://www.isotc211.org/2005/gmi',
                                    'gmd' => 'http://www.isotc211.org/2005/gmd')[0].text).to eq('series')
      first_purpose_element = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:purpose',
                                                     'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                                     'gmi' => 'http://www.isotc211.org/2005/gmi',
                                                     'gmd' => 'http://www.isotc211.org/2005/gmd',
                                                     'gco' => 'http://www.isotc211.org/2005/gco'
      )[0]
      # And also...
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata/gmd:distributionInfo',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'gmi' => 'http://www.isotc211.org/2005/gmi',
                                    'gmd' => 'http://www.isotc211.org/2005/gmd')[0]).not_to eq(nil)

    end
  end
end