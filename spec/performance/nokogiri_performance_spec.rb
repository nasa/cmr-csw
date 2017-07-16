require 'benchmark'

# the test below can be used while profiling XSL performance before and after changes to the code or XSLT
RSpec.describe "various Nokogiri performance tests with CMR XML responses", :type => :request do

  it 'inspects performance for adding the CWIC keywords to the largest possible CMR response' do
    input_document = File.open('spec/fixtures/helpers/2000_records.xml') { |f| Nokogiri::XML(f) }
    time = Benchmark.realtime do
      document_with_cwic_keywords = BaseCswModel.add_cwic_keywords(input_document)
    end
    Rails.logger.info "Adding CWIC keywords took #{(time.to_f * 1000).round(0)} ms"
  end

  ## START FROM ISO MENDS to CSW ##
  it 'inspects performance for translating a CMR ISO_MENDS record into a CSW summary record' do
    csw_record = nil
    input_document = File.open('spec/fixtures/helpers/2000_records.xml') { |f| Nokogiri::XML(f) }
    time = Benchmark.realtime do
      csw_record = to_records(input_document, 'http://www.opengis.net/cat/csw/2.0.2', 'summary', ['result_root_element', 'csw:GetRecordsResponse',
                                                                                                  'number_of_records_matched', 4700,
                                                                                                  'number_of_records_returned', 2000,
                                                                                                  'element_set', 'summary',
                                                                                                  'next_record', 2001,
                                                                                                  'record_schema', 'http://www.opengis.net/cat/csw/2.0.2',
                                                                                                  'server_timestamp', Time.now.iso8601
                                                                                                 ])
    end
    Rails.logger.info "Translation from ISO_MENDS to CSW summary took #{(time.to_f * 1000).round(0)} ms"
  end

  it 'inspects performance for translating a CMR ISO_MENDS record into a CSW full record' do
    csw_record = nil
    input_document = File.open('spec/fixtures/helpers/2000_records.xml') { |f| Nokogiri::XML(f) }
    time = Benchmark.realtime do
      csw_record = to_records(input_document, 'http://www.opengis.net/cat/csw/2.0.2', 'full', ['result_root_element', 'csw:GetRecordsResponse',
                                                                                               'number_of_records_matched', 4700,
                                                                                               'number_of_records_returned', 2000,
                                                                                               'element_set', 'full',
                                                                                               'next_record', 2001,
                                                                                               'record_schema', 'http://www.opengis.net/cat/csw/2.0.2',
                                                                                               'server_timestamp', Time.now.iso8601
      ])
    end
    Rails.logger.info "Translation from ISO_MENDS to CSW full took #{(time.to_f * 1000).round(0)} ms"
  end

  it 'inspects performance for translating a CMR ISO_MENDS record into a CSW brief record' do
    csw_record = nil
    input_document = File.open('spec/fixtures/helpers/2000_records.xml') { |f| Nokogiri::XML(f) }
    time = Benchmark.realtime do
      csw_record = to_records(input_document, 'http://www.opengis.net/cat/csw/2.0.2', 'brief', ['result_root_element', 'csw:GetRecordsResponse',
                                                                                                'number_of_records_matched', 4700,
                                                                                                'number_of_records_returned', 2000,
                                                                                                'element_set', 'brief',
                                                                                                'next_record', 2001,
                                                                                                'record_schema', 'http://www.opengis.net/cat/csw/2.0.2',
                                                                                                'server_timestamp', Time.now.iso8601
      ])
    end
    Rails.logger.info "Translation from ISO_MENDS to CSW brief took #{(time.to_f * 1000).round(0)} ms"
  end
  ## END FROM ISO MENDS to CSW ##

  ## START FROM ISO MENDS to GMI ##
  it 'inspects performance for translating a CMR ISO_MENDS record into a GMI summary record' do
    gmi_record = nil
    input_document = File.open('spec/fixtures/helpers/2000_records.xml') { |f| Nokogiri::XML(f) }
    time = Benchmark.realtime do
      gmi_record = to_records(input_document, 'http://www.isotc211.org/2005/gmi', 'summary', ['result_root_element', 'csw:GetRecordsResponse',
                                                                                              'number_of_records_matched', 4700,
                                                                                              'number_of_records_returned', 2000,
                                                                                              'element_set', 'summary',
                                                                                              'next_record', 2001,
                                                                                              'record_schema', 'http://www.isotc211.org/2005/gmi',
                                                                                              'server_timestamp', Time.now.iso8601
      ])
    end
    Rails.logger.info "Translation from ISO_MENDS to GMI summary took #{(time.to_f * 1000).round(0)} ms"
  end

  it 'inspects performance for translating a CMR ISO_MENDS record into a GMI full record' do
    gmi_record = nil
    input_document = File.open('spec/fixtures/helpers/2000_records.xml') { |f| Nokogiri::XML(f) }
    time = Benchmark.realtime do
      gmi_record = to_records(input_document, 'http://www.isotc211.org/2005/gmi', 'full', ['result_root_element', 'csw:GetRecordsResponse',
                                                                                           'number_of_records_matched', 4700,
                                                                                           'number_of_records_returned', 2000,
                                                                                           'element_set', 'full',
                                                                                           'next_record', 2001,
                                                                                           'record_schema', 'http://www.isotc211.org/2005/gmi',
                                                                                           'server_timestamp', Time.now.iso8601])
    end
    Rails.logger.info "Translation from ISO_MENDS to GMI full took #{(time.to_f * 1000).round(0)} ms"
  end

  it 'inspects performance for translating a CMR ISO_MENDS record into a CSW brief record' do
    gmi_record = nil
    input_document = File.open('spec/fixtures/helpers/2000_records.xml') { |f| Nokogiri::XML(f) }
    time = Benchmark.realtime do
      gmi_record = to_records(input_document, 'http://www.isotc211.org/2005/gmi', 'brief', ['result_root_element', 'csw:GetRecordsResponse',
                                                                                            'number_of_records_matched', 4700,
                                                                                            'number_of_records_returned', 2000,
                                                                                            'element_set', 'brief',
                                                                                            'next_record', 2001,
                                                                                            'record_schema', 'http://www.isotc211.org/2005/gmi',
                                                                                            'server_timestamp', Time.now.iso8601])
    end
    Rails.logger.info "Translation from ISO_MENDS to GMI brief took #{(time.to_f * 1000).round(0)} ms"
  end
  ## END FROM ISO MENDS to GMI ##


  ## START FROM ISO MENDS to GMD ##
  it 'inspects performance for translating a CMR ISO_MENDS record into a GMD summary record' do
    gmd_record = nil
    input_document = File.open('spec/fixtures/helpers/2000_records.xml') { |f| Nokogiri::XML(f) }
    time = Benchmark.realtime do
      gmd_record = to_records(input_document, 'http://www.isotc211.org/2005/gmd', 'summary', ['result_root_element', 'csw:GetRecordsResponse',
                                                                                              'number_of_records_matched', 4700,
                                                                                              'number_of_records_returned', 2000,
                                                                                              'element_set', 'summary',
                                                                                              'next_record', 2001,
                                                                                              'record_schema', 'http://www.isotc211.org/2005/gmd',
                                                                                              'server_timestamp', Time.now.iso8601
      ])
    end
    Rails.logger.info "Translation from ISO_MENDS to GMD summary took #{(time.to_f * 1000).round(0)} ms"
  end

  it 'inspects performance for translating a CMR ISO_MENDS record into a GMD full record' do
    gmd_record = nil
    input_document = File.open('spec/fixtures/helpers/2000_records.xml') { |f| Nokogiri::XML(f) }
    time = Benchmark.realtime do
      gmd_record = to_records(input_document, 'http://www.isotc211.org/2005/gmd', 'full', ['result_root_element', 'csw:GetRecordsResponse',
                                                                                           'number_of_records_matched', 4700,
                                                                                           'number_of_records_returned', 2000,
                                                                                           'element_set', 'full',
                                                                                           'next_record', 2001,
                                                                                           'record_schema', 'http://www.isotc211.org/2005/gmd',
                                                                                           'server_timestamp', Time.now.iso8601])
    end
    Rails.logger.info "Translation from ISO_MENDS to GMD full took #{(time.to_f * 1000).round(0)} ms"
  end

  it 'inspects performance for translating a CMR ISO_MENDS record into a GMD brief record' do
    gmd_record = nil
    input_document = File.open('spec/fixtures/helpers/2000_records.xml') { |f| Nokogiri::XML(f) }
    time = Benchmark.realtime do
      gmd_record = to_records(input_document, 'http://www.isotc211.org/2005/gmd', 'brief', ['result_root_element', 'csw:GetRecordsResponse',
                                                                                            'number_of_records_matched', 4700,
                                                                                            'number_of_records_returned', 2000,
                                                                                            'element_set', 'brief',
                                                                                            'next_record', 2001,
                                                                                            'record_schema', 'http://www.isotc211.org/2005/gmd',
                                                                                            'server_timestamp', Time.now.iso8601])
    end
    Rails.logger.info "Translation from ISO_MENDS to GMD brief took #{(time.to_f * 1000).round(0)} ms"
  end
  ## END FROM ISO MENDS to GMD ##

end
