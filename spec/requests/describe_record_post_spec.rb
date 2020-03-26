require 'spec_helper'

RSpec.describe 'DescribeRecord POST examples', :type => :request do

  describe 'DescribeRecord successful POST examples', :type => :request do

    it 'correctly renders the response to a valid DescribeRecord POST request with all three typenames' do
      post_xml = <<-eos
<?xml version="1.0" encoding="ISO-8859-1"?>
<DescribeRecord xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xsi:schemaLocation="http://www.opengis.net/cat/csw/2.0.2 csw.xsd"
 xmlns="http://www.opengis.net/cat/csw/2.0.2" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmi="http://www.isotc211.org/2005/gmi"
 xmlns:gmd="http://www.isotc211.org/2005/gmd"
 service="CSW" version="2.0.2" outputFormat="application/xml"
 schemaLanguage="http://www.w3.org/2001/XMLSchema">
    <TypeName>csw:Record</TypeName>
    <TypeName>gmi:MI_Metadata</TypeName>
    <TypeName>gmd:MD_Metadata</TypeName>
</DescribeRecord>
      eos
      post '/collections', :params => post_xml
      expect(response).to have_http_status(:ok)
      expect(response).to render_template('describe_record/index.xml.erb')
      response_xml = Nokogiri::XML(response.body)
      expect(response_xml.root.name).to eq 'DescribeRecordResponse'
      expect(response_xml.root.xpath('/csw:DescribeRecordResponse/csw:SchemaComponent', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(3)
      # gmi schema
      expect(response_xml.root.xpath("/csw:DescribeRecordResponse/csw:SchemaComponent[@targetNamespace='http://www.isotc211.org/2005/gmi']",
                                     'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
      expect(response_xml.root.xpath("/csw:DescribeRecordResponse/csw:SchemaComponent[@targetNamespace='http://www.isotc211.org/2005/gmi']/xsd:schema[@targetNamespace='http://www.isotc211.org/2005/gmi']",
                                     'xsd' => 'http://www.w3.org/2001/XMLSchema', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
      # gmd schema
      expect(response_xml.root.xpath("/csw:DescribeRecordResponse/csw:SchemaComponent[@targetNamespace='http://www.isotc211.org/2005/gmd']",
                                     'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
      expect(response_xml.root.xpath("/csw:DescribeRecordResponse/csw:SchemaComponent[@targetNamespace='http://www.isotc211.org/2005/gmd']/xsd:schema[@targetNamespace='http://www.isotc211.org/2005/gmd']",
                                     'xsd' => 'http://www.w3.org/2001/XMLSchema', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
      # csw schema
      expect(response_xml.root.xpath("/csw:DescribeRecordResponse/csw:SchemaComponent[@targetNamespace='http://www.opengis.net/cat/csw/2.0.2']",
                                     'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
      expect(response_xml.root.xpath("/csw:DescribeRecordResponse/csw:SchemaComponent[@targetNamespace='http://www.opengis.net/cat/csw/2.0.2']/xsd:schema[@targetNamespace='http://www.opengis.net/cat/csw/2.0.2']",
                                     'xsd' => 'http://www.w3.org/2001/XMLSchema', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)

    end

    it 'correctly renders the response to a valid DescribeRecord POST request with the csw typename' do
      post_xml = <<-eos
<?xml version="1.0" encoding="ISO-8859-1"?>
<DescribeRecord xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xsi:schemaLocation="http://www.opengis.net/cat/csw/2.0.2 csw.xsd"
 xmlns="http://www.opengis.net/cat/csw/2.0.2" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmi="http://www.isotc211.org/2005/gmi"
 xmlns:gmd="http://www.isotc211.org/2005/gmd"
 service="CSW" version="2.0.2" outputFormat="application/xml"
 schemaLanguage="http://www.w3.org/2001/XMLSchema">
    <TypeName>csw:Record</TypeName>
</DescribeRecord>
      eos
      post '/collections', :params => post_xml
      expect(response).to have_http_status(:success)
      expect(response).to render_template('describe_record/index.xml.erb')
      response_xml = Nokogiri::XML(response.body)
      expect(response_xml.root.name).to eq 'DescribeRecordResponse'
      expect(response_xml.root.xpath('/csw:DescribeRecordResponse/csw:SchemaComponent', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
      expect(response_xml.root.xpath("/csw:DescribeRecordResponse/csw:SchemaComponent[@targetNamespace='http://www.opengis.net/cat/csw/2.0.2']", 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
      expect(response_xml.root.xpath("/csw:DescribeRecordResponse/csw:SchemaComponent[@targetNamespace='http://www.opengis.net/cat/csw/2.0.2']/xsd:schema[@targetNamespace='http://www.opengis.net/cat/csw/2.0.2']", 'xsd' => 'http://www.w3.org/2001/XMLSchema', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
    end

    it 'correctly renders the response to a valid DescribeRecord POST request with the gmi typename' do
      post_xml = <<-eos
<?xml version="1.0" encoding="ISO-8859-1"?>
<DescribeRecord xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xsi:schemaLocation="http://www.opengis.net/cat/csw/2.0.2 csw.xsd"
 xmlns="http://www.opengis.net/cat/csw/2.0.2" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmi="http://www.isotc211.org/2005/gmi"
 xmlns:gmd="http://www.isotc211.org/2005/gmd"
 service="CSW" version="2.0.2" outputFormat="application/xml"
 schemaLanguage="http://www.w3.org/2001/XMLSchema">
    <TypeName>gmi:MI_Metadata</TypeName>
</DescribeRecord>
      eos
      post '/collections', :params => post_xml
      expect(response).to have_http_status(:success)
      expect(response).to render_template('describe_record/index.xml.erb')
      response_xml = Nokogiri::XML(response.body)
      expect(response_xml.root.name).to eq 'DescribeRecordResponse'
      expect(response_xml.root.xpath('/csw:DescribeRecordResponse/csw:SchemaComponent', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
      expect(response_xml.root.xpath("/csw:DescribeRecordResponse/csw:SchemaComponent[@targetNamespace='http://www.isotc211.org/2005/gmi']", 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
      expect(response_xml.root.xpath("/csw:DescribeRecordResponse/csw:SchemaComponent[@targetNamespace='http://www.isotc211.org/2005/gmi']/xsd:schema[@targetNamespace='http://www.isotc211.org/2005/gmi']", 'xsd' => 'http://www.w3.org/2001/XMLSchema', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
    end

    it 'correctly renders the response to a valid DescribeRecord POST request with the gmd typename' do
      post_xml = <<-eos
<?xml version="1.0" encoding="ISO-8859-1"?>
<DescribeRecord xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xsi:schemaLocation="http://www.opengis.net/cat/csw/2.0.2 csw.xsd"
 xmlns="http://www.opengis.net/cat/csw/2.0.2" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmi="http://www.isotc211.org/2005/gmi"
 xmlns:gmd="http://www.isotc211.org/2005/gmd"
 service="CSW" version="2.0.2" outputFormat="application/xml"
 schemaLanguage="http://www.w3.org/2001/XMLSchema">
    <TypeName>gmd:MD_Metadata</TypeName>
</DescribeRecord>
      eos
      post '/collections', :params => post_xml
      expect(response).to have_http_status(:success)
      expect(response).to render_template('describe_record/index.xml.erb')
      response_xml = Nokogiri::XML(response.body)
      expect(response_xml.root.name).to eq 'DescribeRecordResponse'
      expect(response_xml.root.xpath('/csw:DescribeRecordResponse/csw:SchemaComponent', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
      expect(response_xml.root.xpath("/csw:DescribeRecordResponse/csw:SchemaComponent[@targetNamespace='http://www.isotc211.org/2005/gmd']", 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
      expect(response_xml.root.xpath("/csw:DescribeRecordResponse/csw:SchemaComponent[@targetNamespace='http://www.isotc211.org/2005/gmd']/xsd:schema[@targetNamespace='http://www.isotc211.org/2005/gmd']", 'xsd' => 'http://www.w3.org/2001/XMLSchema', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
    end

    it 'correctly renders the response to a valid DescribeRecord POST request with the  csw and gmi typenames' do
      post_xml = <<-eos
<?xml version="1.0" encoding="ISO-8859-1"?>
<DescribeRecord xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xsi:schemaLocation="http://www.opengis.net/cat/csw/2.0.2 csw.xsd"
 xmlns="http://www.opengis.net/cat/csw/2.0.2" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmi="http://www.isotc211.org/2005/gmi"
 xmlns:gmd="http://www.isotc211.org/2005/gmd"
 service="CSW" version="2.0.2" outputFormat="application/xml"
 schemaLanguage="http://www.w3.org/2001/XMLSchema">
    <TypeName>csw:Record</TypeName>
    <TypeName>gmi:MI_Metadata</TypeName>
</DescribeRecord>
      eos
      post '/collections', :params => post_xml
      expect(response).to render_template('describe_record/index.xml.erb')
      response_xml = Nokogiri::XML(response.body)
      expect(response_xml.root.name).to eq 'DescribeRecordResponse'
      expect(response_xml.root.xpath('/csw:DescribeRecordResponse/csw:SchemaComponent', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(2)
      expect(response_xml.root.xpath("/csw:DescribeRecordResponse/csw:SchemaComponent[@targetNamespace='http://www.isotc211.org/2005/gmi']", 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
      expect(response_xml.root.xpath("/csw:DescribeRecordResponse/csw:SchemaComponent[@targetNamespace='http://www.isotc211.org/2005/gmi']/xsd:schema[@targetNamespace='http://www.isotc211.org/2005/gmi']", 'xsd' => 'http://www.w3.org/2001/XMLSchema', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
      expect(response_xml.root.xpath("/csw:DescribeRecordResponse/csw:SchemaComponent[@targetNamespace='http://www.opengis.net/cat/csw/2.0.2']", 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
      expect(response_xml.root.xpath("/csw:DescribeRecordResponse/csw:SchemaComponent[@targetNamespace='http://www.opengis.net/cat/csw/2.0.2']/xsd:schema[@targetNamespace='http://www.opengis.net/cat/csw/2.0.2']", 'xsd' => 'http://www.w3.org/2001/XMLSchema', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
    end

    it 'correctly  to a valid DescribeRecord POST request with foo:MD_Metadata type name when foo is correctly mapped to gmd' do
      post_xml = <<-eos
<?xml version="1.0" encoding="ISO-8859-1"?>
<DescribeRecord xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xsi:schemaLocation="http://www.opengis.net/cat/csw/2.0.2 csw.xsd"
 xmlns="http://www.opengis.net/cat/csw/2.0.2" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmi="http://www.isotc211.org/2005/gmi"
 xmlns:foo="http://www.isotc211.org/2005/gmd"
 service="CSW" version="2.0.2" outputFormat="application/xml"
 schemaLanguage="http://www.w3.org/2001/XMLSchema">
    <TypeName>foo:MD_Metadata</TypeName>
</DescribeRecord>
      eos
      post '/collections', :params => post_xml
      expect(response).to have_http_status(:success)
      expect(response).to render_template('describe_record/index.xml.erb')
      response_xml = Nokogiri::XML(response.body)
      expect(response_xml.root.name).to eq 'DescribeRecordResponse'
      expect(response_xml.root.xpath('/csw:DescribeRecordResponse/csw:SchemaComponent', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
      expect(response_xml.root.xpath("/csw:DescribeRecordResponse/csw:SchemaComponent[@targetNamespace='http://www.isotc211.org/2005/gmd']", 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
      expect(response_xml.root.xpath("/csw:DescribeRecordResponse/csw:SchemaComponent[@targetNamespace='http://www.isotc211.org/2005/gmd']/xsd:schema[@targetNamespace='http://www.isotc211.org/2005/gmd']", 'xsd' => 'http://www.w3.org/2001/XMLSchema', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
    end

    it 'correctly renders the DEFAULT gmi schema response to a valid DescribeRecord POST request without a typename' do
      post_xml = <<-eos
<?xml version="1.0" encoding="ISO-8859-1"?>
<DescribeRecord xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xsi:schemaLocation="http://www.opengis.net/cat/csw/2.0.2 csw.xsd"
 xmlns="http://www.opengis.net/cat/csw/2.0.2" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmi="http://www.isotc211.org/2005/gmi"
 xmlns:gmd="http://www.isotc211.org/2005/gmd"
 service="CSW" version="2.0.2" outputFormat="application/xml"
 schemaLanguage="http://www.w3.org/2001/XMLSchema">
    <TypeName>gmi:MI_Metadata</TypeName>
</DescribeRecord>
      eos
      post '/collections', :params => post_xml
      expect(response).to have_http_status(:success)
      expect(response).to render_template('describe_record/index.xml.erb')
      response_xml = Nokogiri::XML(response.body)
      expect(response_xml.root.name).to eq 'DescribeRecordResponse'
      expect(response_xml.root.xpath('/csw:DescribeRecordResponse/csw:SchemaComponent', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
      expect(response_xml.root.xpath("/csw:DescribeRecordResponse/csw:SchemaComponent[@targetNamespace='http://www.isotc211.org/2005/gmi']", 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
      expect(response_xml.root.xpath("/csw:DescribeRecordResponse/csw:SchemaComponent[@targetNamespace='http://www.isotc211.org/2005/gmi']/xsd:schema[@targetNamespace='http://www.isotc211.org/2005/gmi']", 'xsd' => 'http://www.w3.org/2001/XMLSchema', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
    end
  end

  describe 'failed DescribeRecord POST scenarios' do
    it 'returns an error for an unknown namespace href' do
      post_xml = <<-eos
<?xml version="1.0" encoding="ISO-8859-1"?>
<DescribeRecord xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xsi:schemaLocation="http://www.opengis.net/cat/csw/2.0.2 csw.xsd"
 xmlns="http://www.opengis.net/cat/csw/2.0.2" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2_UNKNOWN" xmlns:gmi="http://www.isotc211.org/2005/gmi"
 xmlns:gmd="http://www.isotc211.org/2005/gmd"
 service="CSW" version="2.0.2" outputFormat="application/xml"
 schemaLanguage="http://www.w3.org/2001/XMLSchema">
    <TypeName>csw:Record</TypeName>
    <TypeName>gmi:MI_Metadata</TypeName>
    <TypeName>gmd:MD_Metadata</TypeName>
</DescribeRecord>
      eos
      post '/collections', :params => post_xml
      expect(response).to have_http_status(:bad_request)
      exception_xml = Nokogiri::XML(response.body)
      expect(exception_xml.root.name).to eq 'ExceptionReport'
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows').size).to eq(2)

      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@locator', 'ows' => 'http://www.opengis.net/ows').first.text).to eq('TypeName')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@exceptionCode', 'ows' => 'http://www.opengis.net/ows').first.text).to eq('NoApplicableCode')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows').first.text).to eq("'Record' is not part of the http://www.opengis.net/cat/csw/2.0.2_UNKNOWN schema")

      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@locator', 'ows' => 'http://www.opengis.net/ows').last.text).to eq('NAMESPACE')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@exceptionCode', 'ows' => 'http://www.opengis.net/ows').last.text).to eq('InvalidParameterValue')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows').last.text).to eq("Namespace 'http://www.opengis.net/cat/csw/2.0.2_UNKNOWN' is not supported. Supported namespaces are http://www.opengis.net/cat/csw/2.0.2, http://www.isotc211.org/2005/gmi, http://www.isotc211.org/2005/gmd")
    end

    it 'returns an error for an unknown schema language' do
      post_xml = <<-eos
<?xml version="1.0" encoding="ISO-8859-1"?>
<DescribeRecord xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xsi:schemaLocation="http://www.opengis.net/cat/csw/2.0.2 csw.xsd"
 xmlns="http://www.opengis.net/cat/csw/2.0.2" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmi="http://www.isotc211.org/2005/gmi"
 xmlns:gmd="http://www.isotc211.org/2005/gmd"
 service="CSW" version="2.0.2" outputFormat="application/xml"
 schemaLanguage="foo">
    <TypeName>csw:Record</TypeName>
    <TypeName>gmi:MI_Metadata</TypeName>
    <TypeName>gmd:MD_Metadata</TypeName>
</DescribeRecord>
      eos
      post '/collections', :params => post_xml
      expect(response).to have_http_status(:bad_request)
      exception_xml = Nokogiri::XML(response.body)
      expect(exception_xml.root.name).to eq 'ExceptionReport'
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows').size).to eq(1)
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@locator', 'ows' => 'http://www.opengis.net/ows').text).to eq('schemaLanguage')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@exceptionCode', 'ows' => 'http://www.opengis.net/ows').text).to eq('InvalidParameterValue')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows').text).to eq("Schema Language 'foo' is not supported. Supported output file format is http://www.w3.org/2001/XMLSchema, XMLSCHEMA")
    end

    it 'returns an error when there is no namespace declaration for the requested TypeName' do
      post_xml = <<-eos
<?xml version="1.0" encoding="ISO-8859-1"?>
<DescribeRecord xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xsi:schemaLocation="http://www.opengis.net/cat/csw/2.0.2 csw.xsd"
 xmlns="http://www.opengis.net/cat/csw/2.0.2" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
 xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gmi="http://www.isotc211.org/2005/gmi"
 service="CSW" version="2.0.2" outputFormat="application/xml"
 schemaLanguage="http://www.w3.org/2001/XMLSchema">
    <TypeName>abc:MI_Metadata</TypeName>
</DescribeRecord>
      eos
      post '/collections', :params => post_xml
      expect(response).to have_http_status(:bad_request)
      exception_xml = Nokogiri::XML(response.body)
      expect(exception_xml.root.name).to eq 'ExceptionReport'
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows').size).to eq(1)

      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@locator', 'ows' => 'http://www.opengis.net/ows').first.text).to eq('TypeName')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@exceptionCode', 'ows' => 'http://www.opengis.net/ows').first.text).to eq('NoApplicableCode')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows').first.text).to eq("Prefix 'abc' does not map to any of the supplied namespaces")
    end

    it 'returns an error when there is an invalid (not supported) TypeName from the gmi namespace' do
      post_xml = <<-eos
<?xml version="1.0" encoding="ISO-8859-1"?>
<DescribeRecord xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xsi:schemaLocation="http://www.opengis.net/cat/csw/2.0.2 csw.xsd"
 xmlns="http://www.opengis.net/cat/csw/2.0.2" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
 xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gmi="http://www.isotc211.org/2005/gmi"
 service="CSW" version="2.0.2" outputFormat="application/xml"
 schemaLanguage="http://www.w3.org/2001/XMLSchema">
    <TypeName>gmi:foo</TypeName>
</DescribeRecord>
      eos
      post '/collections', :params => post_xml
      expect(response).to have_http_status(:bad_request)
      exception_xml = Nokogiri::XML(response.body)
      expect(exception_xml.root.name).to eq 'ExceptionReport'
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows').size).to eq(1)
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@locator', 'ows' => 'http://www.opengis.net/ows').text).to eq('TypeName')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@exceptionCode', 'ows' => 'http://www.opengis.net/ows').text).to eq('InvalidParameterValue')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows').text).to eq("'foo' is not a supported element for description. Supported elements are 'csw:Record', 'gmi:MI_Metadata' and 'gmd:MD_Metadata'")
    end

    it 'returns an error when there is an invalid (not supported) TypeName from the gmd namespace' do
      post_xml = <<-eos
<?xml version="1.0" encoding="ISO-8859-1"?>
<DescribeRecord xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xsi:schemaLocation="http://www.opengis.net/cat/csw/2.0.2 csw.xsd"
 xmlns="http://www.opengis.net/cat/csw/2.0.2" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
 xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gmi="http://www.isotc211.org/2005/gmi"
 service="CSW" version="2.0.2" outputFormat="application/xml"
 schemaLanguage="http://www.w3.org/2001/XMLSchema">
    <TypeName>gmd:foo</TypeName>
</DescribeRecord>
      eos
      post '/collections', :params => post_xml
      expect(response).to have_http_status(:bad_request)
      exception_xml = Nokogiri::XML(response.body)
      expect(exception_xml.root.name).to eq 'ExceptionReport'
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows').size).to eq(1)
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@locator', 'ows' => 'http://www.opengis.net/ows').text).to eq('TypeName')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@exceptionCode', 'ows' => 'http://www.opengis.net/ows').text).to eq('InvalidParameterValue')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows').text).to eq("'foo' is not a supported element for description. Supported elements are 'csw:Record', 'gmi:MI_Metadata' and 'gmd:MD_Metadata'")
    end

    it 'returns an error when there is an invalid (not supported) TypeName from the csw namespace' do
      post_xml = <<-eos
<?xml version="1.0" encoding="ISO-8859-1"?>
<DescribeRecord xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xsi:schemaLocation="http://www.opengis.net/cat/csw/2.0.2 csw.xsd"
 xmlns="http://www.opengis.net/cat/csw/2.0.2" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
 xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gmi="http://www.isotc211.org/2005/gmi"
 service="CSW" version="2.0.2" outputFormat="application/xml"
 schemaLanguage="http://www.w3.org/2001/XMLSchema">
    <TypeName>csw:foo</TypeName>
</DescribeRecord>
      eos
      post '/collections', :params => post_xml
      expect(response).to have_http_status(:bad_request)
      exception_xml = Nokogiri::XML(response.body)
      expect(exception_xml.root.name).to eq 'ExceptionReport'
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows').size).to eq(1)
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@locator', 'ows' => 'http://www.opengis.net/ows').text).to eq('TypeName')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@exceptionCode', 'ows' => 'http://www.opengis.net/ows').text).to eq('InvalidParameterValue')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows').text).to eq("'foo' is not a supported element for description. Supported elements are 'csw:Record', 'gmi:MI_Metadata' and 'gmd:MD_Metadata'")
    end

    it 'returns an error when there is an invalid (not supported) TypeName from the gmi namespace' do
      post_xml = <<-eos
<?xml version="1.0" encoding="ISO-8859-1"?>
<DescribeRecord xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xsi:schemaLocation="http://www.opengis.net/cat/csw/2.0.2 csw.xsd"
 xmlns="http://www.opengis.net/cat/csw/2.0.2" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
 xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gmi="http://www.isotc211.org/2005/gmi"
 service="CSW" version="2.0.2" outputFormat="application/xml"
 schemaLanguage="http://www.w3.org/2001/XMLSchema">
    <TypeName>gmi:Record</TypeName>
</DescribeRecord>
      eos
      post '/collections', :params => post_xml
      expect(response).to have_http_status(:bad_request)
      exception_xml = Nokogiri::XML(response.body)
      expect(exception_xml.root.name).to eq 'ExceptionReport'
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows').size).to eq(1)
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@locator', 'ows' => 'http://www.opengis.net/ows').text).to eq('TypeName')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@exceptionCode', 'ows' => 'http://www.opengis.net/ows').text).to eq('NoApplicableCode')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows').text).to eq("'Record' is not part of the http://www.isotc211.org/2005/gmi schema")
    end

    it 'returns an error when there is an invalid (not supported) TypeName from the gmd namespace' do
      post_xml = <<-eos
<?xml version="1.0" encoding="ISO-8859-1"?>
<DescribeRecord xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xsi:schemaLocation="http://www.opengis.net/cat/csw/2.0.2 csw.xsd"
 xmlns="http://www.opengis.net/cat/csw/2.0.2" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
 xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gmi="http://www.isotc211.org/2005/gmi"
 service="CSW" version="2.0.2" outputFormat="application/xml"
 schemaLanguage="http://www.w3.org/2001/XMLSchema">
    <TypeName>gmd:MI_Metadata</TypeName>
</DescribeRecord>
      eos
      post '/collections', :params => post_xml
      expect(response).to have_http_status(:bad_request)
      exception_xml = Nokogiri::XML(response.body)
      expect(exception_xml.root.name).to eq 'ExceptionReport'
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows').size).to eq(1)
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@locator', 'ows' => 'http://www.opengis.net/ows').text).to eq('TypeName')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@exceptionCode', 'ows' => 'http://www.opengis.net/ows').text).to eq('NoApplicableCode')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows').text).to eq("'MI_Metadata' is not part of the http://www.isotc211.org/2005/gmd schema")
    end

    it 'returns an error when there is an invalid (not supported) TypeName from the csw namespace' do
      post_xml = <<-eos
<?xml version="1.0" encoding="ISO-8859-1"?>
<DescribeRecord xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xsi:schemaLocation="http://www.opengis.net/cat/csw/2.0.2 csw.xsd"
 xmlns="http://www.opengis.net/cat/csw/2.0.2" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
 xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gmi="http://www.isotc211.org/2005/gmi"
 service="CSW" version="2.0.2" outputFormat="application/xml"
 schemaLanguage="http://www.w3.org/2001/XMLSchema">
    <TypeName>csw:MD_Metadata</TypeName>
</DescribeRecord>
      eos
      post '/collections', :params => post_xml
      expect(response).to have_http_status(:bad_request)
      exception_xml = Nokogiri::XML(response.body)
      expect(exception_xml.root.name).to eq 'ExceptionReport'
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows').size).to eq(1)
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@locator', 'ows' => 'http://www.opengis.net/ows').text).to eq('TypeName')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@exceptionCode', 'ows' => 'http://www.opengis.net/ows').text).to eq('NoApplicableCode')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows').text).to eq("'MD_Metadata' is not part of the http://www.opengis.net/cat/csw/2.0.2 schema")
    end
  end

end
