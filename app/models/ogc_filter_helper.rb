class OgcFilterHelper

  def self.process_queryable(ogc_filter, iso_queryable_name, cmr_parameter_name, wildcard_flag)
    cmr_query_hash = {}
    xpath_string = "//ogc:PropertyName[contains(text(), '#{iso_queryable_name}')]"
    property_name_node_set = ogc_filter.xpath(xpath_string, 'ogc' => 'http://www.opengis.net/ogc')
    if (property_name_node_set != nil && property_name_node_set[0] != nil)
      literal_node = property_name_node_set[0].next_element
      if (literal_node != nil && literal_node.name == 'Literal')
        literal_value = literal_node.text
        cmr_query_hash["#{cmr_parameter_name}"] = literal_value
        if (wildcard_flag)
          process_wildcard(cmr_query_hash, literal_node, cmr_parameter_name)
        end
      end
    end
    cmr_query_hash
  end

  private
  def self.process_wildcard(cmr_query_hash, literal_node, cmr_parameter_name)
    property_parent_node = literal_node.parent
    wilcard_attribute = property_parent_node['wildCard']
    literal_value = cmr_query_hash["#{cmr_parameter_name}"]
    if (!wilcard_attribute.blank? && literal_value.include?(wilcard_attribute))
      cmr_query_hash["options[#{cmr_parameter_name}][pattern]"] = true
      # replace wildcard occurence with CMR wildcard character
      if (wilcard_attribute != '*')
        cmr_query_hash["#{cmr_parameter_name}"] = literal_value.gsub(wilcard_attribute, '*')
      end
    end
  end
end