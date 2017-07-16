require 'spec_helper'

RSpec.describe 'GetDomain http GET "outputFormat" request parameter success scenarios', :type => :request do

  it 'correctly renders the response for the outputFormat ParameterName' do
    get '/collections', :request => 'GetDomain', :service => 'CSW', :version => '2.0.2', :ParameterName => 'GetRecords.outputFormat'
    expect(response).to have_http_status(:success)
    expect(response).to render_template('get_domain/index.xml.erb')
    domain_xml = Nokogiri::XML(response.body)
    expect(domain_xml.root.name).to eq 'GetDomainResponse'
    expect(domain_xml.root.at_xpath('/csw:GetDomainResponse/csw:DomainValues/csw:ParameterName',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').text).to eq('GetRecords.outputFormat')
    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:ListOfValues/csw:Value',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:ListOfValues/csw:Value',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')[0].text).to eq('application/xml')
  end

  it 'correctly renders the response for outputFormat and an unknown parameter' do
    get '/collections', :request => 'GetDomain', :service => 'CSW', :version => '2.0.2', :ParameterName => 'GetRecords.outputFormat,UNKNOWN_PARAMETER'
    expect(response).to have_http_status(:success)
    expect(response).to render_template('get_domain/index.xml.erb')
    domain_xml = Nokogiri::XML(response.body)
    expect(domain_xml.root.name).to eq 'GetDomainResponse'

    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:ParameterName',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')[0].text).to eq('GetRecords.outputFormat')
    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:ListOfValues/csw:Value',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').first.text).to eq('application/xml')
    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:ListOfValues/csw:Value',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').last.text).to eq('application/xml')

    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:ParameterName',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')[1].text).to eq('UNKNOWN_PARAMETER')
    # for an unknown parameter, return the property itself and no siblings
    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:ParameterName/following-sibling::*',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
  end
end
