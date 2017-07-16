require 'spec_helper'

RSpec.describe 'Get Record By ID http POST specs', :type => :request do
  describe 'POST GetRecordById using ISO GMI' do
    it 'correctly renders single ISO GMI record as full' do
      VCR.use_cassette 'requests/get_record_by_id/gmi/one_record', :decode_compressed_response => true, :record => :once do

        valid_get_record_by_id_request_xml = <<-eos
<csw:GetRecordById
    service="CSW"
    version="2.0.2"
    outputFormat="application/xml"
    outputSchema="http://www.isotc211.org/2005/gmi"
    xmlns="http://www.opengis.net/cat/csw/2.0.2"
    xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <csw:Id>C1224520098-NOAA_NCEI</csw:Id>
    <ElementSetName typeNames="csw:Record">full</ElementSetName>
</csw:GetRecordById>
        eos
        post '/collections', valid_get_record_by_id_request_xml

        expect(response).to have_http_status(:success)
        expect(response).to render_template('get_record_by_id/index.xml.erb')
        records_xml = Nokogiri::XML(response.body)
        expect(records_xml.root.name).to eq 'GetRecordByIdResponse'
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/gmi:MI_Metadata', 'gmi' => 'http://www.isotc211.org/2005/gmi', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
      end
    end
    it 'correctly renders two ISO GMI records as full' do
      VCR.use_cassette 'requests/get_record_by_id/gmi/two_records', :decode_compressed_response => true, :record => :once do
        valid_get_record_by_id_request_xml = <<-eos
<csw:GetRecordById
    service="CSW"
    version="2.0.2"
    outputFormat="application/xml"
    outputSchema="http://www.isotc211.org/2005/gmi"
    xmlns="http://www.opengis.net/cat/csw/2.0.2"
    xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <csw:Id>C1224520098-NOAA_NCEI</csw:Id>
    <csw:Id>C1224520058-NOAA_NCEI</csw:Id>
    <ElementSetName typeNames="csw:Record">full</ElementSetName>
</csw:GetRecordById>
        eos
        post '/collections', valid_get_record_by_id_request_xml
        expect(response).to have_http_status(:success)
        expect(response).to render_template('get_record_by_id/index.xml.erb')
        records_xml = Nokogiri::XML(response.body)
        expect(records_xml.root.name).to eq 'GetRecordByIdResponse'
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/gmi:MI_Metadata', 'gmi' => 'http://www.isotc211.org/2005/gmi', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(2)
      end
    end
  end
  it 'correctly renders zero ISO GMI records when unknown concept id is supplied' do
    VCR.use_cassette 'requests/get_record_by_id/gmi/no_record', :decode_compressed_response => true, :record => :once do
      valid_get_record_by_id_request_xml = <<-eos
<csw:GetRecordById
  service="CSW"
  version="2.0.2"
  outputFormat="application/xml"
  outputSchema="http://www.isotc211.org/2005/gmi"
  xmlns="http://www.opengis.net/cat/csw/2.0.2"
  xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <csw:Id>foo</csw:Id>
  <ElementSetName typeNames="csw:Record">full</ElementSetName>
</csw:GetRecordById>
      eos
      post '/collections', valid_get_record_by_id_request_xml
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_record_by_id/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordByIdResponse'
      # There should be no children
      expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/gmi:MI_Metadata', 'gmi' => 'http://www.isotc211.org/2005/gmi', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(0)
    end
  end

  it 'correctly reports an error when no id parameter is present' do
    valid_get_record_by_id_request_xml = <<-eos
<csw:GetRecordById
  service="CSW"
  version="2.0.2"
  outputFormat="application/xml"
  outputSchema="http://www.isotc211.org/2005/gmi"
  xmlns="http://www.opengis.net/cat/csw/2.0.2"
  xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <ElementSetName typeNames="csw:Record">full</ElementSetName>
</csw:GetRecordById>
    eos
    post '/collections', valid_get_record_by_id_request_xml
    expect(response).to have_http_status(:bad_request)
    exception_xml = Nokogiri::XML(response.body)
    expect(exception_xml.root.name).to eq 'ExceptionReport'
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows').size).to eq(1)
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@locator', 'ows' => 'http://www.opengis.net/ows').text).to eq('id')
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@exceptionCode', 'ows' => 'http://www.opengis.net/ows').text).to eq('MissingParameterValue')
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows').text).to eq("id can't be blank")
  end

  it 'correctly reports an error when an incorrect version is requested' do
    valid_get_record_by_id_request_xml = <<-eos
<csw:GetRecordById
  service="CSW"
  version="2.0.x"
  outputFormat="application/xml"
  outputSchema="http://www.isotc211.org/2005/gmi"
  xmlns="http://www.opengis.net/cat/csw/2.0.2"
  xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <csw:Id>foo</csw:Id>
  <ElementSetName typeNames="csw:Record">full</ElementSetName>
