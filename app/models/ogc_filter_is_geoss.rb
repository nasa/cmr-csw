class OgcFilterIsGeoss

  def process(ogc_filter)
    cmr_query_hash = {}
    xpath_string = "//ogc:PropertyName[contains(text(), 'IsGeoss')]"
    is_geoss_node_set = ogc_filter.xpath(xpath_string, 'ogc' => 'http://www.opengis.net/ogc')
    if (is_geoss_node_set != nil && is_geoss_node_set[0] != nil)
      literal_node = is_geoss_node_set[0].next_element
      if (literal_node != nil && literal_node.name == 'Literal')
        literal_value = literal_node.text
        if (literal_value != nil)
          if (literal_value == 'true')
            cmr_query_hash['tag_key'] = Rails.configuration.geoss_data_core_tag
          else
            error_message = "#{literal_value} is not supported. Value must be set to 'true' in order to search only GEOSS datasets"
            Rails.logger.error(error_message)
            raise OwsException.new('IsGeoss', error_message)
          end
        else
          # if IsGeoss is present it must have a value
          error_message = "cannot be blank, it must be set to 'true' in order to search only GEOSS datasets"
          Rails.logger.error(error_message)
          raise OwsException.new('IsGeoss', error_message)
        end
      else
        error_message = "cannot be blank, it must be set to 'true' in order to search only GEOSS datasets"
        Rails.logger.error(error_message)
        raise OwsException.new('IsGeoss', error_message)
      end
    end
    cmr_query_hash
  end

end