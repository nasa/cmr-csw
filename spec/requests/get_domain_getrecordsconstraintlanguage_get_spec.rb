require 'spec_helper'

RSpec.describe 'GetDomain http GET "GetRecords.CONSTRAINTLANGUAGE" request parameter success scenarios', :type => :request do

  it 'correctly renders the response for the GetRecords.CONSTRAINTLANGUAGE ParameterName' do
    get '/collections', :params => {  :request => 'GetDomain', :service => 'CSW', :version => '2.0.2', :ParameterName => 'GetRecords.CONSTRAINTLANGUAGE' }
    expect(response).to have_http_status(:success)
    expect(response).to render_template('get_domain/index.xml.erb')
    domain_xml = Nokogiri::XML(response.body)
    expect(domain_xml.root.name).to eq 'GetDomainResponse'
    expect(domain_xml.root.at_xpath('/csw:GetDomainResponse/csw:DomainValues/csw:ParameterName',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').text).to eq('GetRecords.CONSTRAINTLANGUAGE')
    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:ListOfValues/csw:Value',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:ListOfValues/csw:Value',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')[0].text).to eq('FILTER')

  end

end