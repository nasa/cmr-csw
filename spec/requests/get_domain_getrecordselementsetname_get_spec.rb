require 'spec_helper'

RSpec.describe 'GetDomain http GET "GetRecords.ElementSetName" request parameter success scenarios', :type => :request do

  it 'correctly renders the response for the GetRecords.ElementSetName ParameterName' do
    get '/collections', :params => {  :request => 'GetDomain', :service => 'CSW', :version => '2.0.2', :ParameterName => 'GetRecords.ElementSetName' }
    expect(response).to have_http_status(:success)
    expect(response).to render_template('get_domain/index.xml.erb')
    domain_xml = Nokogiri::XML(response.body)
    expect(domain_xml.root.name).to eq 'GetDomainResponse'
    expect(domain_xml.root.at_xpath('/csw:GetDomainResponse/csw:DomainValues/csw:ParameterName',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').text).to eq('GetRecords.ElementSetName')
    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:ListOfValues/csw:Value',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(3)
    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:ListOfValues/csw:Value',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')[0].text).to eq('brief')
    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:ListOfValues/csw:Value',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')[1].text).to eq('summary')
    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:ListOfValues/csw:Value',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')[2].text).to eq('full')


  end

end