require 'spec_helper'

RSpec.describe 'GetDomain http GET "DescribeRecord.schemaLanguage" request parameter success scenarios', :type => :request do

  it 'correctly renders the response for the DescribeRecord.schemaLanguage ParameterName' do
    post_xml = <<-eos
<?xml version="1.0" encoding="ISO-8859-1"?>
<GetDomain
   service="CSW"
   version="2.0.2"
   xmlns="http://www.opengis.net/cat/csw/2.0.2"
   xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
   xsi:schemaLocation="http://www.opengis.net/cat/csw/2.0.2 CSW-discovery.xsd">
    <ParameterName>DescribeRecord.schemaLanguage</ParameterName>
</GetDomain>
    eos
    post '/collections', post_xml
    expect(response).to have_http_status(:success)
    expect(response).to render_template('get_domain/index.xml.erb')
    domain_xml = Nokogiri::XML(response.body)
    expect(domain_xml.root.name).to eq 'GetDomainResponse'
    expect(domain_xml.root.at_xpath('/csw:GetDomainResponse/csw:DomainValues/csw:ParameterName',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').text).to eq('DescribeRecord.schemaLanguage')
    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:ListOfValues/csw:Value',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:ListOfValues/csw:Value',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')[0].text).to eq('http://www.w3.org/XML/Schema')
  end

end