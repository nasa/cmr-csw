require 'spec_helper'

describe 'view documentation' do
  include Capybara::DSL

  it 'contains the relevant static markup from the layout' do
    visit '/collections'
    expect(page).to have_link('Common Metadata Repository (CMR)', href: 'https://cmr.earthdata.nasa.gov')
    within('section.hero') do
      title = find('h1')
      expect(title.text).to eq('Catalog Service for the Web')
    end

    within('section.overview') do
      sub_title = find('h1')
      expect(sub_title.text).to eq('Supported requests')
      expect(page).to have_content('version 2.0.2')
      expect(page).to have_link('Catalog Service for the Web (CSW)', href: 'http://www.opengeospatial.org/standards/cat')
    end

    within('footer') do
      expect(page).to have_link("Release: #{Rails.configuration.version.strip}")
      expect(page).to have_link('Stephen Berrick')
      expect(page).to have_content('NASA Official: Stephen Berrick')
    end

  end

  it 'contains the correct description of GetCapabilities' do
    visit '/collections'
    within('section.get-capabilities') do
      expect(page).to have_css("h2:contains('GetCapabilities')")
      expect(page).to have_css("h3:contains('Supported methods')")
      within('ul.methods') do
        expect(page).to have_content('GET')
        expect(page).to have_content('POST')
      end
      expect(page).to have_css("h3:contains('Supported output formats')")
      within('ul.output-formats') do
        expect(page).to have_content('application/xml')
      end
    end
  end

  it 'contains the correct description of GetRecords' do
    visit '/collections'
    within('section.get-records') do
      expect(page).to have_css("h2:contains('GetRecords')")
      expect(page).to have_css("h3:contains('Supported methods')")
      within('ul.methods') do
        expect(page).to have_content('GET')
        expect(page).to have_content('POST')
      end
      expect(page).to have_css("h3:contains('Supported element set names')")
      within('ul.response-elements') do
        expect(page).to have_content('brief')
        expect(page).to have_content('summary')
        expect(page).to have_content('full')
      end
      expect(page).to have_css("h3:contains('Supported result types')")
      within('ul.result-types') do
        expect(page).to have_content('hits')
        expect(page).to have_content('results')
      end
      expect(page).to have_css("h3:contains('Supported output schemas')")
      expect(page).to have_css("h3:contains('Supported output formats')")
      within('ul.output-schemas') do
        expect(page).to have_link('ISO GMI', href: 'http://www.isotc211.org/2005/gmi')
        expect(page).to have_link('CSW', href: 'http://www.opengis.net/cat/csw/2.0.2')
        expect(page).to have_link('ISO GMD', href: 'http://www.isotc211.org/2005/gmd')
      end
      expect(page).to have_css("h3:contains('Supported output formats')")
      within('ul.output-formats') do
        expect(page).to have_content('application/xml')
      end
    end
  end

  it 'contains the correct description of GetRecordById' do
    visit '/collections'
    within('section.get-record-by-id') do
      expect(page).to have_css("h2:contains('GetRecordById')")
      expect(page).to have_css("h3:contains('Supported methods')")
      within('ul.methods') do
        expect(page).to have_content('GET')
        expect(page).to have_content('POST')
      end
      expect(page).to have_css("h3:contains('Supported element set names')")
      within('ul.response-elements') do
        expect(page).to have_content('brief')
        expect(page).to have_content('summary')
        expect(page).to have_content('full')
      end

      expect(page).to have_css("h3:contains('Supported output schemas')")
      within('ul.output-schemas') do
        expect(page).to have_link('ISO GMI', href: 'http://www.isotc211.org/2005/gmi')
        expect(page).to have_link('CSW', href: 'http://www.opengis.net/cat/csw/2.0.2')
        expect(page).to have_link('ISO GMD', href: 'http://www.isotc211.org/2005/gmd')
      end
      expect(page).to have_css("h3:contains('Supported output formats')")
      within('ul.output-formats') do
        expect(page).to have_content('application/xml')
      end
      expect(page).to have_link('GET https://www.example.com/collections?request=GetRecordById&service=CSW&version=2.0.2&outputSchema=http://www.isotc211.org/2005/gmi&ElementSetName=full&id=C14758250-LPDAAC_ECS', href: 'https://www.example.com/collections?request=GetRecordById&service=CSW&version=2.0.2&outputSchema=http://www.isotc211.org/2005/gmi&ElementSetName=full&id=C14758250-LPDAAC_ECS')
      expect(page).to have_content('<csw:Id>C14758250-LPDAAC_ECS</csw:Id>')
    end
  end

  it 'contains the correct description of Describe Record' do
    visit '/collections'
    within('section.describe-record') do
      expect(page).to have_css("h2:contains('DescribeRecord')")
      expect(page).to have_css("h3:contains('Supported methods')")
      within('ul.methods') do
        expect(page).to have_content('GET')
        expect(page).to have_content('POST')
      end
      expect(page).to have_css("h3:contains('Supported namespaces')")
      within('ul.namespaces') do
        expect(page).to have_link('http://www.isotc211.org/2005/gmi', href: 'http://www.isotc211.org/2005/gmi')
        expect(page).to have_link('http://www.opengis.net/cat/csw/2.0.2', href: 'http://www.opengis.net/cat/csw/2.0.2')
        expect(page).to have_link('http://www.isotc211.org/2005/gmd', href: 'http://www.isotc211.org/2005/gmd')
      end
      expect(page).to have_css("h3:contains('Supported type names')")
      within('ul.type-names') do
        expect(page).to have_content('csw:Record')
        expect(page).to have_content('gmi:MI_Metadata')
        expect(page).to have_content('gmd:MD_Metadata')
      end
    end
  end

  it 'contains the correct description of Get Domain' do
    visit '/collections'
    within('section.get-domain') do
      expect(page).to have_css("h2:contains('GetDomain')")
      expect(page).to have_css("h3:contains('Supported methods')")
      within('ul.methods') do
        expect(page).to have_content('GET')
        expect(page).to have_content('POST')
      end
      expect(page).to have_css("h3:contains('Supported PropertyName values')")
      expect(page).to have_css("h3:contains('Supported ParameterName values')")
    end
  end
end