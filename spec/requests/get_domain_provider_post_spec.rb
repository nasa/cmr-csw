require 'spec_helper'

RSpec.describe 'GetDomain http POST (Provider queryable) success scenarios', :type => :request do

  it 'correctly renders the response for the Provider PropertyName' do
    post_xml = <<-eos
<?xml version="1.0" encoding="ISO-8859-1"?>
<GetDomain
   service="CSW"
   version="2.0.2"
   xmlns="http://www.opengis.net/cat/csw/2.0.2"
   xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
   xsi:schemaLocation="http://www.opengis.net/cat/csw/2.0.2 CSW-discovery.xsd">
    <PropertyName>Provider</PropertyName>
</GetDomain>
    eos
    post '/collections', :params => post_xml
    expect(response).to have_http_status(:success)
    expect(response).to render_template('get_domain/index.xml.erb')
    domain_xml = Nokogiri::XML(response.body)
    expect(domain_xml.root.name).to eq 'GetDomainResponse'
    expect(domain_xml.root.at_xpath('/csw:GetDomainResponse/csw:DomainValues/csw:PropertyName',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').text).to eq('Provider')
    expect(domain_xml.root.at_xpath('/csw:GetDomainResponse/csw:DomainValues/csw:ConceptualScheme/csw:Name',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').text).to eq('NASA Global Change Master Directory (GCMD). GCMD Keywords.')
    expect(domain_xml.root.at_xpath('/csw:GetDomainResponse/csw:DomainValues/csw:ConceptualScheme/csw:Document',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').text).to eq('http://gcmdservices.gsfc.nasa.gov/static/kms/providers/providers.csv')
    expect(domain_xml.root.at_xpath('/csw:GetDomainResponse/csw:DomainValues/csw:ConceptualScheme/csw:Authority',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').text).to eq('http://gcmd.nasa.gov/learn/keyword_list.html')
  end

  # Only the first property will be processed per spec
  it 'correctly renders the response for both Provider and TempExtent_end properties' do
    post_xml = <<-eos
<?xml version="1.0" encoding="ISO-8859-1"?>
<GetDomain
   service="CSW"
   version="2.0.2"
   xmlns="http://www.opengis.net/cat/csw/2.0.2"
   xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
   xsi:schemaLocation="http://www.opengis.net/cat/csw/2.0.2 CSW-discovery.xsd">
    <PropertyName>Provider</PropertyName>
    <PropertyName>TempExtent_end</PropertyName>
</GetDomain>
    eos
    post '/collections', :params => post_xml
    expect(response).to have_http_status(:success)
    expect(response).to render_template('get_domain/index.xml.erb')
    domain_xml = Nokogiri::XML(response.body)
    expect(domain_xml.root.name).to eq 'GetDomainResponse'
    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)

    expect(domain_xml.root.at_xpath('/csw:GetDomainResponse/csw:DomainValues/csw:PropertyName',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').text).to eq('Provider')
    expect(domain_xml.root.at_xpath('/csw:GetDomainResponse/csw:DomainValues/csw:ConceptualScheme/csw:Name',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').text).to eq('NASA Global Change Master Directory (GCMD). GCMD Keywords.')
    expect(domain_xml.root.at_xpath('/csw:GetDomainResponse/csw:DomainValues/csw:ConceptualScheme/csw:Document',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').text).to eq('http://gcmdservices.gsfc.nasa.gov/static/kms/providers/providers.csv')
    expect(domain_xml.root.at_xpath('/csw:GetDomainResponse/csw:DomainValues/csw:ConceptualScheme/csw:Authority',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').text).to eq('http://gcmd.nasa.gov/learn/keyword_list.html')
  end
end
