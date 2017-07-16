module ApplicationHelper
  def to_records(raw_collections_doc, output_schema, response_element, parameters_array=nil)
    output_schema_label = 'iso_gmi'
    if output_schema == 'http://www.opengis.net/cat/csw/2.0.2'
      output_schema_label = 'csw'
    elsif output_schema == 'http://www.isotc211.org/2005/gmd'
      output_schema_label = 'iso_gmd'
      # Some elements become 'empty' once the gmi stuff is removed.
      raw_collections_doc.root.xpath('//gmd:lineage', 'gmd' => 'http://www.isotc211.org/2005/gmd').remove
      # Remove elements that contain a gmi element - this is limited to gmi:acquisitionInformation and the above

      raw_collections_doc.root.xpath('//gmi:acquisitionInformation', 'gmi' => 'http://www.isotc211.org/2005/gmi').each do |node|
        node.remove
      end
    end

    translate(raw_collections_doc, "app/helpers/#{output_schema_label}_#{response_element}.xslt", parameters_array)
  end

  def translate(document, stylesheet, parameters_array=nil)
    # must use File.open instead of File.read so that xlst:include and xslt:import can be resolved
    template = Nokogiri::XSLT(File.open(stylesheet, 'rt'))
    transformed_document = template.transform(document, Nokogiri::XSLT.quote_params(parameters_array))
    transformed_document.to_xml
  end
end
