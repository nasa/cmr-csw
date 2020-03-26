RSpec.describe 'GetDomain http GET "IsGeoss" queryable success scenarios', :type => :request do

  it 'correctly renders the response for the IsGeoss PropertyName' do
    get '/collections', :params => {  :request => 'GetDomain', :service => 'CSW', :version => '2.0.2', :PropertyName => 'IsGeoss' }
    expect(response).to have_http_status(:success)
    expect(response).to render_template('get_domain/index.xml.erb')
    domain_xml = Nokogiri::XML(response.body)
    expect(domain_xml.root.name).to eq 'GetDomainResponse'
    expect(domain_xml.root.at_xpath('/csw:GetDomainResponse/csw:DomainValues/csw:PropertyName',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').text).to eq('IsGeoss')
    expect(domain_xml.root.at_xpath('/csw:GetDomainResponse/csw:DomainValues/csw:ListOfValues/csw:Value',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').text).to eq('true')
  end

  it 'correctly renders the response for TempExtent_begin,TempExtent_end,IsGeoss properties' do
    get '/collections', :params => {  :request => 'GetDomain', :service => 'CSW', :version => '2.0.2', :PropertyName => 'TempExtent_begin,TempExtent_end, IsGeoss' }
    expect(response).to have_http_status(:success)
    expect(response).to render_template('get_domain/index.xml.erb')
    domain_xml = Nokogiri::XML(response.body)
    expect(domain_xml.root.name).to eq 'GetDomainResponse'

    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:PropertyName',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')[0].text).to eq('TempExtent_begin')
    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:RangeOfValues/csw:MinValue',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')[0].text).to eq('0000-01-01T00:00:00Z')
    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:RangeOfValues/csw:MaxValue',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')[0].text).to eq('9999-12-31T23:59:59Z')

    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:PropertyName',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')[1].text).to eq('TempExtent_end')
    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:RangeOfValues/csw:MinValue',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')[1].text).to eq('0000-01-01T00:00:00Z')
    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:RangeOfValues/csw:MaxValue',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')[1].text).to eq('9999-12-31T23:59:59Z')

    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:PropertyName',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')[2].text).to eq('IsGeoss')
    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:ListOfValues/csw:Value',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')[0].text).to eq('true')
  end

  it 'correctly renders the response for IsGeoss and an unknown property' do
    get '/collections', :params => {  :request => 'GetDomain', :service => 'CSW', :version => '2.0.2', :PropertyName => 'IsGeoss,UNKNOWN_PROPERTY' }
    expect(response).to have_http_status(:success)
    expect(response).to render_template('get_domain/index.xml.erb')
    domain_xml = Nokogiri::XML(response.body)
    expect(domain_xml.root.name).to eq 'GetDomainResponse'

    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:PropertyName',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')[0].text).to eq('IsGeoss')
    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:ListOfValues/csw:Value',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')[0].text).to eq('true')

    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:PropertyName',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')[1].text).to eq('UNKNOWN_PROPERTY')
    # for an unknown property, return the property itself and no siblings
    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:PropertyName/following-sibling::*',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
  end
end

RSpec.describe 'GetDomain http GET "IsGeoss" queryable error scenarios', :type => :request do
  it 'correctly renders the exception response for a GetDomain without a service and version' do
    get '/collections', :params => {  :request => 'GetDomain', :PropertyName => 'IsGeoss' }
    expect(response).to have_http_status(:bad_request)
    expect(response).to render_template('shared/exception_report.xml.erb')
    records_xml = Nokogiri::XML(response.body)
    expect(records_xml.root.name).to eq 'ExceptionReport'
    exception_node_set = records_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows')
    expect(exception_node_set.size).to eq(2)

    expect(exception_node_set[0]['exceptionCode']).to eq('MissingParameterValue')
    expect(exception_node_set[0]['locator']).to eq('version')
    exception_text = exception_node_set[0].at_xpath('ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows')
    expect(exception_text.text).to include("version can't be blank")

    expect(exception_node_set[1]['exceptionCode']).to eq('MissingParameterValue')
    expect(exception_node_set[1]['locator']).to eq('service')
    exception_text = exception_node_set[1].at_xpath('ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows')
    expect(exception_text.text).to include("service can't be blank")
  end
end