</csw:GetRecordById>
    eos
    post '/collections', valid_get_record_by_id_request_xml
    expect(response).to have_http_status(:bad_request)
    exception_xml = Nokogiri::XML(response.body)
    expect(exception_xml.root.name).to eq 'ExceptionReport'
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows').size).to eq(1)
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@locator', 'ows' => 'http://www.opengis.net/ows').text).to eq('version')
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@exceptionCode', 'ows' => 'http://www.opengis.net/ows').text).to eq('InvalidParameterValue')
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows').text).to eq("version '2.0.x' is not supported. Supported version is '2.0.2'")
  end
  it 'correctly reports an error when an incorrect service is requested' do
    valid_get_record_by_id_request_xml = <<-eos
<csw:GetRecordById
  service="foo"
  version="2.0.2"
  outputFormat="application/xml"
  outputSchema="http://www.isotc211.org/2005/gmi"
  xmlns="http://www.opengis.net/cat/csw/2.0.2"
  xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <csw:Id>foo</csw:Id>
  <ElementSetName typeNames="csw:Record">full</ElementSetName>
</csw:GetRecordById>
    eos
    post '/collections', valid_get_record_by_id_request_xml
    expect(response).to have_http_status(:bad_request)
    exception_xml = Nokogiri::XML(response.body)
    expect(exception_xml.root.name).to eq 'ExceptionReport'
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows').size).to eq(1)
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@locator', 'ows' => 'http://www.opengis.net/ows').text).to eq('service')
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@exceptionCode', 'ows' => 'http://www.opengis.net/ows').text).to eq('InvalidParameterValue')
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows').text).to eq("service 'foo' is not supported. Supported service is 'CSW'")
  end

  it 'correctly reports an error when an incorrect output schema is requested' do
    valid_get_record_by_id_request_xml = <<-eos
<csw:GetRecordById
  service="CSW"
  version="2.0.2"
  outputFormat="application/xml"
  outputSchema="foo"
  xmlns="http://www.opengis.net/cat/csw/2.0.2"
  xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <csw:Id>foo</csw:Id>
  <ElementSetName typeNames="csw:Record">full</ElementSetName>
</csw:GetRecordById>
    eos
    post '/collections', valid_get_record_by_id_request_xml
    expect(response).to have_http_status(:bad_request)
    exception_xml = Nokogiri::XML(response.body)
    expect(exception_xml.root.name).to eq 'ExceptionReport'
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows').size).to eq(1)
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@locator', 'ows' => 'http://www.opengis.net/ows').text).to eq('outputSchema')
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@exceptionCode', 'ows' => 'http://www.opengis.net/ows').text).to eq('InvalidParameterValue')
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows').text).to eq("Output schema 'foo' is not supported. Supported output schemas are http://www.opengis.net/cat/csw/2.0.2, http://www.isotc211.org/2005/gmi")
  end

  it 'correctly reports an error when an incorrect element set name is requested' do
    valid_get_record_by_id_request_xml = <<-eos
<csw:GetRecordById
  service="CSW"
  version="2.0.2"
  outputFormat="application/xml"
  outputSchema="http://www.isotc211.org/2005/gmi"
  xmlns="http://www.opengis.net/cat/csw/2.0.2"
  xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <csw:Id>foo</csw:Id>
  <ElementSetName typeNames="csw:Record">foo</ElementSetName>
</csw:GetRecordById>
    eos
    post '/collections', valid_get_record_by_id_request_xml
    expect(response).to have_http_status(:bad_request)
    exception_xml = Nokogiri::XML(response.body)
    expect(exception_xml.root.name).to eq 'ExceptionReport'
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows').size).to eq(1)
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@locator', 'ows' => 'http://www.opengis.net/ows').text).to eq('ElementSetName')
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@exceptionCode', 'ows' => 'http://www.opengis.net/ows').text).to eq('InvalidParameterValue')
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows').text).to eq("Element set name 'foo' is not supported. Supported element set names are brief, summary, full")
  end

  it 'correctly reports an error when an incorrect output format is requested' do
    valid_get_record_by_id_request_xml = <<-eos
<csw:GetRecordById
  service="CSW"
  version="2.0.2"
  outputFormat="foo"
  outputSchema="http://www.isotc211.org/2005/gmi"
  xmlns="http://www.opengis.net/cat/csw/2.0.2"
  xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <csw:Id>foo</csw:Id>
  <ElementSetName typeNames="csw:Record">full</ElementSetName>
