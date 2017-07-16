class OgcFilterIsCwic

  def process(ogc_filter)
    cmr_query_hash = {}
    xpath_string = "//ogc:PropertyName[contains(text(), 'IsCwic')]"
    is_cwic_node_set = ogc_filter.xpath(xpath_string, 'ogc' => 'http://www.opengis.net/ogc')
    if (is_cwic_node_set != nil && is_cwic_node_set[0] != nil)
      literal_node = is_cwic_node_set[0].next_element
      if (literal_node != nil && literal_node.name == 'Literal')
        literal_value = literal_node.text
        if (literal_value != nil)
          if (literal_value == 'true')
            # add the cwic tags to the CMR query
            # include_tags=org.ceos.wgiss.cwic.granules.prod&tag_key=org.ceos.wgiss.cwic.granules.prod
            # the include_tags is already added by default for org.ceos.wgiss.cwic.granules.prod
            cmr_query_hash["tag_key"] = Rails.configuration.cwic_tag
          else
            error_message = "#{literal_value} is not supported. Value must be set to 'true' in order to search only CWIC datasets"
            Rails.logger.error(error_message)
            raise OwsException.new('IsCwic', error_message)
          end
        else
          # if IsCwic is present it must have a value
          error_message = "cannot be blank, it must be set to 'true' in order to search only CWIC datasets"
          Rails.logger.error(error_message)
          raise OwsException.new('IsCwic', error_message)
        end
      else
        error_message = "cannot be blank, it must be set to 'true' in order to search only CWIC datasets"
        Rails.logger.error(error_message)
        raise OwsException.new('IsCwic', error_message)
      end
    end
    cmr_query_hash
  end

end