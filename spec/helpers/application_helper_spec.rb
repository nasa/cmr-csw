require 'spec_helper'

RSpec.describe ApplicationHelper do
  context 'summary records in CSW' do
    it 'is possible to translate a CMR ISO_MENDS record into a CSW summary record' do
      input_document = File.open('spec/fixtures/helpers/iso_mends_full.xml') { |f| Nokogiri::XML(f) }

      csw_summary_record = to_records(input_document, 'http://www.opengis.net/cat/csw/2.0.2', 'summary', ['result_root_element', 'csw:GetRecordByIdResponse'])

      output_document = Nokogiri::XML(csw_summary_record)
      expect(output_document.root.name).to eq 'GetRecordByIdResponse'
      expect(output_document.root.xpath('/csw:GetRecordByIdResponse/csw:SummaryRecord', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
      # The summary record should have an id, title, type and bounding box inherited from 'brief'
      expect(output_document.root.xpath('/csw:GetRecordByIdResponse/csw:SummaryRecord/dc:identifier', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dc' => 'http://purl.org/dc/elements/1.1/').text).to eq('C1224520058-NOAA_NCEI')
      expect(output_document.root.xpath('/csw:GetRecordByIdResponse/csw:SummaryRecord/dc:title', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dc' => 'http://purl.org/dc/elements/1.1/').text).to eq('ISO MENDS File')
      expect(output_document.root.xpath('/csw:GetRecordByIdResponse/csw:SummaryRecord/dc:type', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dc' => 'http://purl.org/dc/elements/1.1/').text).to eq('dataset')

      expect(output_document.root.xpath('/csw:GetRecordByIdResponse/csw:SummaryRecord/ows:WGS84BoundingBox', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'ows' => 'http://www.opengis.net/ows').size).to eq(1)
      expect(output_document.root.xpath('/csw:GetRecordByIdResponse/csw:SummaryRecord/ows:WGS84BoundingBox/ows:LowerCorner', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'ows' => 'http://www.opengis.net/ows').text).to eq('4 2')
      expect(output_document.root.xpath('/csw:GetRecordByIdResponse/csw:SummaryRecord/ows:WGS84BoundingBox/ows:UpperCorner', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'ows' => 'http://www.opengis.net/ows').text).to eq('3 1')
      # The summary record should also have a subject, format, relation, modified, abstract and spatial element if present in the original metadata
      expect(output_document.root.xpath('/csw:GetRecordByIdResponse/csw:SummaryRecord/dc:subject', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dc' => 'http://purl.org/dc/elements/1.1/').size).to eq(16)
      expect(output_document.root.xpath('/csw:GetRecordByIdResponse/csw:SummaryRecord/dc:subject', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dc' => 'http://purl.org/dc/elements/1.1/').first.text).to eq('EARTH SCIENCE>CRYOSPHERE>SNOW/ICE>ALBEDO>BETA>GAMMA>DETAILED')

      expect(output_document.root.xpath('/csw:GetRecordByIdResponse/csw:SummaryRecord/dc:format', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dc' => 'http://purl.org/dc/elements/1.1/').text).to eq('gzip')
      expect(output_document.root.xpath('/csw:GetRecordByIdResponse/csw:SummaryRecord/dc:relation', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dc' => 'http://purl.org/dc/elements/1.1/').size).to eq(3)
      expect(output_document.root.xpath('/csw:GetRecordByIdResponse/csw:SummaryRecord/dc:relation', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dc' => 'http://purl.org/dc/elements/1.1/').first.text).to eq('COLLOTHER-237')

      expect(output_document.root.xpath('/csw:GetRecordByIdResponse/csw:SummaryRecord/dct:modified', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dct' => 'http://purl.org/dc/terms/').size).to eq(2)
      expect(output_document.root.xpath('/csw:GetRecordByIdResponse/csw:SummaryRecord/dct:modified', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dct' => 'http://purl.org/dc/terms/').first.text).to eq('1999-12-31T19:00:00-05:00')
      expect(output_document.root.xpath('/csw:GetRecordByIdResponse/csw:SummaryRecord/dct:abstract', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dct' => 'http://purl.org/dc/terms/').text).to eq('An abstract')
    end

    it 'is possible to translate a CMR ISO_MENDS record into a CSW summary record without optional items' do
      input_document = File.open('spec/fixtures/helpers/iso_mends_no_optionals.xml') { |f| Nokogiri::XML(f) }

      csw_summary_record = to_records(input_document, 'http://www.opengis.net/cat/csw/2.0.2', 'summary', ['result_root_element', 'csw:GetRecordByIdResponse'])

      output_document = Nokogiri::XML(csw_summary_record)
      expect(output_document.root.name).to eq 'GetRecordByIdResponse'
      expect(output_document.root.xpath('/csw:GetRecordByIdResponse/csw:SummaryRecord', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
      # The summary record should have an id, title, type and bounding box inherited from 'brief'
      expect(output_document.root.xpath('/csw:GetRecordByIdResponse/csw:SummaryRecord/dc:identifier', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dc' => 'http://purl.org/dc/elements/1.1/').text).to eq('C1224520058-NOAA_NCEI')
      expect(output_document.root.xpath('/csw:GetRecordByIdResponse/csw:SummaryRecord/dc:title', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dc' => 'http://purl.org/dc/elements/1.1/').text).to eq('ISO MENDS File')
      expect(output_document.root.xpath('/csw:GetRecordByIdResponse/csw:SummaryRecord/dc:type', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dc' => 'http://purl.org/dc/elements/1.1/').text).to eq('dataset')

      expect(output_document.root.xpath('/csw:GetRecordByIdResponse/csw:SummaryRecord/ows:WGS84BoundingBox', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'ows' => 'http://www.opengis.net/ows')).to be_empty
      # The summary record should also have a subject, format, relation, modified, abstract and spatial element if present in the original metadata
      expect(output_document.root.xpath('/csw:GetRecordByIdResponse/csw:SummaryRecord/dc:subject', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dc' => 'http://purl.org/dc/elements/1.1/')).to be_empty
      expect(output_document.root.xpath('/csw:GetRecordByIdResponse/csw:SummaryRecord/dc:format', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dc' => 'http://purl.org/dc/elements/1.1/')).to be_empty
      expect(output_document.root.xpath('/csw:GetRecordByIdResponse/csw:SummaryRecord/dc:relation', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dc' => 'http://purl.org/dc/elements/1.1/')).to be_empty

      expect(output_document.root.xpath('/csw:GetRecordByIdResponse/csw:SummaryRecord/dc:modified', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dc' => 'http://purl.org/dc/elements/1.1/')).to be_empty
      expect(output_document.root.xpath('/csw:GetRecordByIdResponse/csw:SummaryRecord/dct:abstract', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dct' => 'http://purl.org/dc/terms')).to be_empty
    end
  end
end