require 'spec_helper'

RSpec.describe 'GetDomain http POST TOI (TempExtent_begin and TempExtent_end queryables) success scenarios', :type => :request do

  it 'correctly renders the response for the TempExtent_begin PropertyName' do
    post_xml = <<-eos
<?xml version="1.0" encoding="ISO-8859-1"?>
<GetDomain
   service="CSW"
   version="2.0.2"
   xmlns="http://www.opengis.net/cat/csw/2.0.2"
   xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
   xsi:schemaLocation="http://www.opengis.net/cat/csw/2.0.2 CSW-discovery.xsd">
    <PropertyName>TempExtent_begin</PropertyName>
</GetDomain>
    eos
    post '/collections', post_xml
    expect(response).to have_http_status(:success)
    expect(response).to render_template('get_domain/index.xml.erb')
    domain_xml = Nokogiri::XML(response.body)
    expect(domain_xml.root.name).to eq 'GetDomainResponse'
    expect(domain_xml.root.at_xpath('/csw:GetDomainResponse/csw:DomainValues/csw:PropertyName',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').text).to eq('TempExtent_begin')
    expect(domain_xml.root.at_xpath('/csw:GetDomainResponse/csw:DomainValues/csw:RangeOfValues/csw:MinValue',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').text).to eq('0000-01-01T00:00:00Z')
    expect(domain_xml.root.at_xpath('/csw:GetDomainResponse/csw:DomainValues/csw:RangeOfValues/csw:MaxValue',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').text).to eq('9999-12-31T23:59:59Z')
  end

  it 'correctly renders the response for the TempExtent_end PropertyName' do
    post_xml = <<-eos
<?xml version="1.0" encoding="ISO-8859-1"?>
<GetDomain
   service="CSW"
   version="2.0.2"
   xmlns="http://www.opengis.net/cat/csw/2.0.2"
   xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
   xsi:schemaLocation="http://www.opengis.net/cat/csw/2.0.2 CSW-discovery.xsd">
    <PropertyName>TempExtent_end</PropertyName>
</GetDomain>
    eos
    post '/collections', post_xml
    expect(response).to have_http_status(:success)
    expect(response).to render_template('get_domain/index.xml.erb')
    domain_xml = Nokogiri::XML(response.body)
    expect(domain_xml.root.name).to eq 'GetDomainResponse'
    expect(domain_xml.root.at_xpath('/csw:GetDomainResponse/csw:DomainValues/csw:PropertyName',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').text).to eq('TempExtent_end')
    expect(domain_xml.root.at_xpath('/csw:GetDomainResponse/csw:DomainValues/csw:RangeOfValues/csw:MinValue',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').text).to eq('0000-01-01T00:00:00Z')
    expect(domain_xml.root.at_xpath('/csw:GetDomainResponse/csw:DomainValues/csw:RangeOfValues/csw:MaxValue',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').text).to eq('9999-12-31T23:59:59Z')
  end

  it 'correctly renders the response for an unknown property' do
    post_xml = <<-eos
<?xml version="1.0" encoding="ISO-8859-1"?>
<GetDomain
   service="CSW"
   version="2.0.2"
   xmlns="http://www.opengis.net/cat/csw/2.0.2"
   xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
   xsi:schemaLocation="http://www.opengis.net/cat/csw/2.0.2 CSW-discovery.xsd">
    <PropertyName>UNKNOWN_PROPERTY</PropertyName>
</GetDomain>
    eos
    post '/collections', post_xml
    expect(response).to have_http_status(:success)
    expect(response).to render_template('get_domain/index.xml.erb')
    domain_xml = Nokogiri::XML(response.body)
    expect(domain_xml.root.name).to eq 'GetDomainResponse'
    expect(domain_xml.root.at_xpath('/csw:GetDomainResponse/csw:DomainValues/csw:PropertyName',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').text).to eq('UNKNOWN_PROPERTY')
    # for an unknown property, return the property itself and no siblings
    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:PropertyName/following-sibling::*',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(0)
  end

  # Only the first property will be processed per spec
  it 'correctly renders the response for both TempExtent_begin and TempExtent_end properties' do
    post_xml = <<-eos
<?xml version="1.0" encoding="ISO-8859-1"?>
<GetDomain
   service="CSW"
   version="2.0.2"
   xmlns="http://www.opengis.net/cat/csw/2.0.2"
   xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
   xsi:schemaLocation="http://www.opengis.net/cat/csw/2.0.2 CSW-discovery.xsd">
    <PropertyName>TempExtent_begin</PropertyName>
    <PropertyName>TempExtent_end</PropertyName>
</GetDomain>
    eos
    post '/collections', post_xml
    expect(response).to have_http_status(:success)
    expect(response).to render_template('get_domain/index.xml.erb')
    domain_xml = Nokogiri::XML(response.body)
    expect(domain_xml.root.name).to eq 'GetDomainResponse'
    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:PropertyName',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')[0].text).to eq('TempExtent_begin')
    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:RangeOfValues/csw:MinValue',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')[0].text).to eq('0000-01-01T00:00:00Z')
    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:RangeOfValues/csw:MaxValue',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')[0].text).to eq('9999-12-31T23:59:59Z')

  end
end

RSpec.describe 'GetDomain http POST (TempExtent_begin and TempExtent_end queryables) error scenarios', :type => :request do
  # The error specs are not property specific
  # See the get_domain_modified_post_spec error scenarios.  They cover ALL PropertyName with a static value domain
  # capture in the respective model class (ex. DomainModified, TempExtent_begin, TempExtent_end etc.)
end