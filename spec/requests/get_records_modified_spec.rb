require "spec_helper"

RSpec.describe "various GetRecords POST requests based on the Modified CSW queryable", :type => :request do

  it 'correctly renders FULL RESULTS ISO MENDS (GMI) data in response to a Modified ONLY constraint POST request' do
    VCR.use_cassette 'requests/get_records/gmi/modified_records_only', :decode_compressed_response => true, :record => :once do
      get_records_request_xml = <<-eos
<?xml version="1.0"?>
<csw:GetRecords xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" resultType="results"
    xmlns:gmd="http://www.isotc211.org/2005/gmi" service="CSW" version="2.0.2">
    <csw:Query typeNames="csw:Record">
        <csw:ElementSetName>full</csw:ElementSetName>
        <csw:Constraint version="1.1.0">
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
      post '/collections', get_records_request_xml
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
      expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('1461')
      expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq('10')
      expect(search_results_node_set[0]['nextRecord']).to eq('11')
      expect(search_results_node_set[0]['elementSet']).to eq('full')
      expect(search_results_node_set[0]['recordSchema']).to eq('http://www.isotc211.org/2005/gmi')
    end
  end

  it 'correctly renders BRIEF RESULTS ISO MENDS (GMI) data in response to a Modified ONLY constraint POST request' do
    VCR.use_cassette 'requests/get_records/gmi/modified_records_only', :decode_compressed_response => true, :record => :once do
      get_records_request_xml = <<-eos
<?xml version="1.0"?>
<csw:GetRecords xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" resultType="results"
    xmlns:gmd="http://www.isotc211.org/2005/gmi" service="CSW" version="2.0.2">
    <csw:Query typeNames="csw:Record">
        <csw:ElementSetName>brief</csw:ElementSetName>
        <csw:Constraint version="1.1.0">
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
      post '/collections', get_records_request_xml
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
      expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('1461')
      expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq('10')
      expect(search_results_node_set[0]['nextRecord']).to eq('11')
      expect(search_results_node_set[0]['elementSet']).to eq('brief')
      expect(search_results_node_set[0]['recordSchema']).to eq('http://www.isotc211.org/2005/gmi')
      # The brief records should have an id, scope and identification info
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata/gmd:fileIdentifier/gco:CharacterString',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'gmi' => 'http://www.isotc211.org/2005/gmi',
                                    'gmd' => 'http://www.isotc211.org/2005/gmd',
                                    'gco' => 'http://www.isotc211.org/2005/gco')[0].text).to eq('C1214608509-SCIOPS')
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
      expect(first_purpose_element.text).to eq('To provide high quality posters for significant hurricane events for the public.')
    end
  end

  it 'correctly renders BRIEF CSW RESULTS data in response to a Modified ONLY constraint POST request' do
    VCR.use_cassette 'requests/get_records/gmi/modified_records_only', :decode_compressed_response => true, :record => :once do
      get_records_request_xml = <<-eos
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
                    <ogc:PropertyIsGreaterThanOrEqualTo>
                        <ogc:PropertyName>Modified</ogc:PropertyName>
                        <ogc:Literal>2016-04-01</ogc:Literal>
                    </ogc:PropertyIsGreaterThanOrEqualTo>
            </ogc:Filter>
         </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', get_records_request_xml
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
      expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('1461')
      expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq('10')
      expect(search_results_node_set[0]['nextRecord']).to eq('11')
      expect(search_results_node_set[0]['elementSet']).to eq('brief')
      expect(search_results_node_set[0]['recordSchema']).to eq('http://www.opengis.net/cat/csw/2.0.2')

      # The brief record should have an id, title, type and bounding box
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:BriefRecord/dc:identifier',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'dc' => 'http://purl.org/dc/elements/1.1/')[0].text).to eq('C1214608509-SCIOPS')
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/csw:BriefRecord/dc:title',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                    'dc' => 'http://purl.org/dc/elements/1.1/')[0].text).to eq("1 Kilometer Land Cover Product from the University of Maryland")
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

  it 'correctly renders FULL RESULTS ISO MENDS (GMI) data in response to a AOI(Point)_TOI_Modified constraint POST request' do
    VCR.use_cassette 'requests/get_records/gmi/modified_records_mixed', :decode_compressed_response => true, :record => :once do
      get_records_request_xml = <<-eos
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
                        <ogc:Literal>2016-05-12T23:59:59Z</ogc:Literal>
                    </ogc:PropertyIsLessThanOrEqualTo>
                    <gml:Point xmlns:gml="http://www.opengis.net/gml">
                      <gml:pos>-165.938 47.517</gml:pos>
                    </gml:Point>
                    <ogc:PropertyIsGreaterThanOrEqualTo>
                        <ogc:PropertyName>Modified</ogc:PropertyName>
                        <ogc:Literal>2016-04-01</ogc:Literal>
                    </ogc:PropertyIsGreaterThanOrEqualTo>
                </ogc:And>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', get_records_request_xml
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
      expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('814')
      expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq('10')
      expect(search_results_node_set[0]['nextRecord']).to eq('11')
      expect(search_results_node_set[0]['elementSet']).to eq('full')
      expect(search_results_node_set[0]['recordSchema']).to eq('http://www.isotc211.org/2005/gmi')
    end
  end

  it 'correctly renders HITS data in response to a Modified constraint POST request' do
    VCR.use_cassette 'requests/get_records/gmi/modified_records_only', :decode_compressed_response => true, :record => :once do
      get_records_request_xml = <<-eos
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
                    <ogc:PropertyIsGreaterThanOrEqualTo>
                        <ogc:PropertyName>Modified</ogc:PropertyName>
                        <ogc:Literal>2016-04-01</ogc:Literal>
                    </ogc:PropertyIsGreaterThanOrEqualTo>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', get_records_request_xml
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be a SearchStatus with a timestamp
      search_status_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchStatus', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_status_node_set.size).to eq(1) # expect(search_status_node_set[0]['timestamp']).to_not eq(nil)
      search_results_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_results_node_set.size).to eq(1)
      expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('1461')
      expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq('10')
      expect(search_results_node_set[0]['nextRecord']).to eq('11')
      expect(search_results_node_set[0]['elementSet']).to eq('full')
      # The SearchResults in the HITS response should NOT HAVE any child nodes
      children = search_results_node_set.children
      expect(children.size).to eq 0
    end
  end

  it 'correctly renders default HITS data in response to the resultType missing and a Modified constraint POST request' do
    VCR.use_cassette 'requests/get_records/gmi/modified_records_only', :decode_compressed_response => true, :record => :once do
      get_records_request_xml = <<-eos
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
                    <ogc:PropertyIsGreaterThanOrEqualTo>
                        <ogc:PropertyName>Modified</ogc:PropertyName>
                        <ogc:Literal>2016-04-01</ogc:Literal>
                    </ogc:PropertyIsGreaterThanOrEqualTo>
               </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', get_records_request_xml
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be a SearchStatus with a timestamp
      search_status_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchStatus', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_status_node_set.size).to eq(1) # expect(search_status_node_set[0]['timestamp']).to_not eq(nil)
      search_results_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_results_node_set.size).to eq(1)
      expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('1461')
      expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq('10')
      expect(search_results_node_set[0]['nextRecord']).to eq('11')
      expect(search_results_node_set[0]['elementSet']).to eq('full')
      # The SearchResults in the HITS response should NOT HAVE any child nodes
      children = search_results_node_set.children
      expect(children.size).to eq 0
    end
  end
end