</csw:GetRecordById>
    eos
    post '/collections', valid_get_record_by_id_request_xml
    expect(response).to have_http_status(:bad_request)
    exception_xml = Nokogiri::XML(response.body)
    expect(exception_xml.root.name).to eq 'ExceptionReport'
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows').size).to eq(1)
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@locator', 'ows' => 'http://www.opengis.net/ows').text).to eq('outputFormat')
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@exceptionCode', 'ows' => 'http://www.opengis.net/ows').text).to eq('InvalidParameterValue')
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows').text).to eq("Output file format 'foo' is not supported. Supported output file format is application/xml")
  end

  describe 'POST GetRecordById using CSW brief' do
    it 'correctly renders single CSW record as brief' do
      VCR.use_cassette 'requests/get_record_by_id/gmi/one_record', :decode_compressed_response => true, :record => :once do
        valid_get_record_by_id_request_xml = <<-eos
<csw:GetRecordById
    service="CSW"
    version="2.0.2"
    outputFormat="application/xml"
    outputSchema="http://www.opengis.net/cat/csw/2.0.2"
    xmlns="http://www.opengis.net/cat/csw/2.0.2"
    xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <csw:Id>C1224520098-NOAA_NCEI</csw:Id>
    <ElementSetName typeNames="csw:Record">brief</ElementSetName>
</csw:GetRecordById>
        eos
        post '/collections', valid_get_record_by_id_request_xml
        expect(response).to have_http_status(:success)
        expect(response).to render_template('get_record_by_id/index.xml.erb')
        records_xml = Nokogiri::XML(response.body)
        expect(records_xml.root.name).to eq 'GetRecordByIdResponse'
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/csw:BriefRecord', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
        # The brief record should have an id, title, type and bounding box
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/csw:BriefRecord/dc:identifier', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dc' => 'http://purl.org/dc/elements/1.1/').text).to eq('C1224520098-NOAA_NCEI')
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/csw:BriefRecord/dc:title', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dc' => 'http://purl.org/dc/elements/1.1/').text).to eq("\nGHRSST Level 2P Central Pacific Regional Skin Sea Surface Temperature from the Geostationary Operational Environmental Satellites (GOES) Imager on the GOES-15 satellite (GDS versions 1 and 2)\n")
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/csw:BriefRecord/dc:type', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dc' => 'http://purl.org/dc/elements/1.1/').text).to eq('dataset')

        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/csw:BriefRecord/ows:WGS84BoundingBox', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'ows' => 'http://www.opengis.net/ows').size).to eq(1)
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/csw:BriefRecord/ows:WGS84BoundingBox/ows:LowerCorner', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'ows' => 'http://www.opengis.net/ows').text).to eq('146.0 -44.0')
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/csw:BriefRecord/ows:WGS84BoundingBox/ows:UpperCorner', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'ows' => 'http://www.opengis.net/ows').text).to eq('-105.0 72.0')
      end
    end
  end

  describe 'POST GetRecordById using ISO GMI brief' do
    it 'correctly renders single CSW record as brief' do
      VCR.use_cassette 'requests/get_record_by_id/gmi/one_record', :decode_compressed_response => true, :record => :once do
        valid_get_record_by_id_request_xml = <<-eos
<csw:GetRecordById
    service="CSW"
    version="2.0.2"
    outputFormat="application/xml"
    outputSchema="http://www.isotc211.org/2005/gmi"
    xmlns="http://www.opengis.net/cat/csw/2.0.2"
    xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <csw:Id>C1224520098-NOAA_NCEI</csw:Id>
    <ElementSetName typeNames="csw:Record">brief</ElementSetName>
</csw:GetRecordById>
        eos
        post '/collections', valid_get_record_by_id_request_xml
        expect(response).to have_http_status(:success)
        expect(response).to render_template('get_record_by_id/index.xml.erb')
        records_xml = Nokogiri::XML(response.body)
        expect(records_xml.root.name).to eq 'GetRecordByIdResponse'
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/gmi:MI_Metadata', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'gmi' => 'http://www.isotc211.org/2005/gmi').size).to eq(1)
        # The brief record should have an id, scope and identification info
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/gmi:MI_Metadata/gmd:fileIdentifier/gco:CharacterString', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'gmi' => 'http://www.isotc211.org/2005/gmi', 'gmd' => 'http://www.isotc211.org/2005/gmd', 'gco' => 'http://www.isotc211.org/2005/gco').text).to eq('C1224520098-NOAA_NCEI')
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/gmi:MI_Metadata/gmd:hierarchyLevel/gmd:MD_ScopeCode', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'gmi' => 'http://www.isotc211.org/2005/gmi', 'gmd' => 'http://www.isotc211.org/2005/gmd').text).to eq('series')
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/gmi:MI_Metadata/gmd:identificationInfo', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'gmi' => 'http://www.isotc211.org/2005/gmi', 'gmd' => 'http://www.isotc211.org/2005/gmd').size).to eq(1)
      end
    end
  end

end