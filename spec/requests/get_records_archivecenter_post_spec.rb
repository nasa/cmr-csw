RSpec.describe "various GetRecords POST requests based on the ArchiveCenter queryable", :type => :request do

  it 'correctly renders FULL RESULTS ISO MENDS (GMI) data in response to an ArchiveCenter IsGeoss constraint POST request' do
    VCR.use_cassette 'requests/get_records/gmi/dhs4', :decode_compressed_response => true, :record => :once do
      get_records_request_xml = <<-eos
<?xml version="1.0"?>
<csw:GetRecords xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" resultType="results"
    xmlns:gmd="http://www.isotc211.org/2005/gmi" service="CSW" version="2.0.2">
    <csw:Query typeNames="csw:Record">
        <csw:ElementSetName>full</csw:ElementSetName>
        <csw:Constraint version="1.1.0">
            <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                    <ogc:PropertyIsLike>
                      <ogc:PropertyName>IsGeoss</ogc:PropertyName>
                      <ogc:Literal>true</ogc:Literal>
                    </ogc:PropertyIsLike>
                    <ogc:PropertyIsLike escapeChar="\\" singleChar="?" wildCard="*">
                        <ogc:PropertyName>ArchiveCenter</ogc:PropertyName>
                        <ogc:Literal>DHS*</ogc:Literal>
                    </ogc:PropertyIsLike>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', :params => get_records_request_xml
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be 4 records
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata', 'gmi' => 'http://www.isotc211.org/2005/gmi',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(4)
      # There should be a SearchStatus with a timestamp
      search_status_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchStatus', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_status_node_set.size).to eq(1) # expect(search_status_node_set[0]['timestamp']).to_not eq(nil)
      search_results_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_results_node_set.size).to eq(1)
      expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('4')
      expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq('4')
      expect(search_results_node_set[0]['nextRecord']).to eq('0')
      expect(search_results_node_set[0]['elementSet']).to eq('full')
      expect(search_results_node_set[0]['recordSchema']).to eq('http://www.isotc211.org/2005/gmi')
    end
  end

  it 'correctly renders HITS data in response to an ArchiveCenter IsGeoss constraint and resultType HITS POST request' do
    VCR.use_cassette 'requests/get_records/gmi/dhs5', :decode_compressed_response => true, :record => :once do
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
                    <ogc:PropertyIsLike>
                        <ogc:PropertyName>IsGeoss</ogc:PropertyName>
                        <ogc:Literal>true</ogc:Literal>
                    </ogc:PropertyIsLike>
                    <ogc:PropertyIsLike escapeChar="\\" singleChar="?" wildCard="*">
                        <ogc:PropertyName>ArchiveCenter</ogc:PropertyName>
                        <ogc:Literal>DHS*</ogc:Literal>
                    </ogc:PropertyIsLike>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/collections', :params => get_records_request_xml
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be a SearchStatus with a timestamp
      search_status_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchStatus', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_status_node_set.size).to eq(1) # expect(search_status_node_set[0]['timestamp']).to_not eq(nil)
      search_results_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      expect(search_results_node_set.size).to eq(1)
      expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('4')
      expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq('4')
      expect(search_results_node_set[0]['nextRecord']).to eq('0')
      expect(search_results_node_set[0]['elementSet']).to eq('full')
      # The SearchResults in the HITS response should NOT HAVE any child nodes
      children = search_results_node_set.children
      expect(children.size).to eq 0
    end
  end
end