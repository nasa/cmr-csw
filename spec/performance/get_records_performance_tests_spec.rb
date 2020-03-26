require 'benchmark'

RSpec.describe "various GetRecords POST requests to evaluate and improve performance", :type => :request do
  # expectations for various result sizes
  let(:performace_runs) { [
      {:max_records => 10, :max_allowed_memory_increase_mb => 35},
      {:max_records => 100, :max_allowed_memory_increase_mb => 100},
      {:max_records => 1000, :max_allowed_memory_increase_mb => 410},
      {:max_records => 2000, :max_allowed_memory_increase_mb => 820}
  ]
  }

  it 'has expected memory increases during performance runs' do
    # compress the response :decode_compressed_response => true
    VCR.use_cassette 'requests/get_records/gmi/perf_gmi_full_1', :record => :once do
      toi_only_constraint_get_records_request_xml = <<-eos
<csw:GetRecords maxRecords="maxRecordsPlaceholder" outputFormat="application/xml"
    outputSchema="http://www.isotc211.org/2005/gmi" resultType="results" service="CSW"
    startPosition="1" version="2.0.2" xmlns="http://www.opengis.net/cat/csw/2.0.2"
    xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
    <csw:Query typeNames="csw:Record">
        <csw:ElementSetName>full</csw:ElementSetName>
        <csw:Constraint version="1.1.0" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2">
            <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                    <ogc:PropertyIsGreaterThanOrEqualTo>
                        <ogc:PropertyName>TempExtent_begin</ogc:PropertyName>
                        <ogc:Literal>1990-09-03T00:00:01Z</ogc:Literal>
                    </ogc:PropertyIsGreaterThanOrEqualTo>
                    <!--
                    <ogc:PropertyIsLessThanOrEqualTo>
                        <ogc:PropertyName>TempExtent_end</ogc:PropertyName>
                        <ogc:Literal>2008­09­06T23:59:59Z</ogc:Literal>
                    </ogc:PropertyIsLessThanOrEqualTo>
                    -->
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      performace_runs.each do |performance_run|
        max_records = performance_run[:max_records]
        max_memory_increase_mb = performance_run[:max_allowed_memory_increase_mb]
        Rails.logger.info("RUNNING performance test for maxRecords = #{max_records} max_memory_increase_mb=#{max_memory_increase_mb}")
        # collect memory before measurements
        GC.start(full_mark: true, immediate_sweep: true, immediate_mark: false)
        gc_stat_before = GC.stat
        resident_set_size_MB_start = (`ps -o rss= -p #{Process.pid}`.to_i/1024)
        num_objects_start = ObjectSpace.count_objects

        post '/collections', :params => toi_only_constraint_get_records_request_xml.gsub('maxRecordsPlaceholder', max_records.to_s)
        expect(response).to have_http_status(:success)
        expect(response).to render_template('get_records/index.xml.erb')
        records_xml = Nokogiri::XML(response.body)
        expect(records_xml.root.name).to eq 'GetRecordsResponse'
        # There should be max_records
        expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata', 'gmi' => 'http://www.isotc211.org/2005/gmi',
                                      'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(max_records.to_i)
        # There should be a SearchStatus with a timestamp
        search_status_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchStatus', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
        expect(search_status_node_set.size).to eq(1) # expect(search_status_node_set[0]['timestamp']).to_not eq(nil)
        search_results_node_set = records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
        expect(search_results_node_set.size).to eq(1)
        expect(search_results_node_set[0]['numberOfRecordsMatched']).to eq('23423')
        expect(search_results_node_set[0]['numberOfRecordsReturned']).to eq(max_records.to_s)
        expect(search_results_node_set[0]['nextRecord']).to eq((max_records + 1).to_s)
        expect(search_results_node_set[0]['elementSet']).to eq('full')
        expect(search_results_node_set[0]['recordSchema']).to eq('http://www.isotc211.org/2005/gmi')
        resident_set_size_MB_end_before_GC = (`ps -o rss= -p #{Process.pid}`.to_i/1024)
        num_objects_end_before_GC = ObjectSpace.count_objects
        expect(resident_set_size_MB_end_before_GC - resident_set_size_MB_start).to be < max_memory_increase_mb
        # collect memory AFTER measurements
        GC.start(full_mark: true, immediate_sweep: true, immediate_mark: false)
        gc_stat_after = GC.stat
        resident_set_size_MB_end_after_GC = (`ps -o rss= -p #{Process.pid}`.to_i/1024)
        num_objects_end_after_GC = ObjectSpace.count_objects
        # less than max_memory_increase in ram
        expect(resident_set_size_MB_end_after_GC - resident_set_size_MB_start).to be < max_memory_increase_mb
        memory_stats_msg = "RSS_start: #{resident_set_size_MB_start} num_objects_start: #{num_objects_start} gc_stat_start: #{gc_stat_before} RSS_end_before_gc: #{resident_set_size_MB_end_before_GC} num_objects_end_before_gc: #{num_objects_end_before_GC} RSS_end_after_gc: #{resident_set_size_MB_end_after_GC} num_objects_end_after_gc: #{num_objects_end_after_GC} gc_stat_end_after_gc: #{gc_stat_after}"
        Rails.logger.info("RAN performance test for maxRecords = #{max_records} max_memory_increase_mb=#{max_memory_increase_mb}")
        Rails.logger.info(memory_stats_msg)
      end
    end
  end
end
